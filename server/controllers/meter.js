const jwt = require("jsonwebtoken");
const Users = require("../models/user");
const generateStatement = require("../utils/generate-statement");
const secret = process.env.TOKEN_SECRET;
const path = require('path');
const { roboflowInference } = require('../utils/roboflow-inference')

let uploadImage = async (req, res) => {
  try {
    if (!req.file) {
      return res
        .status(200)
        .send({ message: "File Not Found.", success: false });
    }

    // Perform Meter OCR
    const response = { value: (await roboflowInference(path.join(__dirname, `../uploads/${req.file.filename}`), 20, 50)).join('') };
    console.log(`Meter Reading Detected: ${response.value}`);
    if(isNaN(response.value)) {
      throw new Error('Meter Reading Detection Failed');
    }
    

    // Detected Reading Value
    let readingValue = parseInt(response.value);
    if(isNaN(readingValue)) {
      throw new Error('Meter Reading Detection Failed');
    }
    res.status(200).send({
      message: "Image Uploaded",
      success: true,
      filePath: req.file.filename,
      readingValue: readingValue,
    });
  } catch (error) {
    res.status(200).send({ message: error.toString(), success: false });
  }
};

let processImage = async (req, res) => {
  try {

    // File Path
    let filePath = req.body.filePath;
    let readingValue = parseInt(req.body.meterReading);

    // Get the user with their readings
    let user = await Users.findById(req.user.id);

    // Get previous month's last reading
    let previousReading = 0;
    if (user.meterReadings && user.meterReadings.length > 0) {
      const readings = user.meterReadings;
      const currentDate = new Date();
      const previousMonth = new Date(currentDate.setMonth(currentDate.getMonth() - 1));

      const previousMonthReadings = readings.filter(reading => {
        const readingDate = new Date(reading.timestamp);
        return readingDate.getMonth() === previousMonth.getMonth() &&
          readingDate.getFullYear() === previousMonth.getFullYear();
      });

      if (previousMonthReadings.length > 0) {
        previousReading = previousMonthReadings[previousMonthReadings.length - 1].reading;
      }
    }

    // If no previous reading, use initial reading
    if(previousReading === 0) {
      previousReading = user.initialReading;
    }

    // Calculate units consumed
    if(previousReading > readingValue) {
      throw new Error('Current reading should be greater than previous reading');
    }
    const unitsConsumed = readingValue - previousReading;

    // Generate statement
    const now = new Date();
    const generateBillNumber = (date) => {
      return `${date.getFullYear()}${(date.getMonth() + 1).toString().padStart(2, '0')}${date.getDate().toString().padStart(2, '0')}${Math.random().toString(36).substr(2, 6).toUpperCase()}`;
    };
    const billNumber = generateBillNumber(now);

    // Update the Reading of User
    user = await Users.findByIdAndUpdate(
      req.user.id,
      {
        $push: { meterReadings: { reading: readingValue, unitsConsumed: unitsConsumed, meterImage: filePath, billNumber: billNumber } },
      },
      { new: true }
    );

    res.status(200).send({
      message: "Reading Detected",
      reading: user.meterReadings[user.meterReadings.length - 1],
      previousReading: previousReading,
      unitsConsumed: unitsConsumed,
      success: true,
    });
  } catch (error) {
    res.status(200).send({ message: error.toString(), success: false });
  }
};

let detailMeterReading = async (req, res) => {
  try {
    // Get user data, assuming readings is a field in the user document
    let user = await Users.findById(req.user.id);

    // Ensure readings is an array
    if (!user || !Array.isArray(user.meterReadings)) {
      return res
        .status(404)
        .send({ error: "Users/Readings Not Found", success: false });
    }

    const readings = user.meterReadings;
    const monthlyReadings = readings.reduce((acc, entry) => {
      const date = new Date(entry.timestamp);
      const monthYearKey = `${date.getUTCFullYear()}-${date.getUTCMonth() + 1}`;

      if (!acc[monthYearKey]) {
        acc[monthYearKey] = [];
      }
      acc[monthYearKey].push(entry);
      return acc;
    }, {});

    // Find the last reading for each month
    const highestEachMonth = Object.keys(monthlyReadings).map(
      (monthYearKey) => {
        const entries = monthlyReadings[monthYearKey];
        entries.sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
        const lastEntry = entries[entries.length - 1];
        const date = new Date(lastEntry.timestamp);
        return {
          reading: lastEntry.unitsConsumed,
          date: date.getDate(),
          month: date.getUTCMonth() + 1,
          year: date.getUTCFullYear(),
          billNumber: lastEntry.billNumber,
        };
      }
    );

    // Sort by year and month to ensure chronological order
    highestEachMonth.sort((a, b) => a.year - b.year || a.month - b.month);

    // Calculate percentage difference and positive/negative status
    for (let i = 1; i < highestEachMonth.length; i++) {
      const current = highestEachMonth[i];
      const previous = highestEachMonth[i - 1];

      const difference = current.reading - previous.reading;
      const percentageChange = (difference / previous.reading) * 100;

      current.percentageChange = Math.abs(percentageChange.toFixed(2)); // Absolute value for display
      current.status = difference >= 0 ? "negative" : "positive";
    }

    // Set the first month's percentage change and status to null, as there is no previous month to compare
    if (highestEachMonth.length > 0) {
      highestEachMonth[0].percentageChange = 0.0;
      highestEachMonth[0].status = "neutral";
    }

    res.send({
      message: "Found User Readings Information",
      success: true,
      readings: highestEachMonth,
    });
  } catch (error) {
    console.error(error);
    res.status(200).send({ error: "Invalid Request", success: false });
  }
};

// Generate Statement for Meter Reading
const downloadStatement = async (req, res) => {
  try {

    const { billNumber } = req.params;

    // Find user and their readings
    const user = await Users.findById(req.user.id);
    if (!user) {
      return res.status(200).send({ message: "User not found", success: false });
    }

    // Find reading with specific bill number
    const reading = user.meterReadings.find(reading => reading.billNumber === billNumber);

    if (!reading) {
      return res.status(200).send({ 
        message: "No reading found for specified bill number", 
        success: false 
      });
    }

    // Generate PDF statement
    const statement = await generateStatement(reading.unitsConsumed, {
      name: user.name,
      accountNumber: user.id,
    }, {
      billNumber: reading.billNumber,
      billDate: reading.timestamp,
      dueDate: reading.dueDate,
    })

    res.download(statement, path.join(__dirname, '/statements/', `statement-${billNumber}.pdf`), (err) => {
      if (err) {
        console.error('Error downloading file:', err);
        return res.status(200).send({ message: err.toString(), success: false });
      }
    });

  } catch (error) {
    console.error(error);
    res.status(200).send({ message: error.toString(), success: false });
  }
};

const billPrediction = async (req, res) => {
  try {
    
    // User Object
    const user = await Users.findById(req.user.id);
    if (!user) {
      return res.status(200).send({ message: "User not found", success: false });
    }
    
    // Last Meter Reading of User
    const lastReading = await user.meterReadings[user.meterReadings.length - 1];
    if (!lastReading) {
      return res.status(200).send({ 
        message: "No meter readings found", 
        success: false 
      });
    }

    // Get date from last reading's timestamp
    const readingDate = new Date(lastReading.timestamp);
    const readingMonth = readingDate.getMonth();
    const readingYear = readingDate.getFullYear();

    // Calculate average units per day based on last reading
    const averageUnitsPerDay = lastReading.unitsConsumed / readingDate.getDate();

    // Get total days in the reading's month
    const daysInMonth = new Date(readingYear, readingMonth + 1, 0).getDate();
    
    // Calculate predicted units for full month
    const predictedUnits = Math.round(averageUnitsPerDay * daysInMonth);

    // Calculate bill amount based on predicted units
    const basicRate = 0.15; // Basic rate per unit
    const serviceCharge = 10; // Fixed service charge
    const taxRate = 0.05; // 5% tax rate

    const basicCharge = predictedUnits * basicRate;
    const tax = basicCharge * taxRate;
    const totalBill = basicCharge + serviceCharge + tax;

    res.status(200).send({
      message: "Bill prediction calculated successfully", 
      data: {
        monthOfReading: readingDate.toLocaleString('default', { month: 'long' }),
        averageUnitsPerDay: Number(averageUnitsPerDay.toFixed(2)),
        averageUnitsPerMonth: predictedUnits,
        unitsConsumedSoFar: lastReading.unitsConsumed,
        daysPassed: readingDate.getDate(),
        daysInMonth,
        predictedUnits,
        billDetails: {
          basicCharge: Number(basicCharge.toFixed(2)),
          serviceCharge: serviceCharge,
          tax: Number(tax.toFixed(2)),
          totalBill: Number(totalBill.toFixed(2))
        }
      },
      success: true
    });


  } catch (error) {
    res.status(200).send({ message: error.toString(), success: false });
  }
}




module.exports = { uploadImage, processImage, detailMeterReading, downloadStatement, billPrediction };
