const express = require("express");
const router = express.Router();
const {
  Login,
  Signup,
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
  passwordResetValidation
} = require("../utils/validation");

router.post("/signup", validate(signupValidation), Signup);

router.post("/login", validate(loginValidation), Login);

router.get("/verify/:token" , verifyAccount);

router.post("/passwordResetRequest", validate(passwordResetEmailValidation), resetPasswordRequest);

router.get("/password-reset/:token", resetPasswordForm);

router.post("/reset-password", validate(passwordResetValidation), resetPassword);

module.exports = router;
