const express = require("express");
const router = express.Router();

// Controller, Middleware and Utils
const {
  Login,
  Signup,
  ProfileDetails,
  UpdateProfile,
  verifyAccount,
  resetPassword,
  resetPasswordForm,
  resetPasswordRequest,
} = require("../controllers/user");
const { VerifyTokenGET, VerifyTokenPOST } = require("../utils/tokenVerify");
const {
  validate,
  loginValidation,
  signupValidation,
  passwordResetEmailValidation,
  passwordResetValidation,
} = require("../utils/validation");

// User Routes
router.post("/signup", validate(signupValidation), Signup);
router.post("/login", validate(loginValidation), Login);
router.get("/verify/:token", VerifyTokenGET, verifyAccount);
router.post("/passwordResetRequest", validate(passwordResetEmailValidation), resetPasswordRequest);
router.get("/password-reset/:token", VerifyTokenGET, resetPasswordForm);
router.post("/reset-password", validate(passwordResetValidation), resetPassword);
router.get("/profile/:token", VerifyTokenGET, ProfileDetails);
router.post("/updateProfile", VerifyTokenPOST, UpdateProfile);

module.exports = router;
