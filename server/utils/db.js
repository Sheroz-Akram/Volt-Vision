const mongoose = require('mongoose');
require('dotenv').config();

const MongodbConnectionURI = process.env.CONNECTION_URI;

async function dbConnection() {
  try {
    await mongoose.connect(MongodbConnectionURI);
    console.log("Connected to Database");
  } catch (error) {
    console.error("Database connection error:", error);
  }
}

module.exports = dbConnection;
