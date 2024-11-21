const express = require("express");
const router = express.Router();
const {
  Login,
  Signup,
  ProfileDetails,
  UpdateProfile,
  verifyAccount,
  ChangePassword,
  VerifyToken,
  DeleteUserAcc,
  resetPassword,
  resetPasswordForm,
  resetPasswordRequest,
  
} = require("../controllers/user");

const {
  validate,
  loginValidation,
  signupValidation,
  passwordResetEmailValidation,
  passwordResetValidation,
} = require("../utils/validation");
const { VerifyTokenGET, VerifyTokenPOST } = require("../utils/tokenVerify");

router.post("/signup", validate(signupValidation), Signup);

router.post("/login", validate(loginValidation), Login);

router.get("/verify/:token", VerifyTokenGET, verifyAccount);

router.post("/passwordResetRequest", validate(passwordResetEmailValidation), resetPasswordRequest);

router.get("/password-reset/:token", VerifyTokenGET, resetPasswordForm);

router.post("/reset-password", validate(passwordResetValidation), resetPassword);

router.get("/profile/:token", VerifyTokenGET, ProfileDetails);

router.post("/updateProfile", VerifyTokenPOST, UpdateProfile);

module.exports = router;
