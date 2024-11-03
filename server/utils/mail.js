const nodemailer = require("nodemailer");
require("dotenv").config();

// Create a transporter object using SMTP
let transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT,
  secure: true,
  auth: {
    user: process.env.SMTP_EMAIL_ADDRESS,
    pass: process.env.SMTP_EMAIL_PASSWORD,
  },
});

async function sendEmail(recipientEmail, subject, body) {
  let mailOptions = {
    from: process.env.SMTP_EMAIL_ADDRESS,
    to: recipientEmail,
    subject: subject,
    text: body,
    html: `<p>${body}</p>`,
  };

  try {
    let info = await transporter.sendMail(mailOptions);
    console.log("Email sent:", info.response);
  } catch (error) {
    console.error("Error occurred:", error);
    throw new Error("Failed to send email");
  }
}

module.exports = {
  sendEmail,
};
