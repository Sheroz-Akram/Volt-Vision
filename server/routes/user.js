const express = require("express");
const router = express.Router();
const {
  Login,
  Signup,
  VerifyOTP,
  ResendOtp,
  ChangePassword,
  VerifyToken,
  DeleteUserAcc,
} = require("../controllers/user");

const {
  validate,
  loginValidation,
  signupValidation,
} = require("../utils/validation");

router.post("/signup", validate(signupValidation), Signup);

router.post("/login", validate(loginValidation), Login);

router.post("/change-password", VerifyToken, ChangePassword);

router.delete("/delete-account/:userId", VerifyToken, DeleteUserAcc);

module.exports = router;
