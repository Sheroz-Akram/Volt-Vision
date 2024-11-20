const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    min: [4, "Too Short name"],
    max: [16, "Too long name"],
  },
  email: {
    type: String,
    min: [4, "Too Short Email"],
    max: [20, "Too long email"],
  },
  password: {
    type: String,
    min: [6, "Too Short Password"],
    max: [20, "Too long Password"],
  },
  isVerified: {
    type: Boolean,
    default: false,
  },
  meterReadings: [
    {
      reading: {
        type: Number,
        required: true,
      },
      unitsConsumed: {
        type: Number,
        default: 0
      },
      meterImage: {
        type: String,
        default: null
      },
      billNumber: {
        type: String,
        default: null
      },
      dueDate: {
        type: Date,
        default: function() {
          const now = new Date();
          return new Date(now.getFullYear(), now.getMonth() + 1, 0);
        }
      },
      timestamp: {
        type: Date,
        default: Date.now,
      },
    },
  ],
});

const Users = new mongoose.model("users", userSchema);

module.exports = Users;
