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
});

const Users = new mongoose.model("users", userSchema);

module.exports = Users;
