const Users = require("../models/user");
const bcrypt = require("bcryptjs");
const { sendEmail } = require("../utils/mail");
const jwt = require("jsonwebtoken");
const secret = process.env.TOKEN_SECRET;
const host = process.env.HOST;
const port = process.env.PORT;

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

    // Send Email to User for Verfication
    await sendEmail(
      email,
      "Volt Vision - Account Verification",
      `Please verify your account by clicking on the following link: <a href="http://${host}:${port}/users/verify/${token}">Click Here</a>`
    );

    res.status(200).send({ message: "Account Created Successfully. Please verify account now through mail.", success: true });
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

    const token = jwt.sign({ id: user._id, email: user.email }, secret, {
      algorithm: "HS256",
      expiresIn: "7d",
    });

    if (user.isVerified === false){
      // Send Email to User for Verfication
      await sendEmail(
        email,
        "Volt Vision - Account Verification",
        `Please verify your account by clicking on the following link: <a href="http://${host}:${port}/users/verify/${token}">Click Here</a>`
      );

      return res
        .status(200)
        .send({ message: "Please verify your account. Verification Link Send to Email", success: false });
    }
      
    res.status(200).send({ message: "Login Successfully", success: true, token: token });
  } catch (error) {
    res.status(200).send({ message: error.toString(), success: false});
  }
};


// Verify the Account of User
let verifyAccount = async (req, res) => {
  try {
    const token = req.params.token ;
    if (!token){
      return res.render('message', { title: "Error", message: "Token not Found" });
    }
    const decodedToken = jwt.verify(token, secret);
    if (!decodedToken)
    {
      return res.render('message', { title: "Error", message: "Token is Expired" });
    }
    const user = await Users.findOne({ email: decodedToken.email });
    if(user.isVerified === true){
      return res.render('message', { title: "Error", message: "Account is already verified." });
    }
    user.isVerified = true;
    await user.save();
    res.render('message', { title: "Success", message: "Your Account Verified Successfully!" });
  } catch (error) {
    res.render('message', { title: "Error", message: "Invalid Request/Expired Token" });
  }
}


// Reset the Passowrd of User
let resetPasswordRequest = async (req, res) => {
  try{
    const { email } = req.body;

    // Find the USer
    const user = await Users.findOne({ email });
    if (!user){
      return res
        .status(200)
        .send({ message: "No Account exists with this email", success: false });
    }
    
    // Generate Token for Authentication
    const token = jwt.sign({ id: user._id, email: user.email }, secret, {
      algorithm: "HS256",
      expiresIn: "7d",
    });

    // Send Reset Password Link
    await sendEmail(
      email,
      "Volt Vision - Password Reset Request",
      `Please reset your account password by clicking on the following link: <a href="http://${host}:${port}/users/password-reset/${token}">Click Here</a>`
    );
    res.status(200).send({ message: "Password Reset Link Send. Check Email", success: true });
  }
  catch (error) {
    res.status(200).send({ message: error.toString(), success: false});
  }
}

// Diaplay Reset Password Form
let resetPasswordForm = async (req, res) => {
  try{
    const token = req.params.token ;
    if (!token){
      return res.render('message', { title: "Error", message: "Token not Found" });
    }
    return res.render('password', { token: token});
  }
  catch (error) {
    res.render('message', { title: "Error", message: "Invalid Request" });
  }
}

// Reset the Password of the User
let resetPassword = async (req, res) => {
  try{
    const { token, newPassword, confirmPassword } = req.body;
    if(newPassword != confirmPassword){
      return res.render('message', { title: "Error", message: "Password does not match" });
    }
    if (!token){
      return res.render('message', { title: "Error", message: "Token not Found" });
    }
    const decodedToken = jwt.verify(token, secret);
    if (!decodedToken)
    {
      return res.render('message', { title: "Error", message: "Token is Expired" });
    }
    const hashedPassowrd = await bcrypt.hash(newPassword, 9);
    const user = await Users.findOne({ email: decodedToken.email });
    user.password = hashedPassowrd;
    await user.save()
    res.render('message', { title: "Success", message: "Password Reset Successfully" });
  }
  catch (error) {
    console.log(error)
    res.render('message', { title: "Error", message: "Invalid Request" });
  }
}




let VerifyToken = async (req, res, next) => {
  const token = req.headers.authorization
    ? req.headers.authorization.split(" ")[1]
    : null;
  if (!token)
    return res.status(200).send({
      message: "Your Session has expired, Login to continue",
      success: true,
    });

  try {
    const decodedToken = jwt.verify(token, secret);
    if (!decodedToken)
      return res.status(200).send({
        message: "Your Session has expired, Login to continue",
        success: true,
      });
    next();
  } catch (error) {
    return res.status(200).send({ message: error.message, expired: true });
  }
};


module.exports = { Signup, Login, verifyAccount, resetPasswordRequest, resetPasswordForm, resetPassword, VerifyToken};
