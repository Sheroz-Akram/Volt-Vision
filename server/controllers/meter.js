const jwt = require("jsonwebtoken");
const Users = require("../models/user");
const secret = process.env.TOKEN_SECRET;

let uploadImage = async (req, res) => {
  try {
    if (!req.file) {
      return res
        .status(200)
        .send({ message: "File Not Found.", success: false });
    }
    res.status(200).send({
      message: "Image Uploaded",
      success: true,
      filePath: req.file.filename,
    });
  } catch (error) {
    res.status(200).send({ message: error.toString(), success: false });
  }
};

let processImage = async (req, res) => {
  try {
    let readingValue = Math.floor(Math.random() * (500 - 100) + 100);
    // Update the Reading of User
    let user = await Users.findByIdAndUpdate(
      req.user.id,
      {
        $push: { meterReadings: { reading: readingValue } },
      },
      { new: true }
    );
    res.status(200).send({
      message: "Reading Detected",
      reading: user.meterReadings[user.meterReadings.length - 1],
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
          reading: lastEntry.reading,
          month: date.getUTCMonth() + 1,
          year: date.getUTCFullYear(),
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
      current.status = difference >= 0 ? "positive" : "negative";
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

module.exports = { uploadImage, processImage, detailMeterReading };