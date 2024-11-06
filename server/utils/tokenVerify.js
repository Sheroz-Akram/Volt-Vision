const jwt = require("jsonwebtoken");
const secret = process.env.TOKEN_SECRET;

let VerifyToken = async (req, res, next) => {
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
    next();
  } catch (error) {
    return res
      .status(403)
      .send({ message: "Invalid Token Provided", expired: true });
  }
};

module.exports = { VerifyToken };
