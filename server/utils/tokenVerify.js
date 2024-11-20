const jwt = require("jsonwebtoken");
const secret = process.env.TOKEN_SECRET;


let VerifyTokenPOST = async (req, res, next) => {
  const { token } = req.body;
  if (!token)
    return res.status(403).send({
      message: "Token not Found",
      expired: true,
    });

  try {
    const decodedToken = jwt.verify(token, secret);
    if (!decodedToken)
      return res.status(403).send({
        message: "Token has expired",
        expired: true,
      });
    req.user = decodedToken;
    req.token = token;
    next();
  } catch (error) {
    return res
      .status(403)
      .send({ message: "Invalid Token Provided", expired: true });
  }
};

let VerifyTokenGET = async (req, res, next) => {
  const { token } = req.params;
  try {
    if (!token) {
      return res.render('message', { title: "Error", message: "Token not Found" });
    }
    const decodedToken = jwt.verify(token, secret);
    if (!decodedToken) {
      return res.render('message', { title: "Error", message: "Token has Expired" });
    }
    req.user = decodedToken;
    req.token = token;
    next();
  } catch (error) {
    res.render('message', { title: "Error", message: "Invalid Request/Expired Token" });
  }

}
module.exports = { VerifyTokenPOST, VerifyTokenGET };
