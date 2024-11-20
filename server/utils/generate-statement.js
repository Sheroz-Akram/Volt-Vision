const pdf = require("html-pdf");
const fs = require("fs");
const uuid = require("uuid")

async function generateStatement(
  units, 
  customerDetails = {
    name: '',
    accountNumber: ''
  },
  billDetails = {
    billNumber: '',
    billDate: '',
    dueDate: ''
  },
  unitRates = { 
    basic: 0.15, 
    service: 10, 
    tax: 0.05 
  }
) {
  try {
    const electricityCharges = units * unitRates.basic;
    const serviceCharges = unitRates.service;
    const taxAmount = electricityCharges * unitRates.tax;
    const totalAmount = electricityCharges + serviceCharges + taxAmount;

    const formatDate = (date) => {
      return new Date(date).toLocaleDateString('en-GB', {
        day: '2-digit',
        month: 'short',
        year: 'numeric'
      });
    };

    const htmlContent = `
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Electricity Bill</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 0;
                    padding: 0;
                }
                .bill-container {
                    width: 80%;
                    margin: auto;
                    padding: 20px;
                    border: 1px solid #ccc;
                    border-radius: 8px;
                    background-color: #f9f9f9;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }
                .header {
                    text-align: center;
                    margin-bottom: 20px;
                }
                .header h1 {
                    margin: 0;
                    color: #333;
                }
                .info {
                    margin-bottom: 20px;
                    display: flex;
                    justify-content: space-between;
                }
                .info div {
                    width: 48%;
                }
                .info div h3 {
                    margin-bottom: 5px;
                    font-size: 14px;
                    color: #555;
                }
                .info div p {
                    margin: 0;
                    font-size: 14px;
                    color: #333;
                }
                .bill-details {
                    width: 100%;
                    border-collapse: collapse;
                    margin-bottom: 20px;
                }
                .bill-details th,
                .bill-details td {
                    border: 1px solid #ccc;
                    text-align: left;
                    padding: 8px;
                }
                .bill-details th {
                    background-color: #f2f2f2;
                }
                .total {
                    text-align: right;
                    margin-top: 10px;
                    font-size: 18px;
                    font-weight: bold;
                }
                .footer {
                    text-align: center;
                    margin-top: 20px;
                    font-size: 14px;
                    color: #888;
                }
            </style>
        </head>
        <body style="display: flex; justify-content: center; align-items: center; min-height: 100vh;">
            <div style="display: flex; justify-content: center; align-items: center; min-height: 100vh;">
                <div class="bill-container">
                    <div class="header">
                        <h1>Volt Vision</h1>
                        <p>AI-Based Smart Meter Reading System</p>
                    </div>
                    <div class="info">
                        <div class="info-section">
                            <h3>Customer Details</h3>
                            <p><strong>Name:</strong> ${customerDetails.name}</p>
                            <p><strong>Account No:</strong> <span class="highlight">${customerDetails.accountNumber}</span></p>
                        </div>
                        <div class="info-section">
                            <h3>Bill Information</h3>
                            <p><strong>Bill No:</strong> <span class="highlight">${billDetails.billNumber}</span></p>
                            <p><strong>Bill Date:</strong> ${formatDate(billDetails.billDate)}</p>
                            <p><strong>Due Date:</strong> ${formatDate(billDetails.dueDate)}</p>
                        </div>
                    </div>
                    <table class="bill-details">
                        <thead>
                            <tr>
                                <th>Description</th>
                                <th>Unit Rate</th>
                                <th>Units Consumed</th>
                                <th>Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Electricity Charges</td>
                                <td>$${unitRates.basic.toFixed(2)}</td>
                                <td>${units}</td>
                                <td>$${electricityCharges.toFixed(2)}</td>
                            </tr>
                            <tr>
                                <td>Service Charges</td>
                                <td>-</td>
                                <td>-</td>
                                <td>$${serviceCharges.toFixed(2)}</td>
                            </tr>
                            <tr>
                                <td>Taxes (${(unitRates.tax * 100)}%)</td>
                                <td>-</td>
                                <td>-</td>
                                <td>$${taxAmount.toFixed(2)}</td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="total">
                        Total Amount: $${totalAmount.toFixed(2)}
                    </div>
                    <div class="footer">
                        <p>Thank you for using Volt Vision! For assistance, contact us at help.voltvision@gmail.com.</p>
                    </div>
                </div>
            </div>
        </body>
        </html>
    `;
    const savePath = `./statements/${uuid.v4()}.pdf`;
    
    return new Promise((resolve, reject) => {
      pdf.create(htmlContent).toFile(savePath, (err, res) => {
        if (err) {
          console.log("Error:", err);
          reject(err);
        }
        console.log("PDF saved to:", res.filename);
        resolve(savePath);
      });
    });
  } catch (error) {
    console.error("Error generating or saving PDF:", error);
    throw error;
  }
}

module.exports = generateStatement;
