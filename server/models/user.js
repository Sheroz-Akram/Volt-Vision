const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    min: [4, "Too Short username"],
    max: [16, "Too long username"],
  },
  email: {
    type: String,
    min: [10, "Too Short Email"],
    max: [20, "Too long email"],
  },
  password: {
    type: String,
    min: [6, "Too Short Password"],
    max: [20, "Too long Password"],
  },
});

const Users = new mongoose.model("users", userSchema);

module.exports = Users;
