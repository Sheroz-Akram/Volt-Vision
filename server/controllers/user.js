const Users = require("../models/user");
const bcrypt = require("bcryptjs");
const { sendEmail } = require("../utils/mail");
const jwt = require("jsonwebtoken");
const secret = process.env.TOKEN_SECRET;

let Signup = async (req, res) => {
  let { name, email, password } = req.body;

  try {
    const emailExist = await Users.findOne({ email });
    if (emailExist)
      return res
        .status(200)
        .send({ message: "Email already exists", success: false });

    const hashedPassowrd = await bcrypt.hash(password, 9);

    // Create Mew User
    const user = new Users({
      name,
      email,
      password: hashedPassowrd,
    });
    await user.save();

    // Generate JWT Tokken
    const token = jwt.sign({ id: user._id, email: user.email }, secret, {
      algorithm: "HS256",
      expiresIn: "7d",
    });

    res.status(200).send({ message: "Account Created Successfully", success: true, token: token });
  } catch (error) {
    res.status(500).send({ message: error.toString(), success: false});
  }
};

let Login = async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await Users.findOne({ email });
    if (!user)
      return res
        .status(200)
        .send({ message: "No Account exists with this email", success: false });

    let verifyPassword = await bcrypt.compare(password, user.password);
    if (!verifyPassword)
      return res
        .status(200)
        .send({ message: "Invalid Password Entered", success: false });

    const token = jwt.sign({ id: user._id, role: "user" }, secret, {
      algorithm: "HS256",
      expiresIn: "7d",
    });

    res.status(200).send({ message: "Login Successfully", success: true, token: token });
  } catch (error) {
    console.log(error);
    res.status(200).send({ message: error.toString(), success: false});
  }
};

let VerifyOTP = async (req, res) => {
  let { email, otp } = req.body;
  otp=parseInt(otp)
  try {
    const user = await Users.findOne({ email });
    if (!user)
      return res
        .status(404)
        .send({ message: "No email id exists with this name", success: false });

    if (user.isVerified === true)
      return res.status(404).send({
        message: "User already verified. Invalid Request",
        success: false,
      });

    if (user.otp !== otp)
      return res
        .status(404)
        .send({ message: "OTP Code is Invalid", success: false });

    user.isVerified = true;
    const updatedUser=await user.save();
    user.password=undefined
    user.otp=undefined
    user.__v = undefined;

    const token = jwt.sign({ id: user._id, role: "user" }, secret, {
      algorithm: "HS256",
      expiresIn: "7d",
    });

    return res
      .status(200)
      .send({ user:updatedUser,token, success: true, message: "User Account Verified." });
  } catch (error) {
    console.log(error);
    res.status(500).send({ error, success: false });
  }
};

const ResendOtp = async (req, res) => {
  const { email } = req.body;

  try {
    const user = await Users.findOne({ email });
    if (!user) {
      return res.status(404).send({ message: "User not found", success: false });
    }

    const newOtp = Math.floor(100000 + Math.random() * 900000);

    await sendEmail(
      email,
      "OTP Code - Verification",
      `Your new OTP code is: ${newOtp}. Please use this code to verify your account.`
    );

    user.otp = newOtp;
    await user.save();

    res.status(200).send({ message: "OTP resent successfully", success: true });
  } catch (error) {
    res.status(500).send({ message: "Error resending OTP", success: false, error: error.toString() });
  }
};

let ChangePassword = async (req, res) => {
  let { email, password, newPassword } = req.body;
  const user = await Users.findOne({ email });
  if (!user)
    return res.status(404).send({ message: "user not found!", success: false });

  let verifyPassword = await bcrypt.compare(password, user.password);
  if (!verifyPassword)
    return res
      .status(400)
      .send({ message: "Current Password is Inavlid!", success: false });

  let hashedPassword = await bcrypt.hash(newPassword, 9);
  await Users.updateOne({ email }, { $set: { password: hashedPassword } });
  res
    .status(200)
    .send({ message: "Password is Updated Successfully!", success: true });
};

let VerifyToken = async (req, res, next) => {
  const token = req.headers.authorization
    ? req.headers.authorization.split(" ")[1]
    : null;
  if (!token)
    return res.status(404).send({
      message: "Your Session has expired, Login to continue",
      expired: true,
    });

  try {
    const decodedToken = jwt.verify(token, secret);
    if (!decodedToken)
      return res.status(400).send({
        message: "Your Session has expired, Login to continue",
        expired: true,
      });
    next();
  } catch (error) {
    console.log(error);
    return res.status(500).send({ message: error.message, expired: true });
  }
};

let DeleteUserAcc = async (req, res) => {
  try {
    const user = await Users.deleteOne({ _id: req.params.userId });

    if (user.deletedCount == 0) {
      return res
        .status(404)
        .send({ message: "No user against this id", success: false });
    }
    res.status(200).send({ user, success: true });
  } catch (error) {
    res.status(500).send({ error: error.toString(), success: false });
  }
};

module.exports = { Signup, Login, VerifyOTP,ResendOtp, ChangePassword, VerifyToken, DeleteUserAcc };
