const { z } = require("zod");

const emailValidation = z.string().email({ message: "Invalid email address" });

const nameValidation = z
  .string()
  .min(3, { message: "Name must be at least 3 characters long" })
  .max(30, { message: "Name must be at most 30 characters long" });

const passwordValidation = z
  .string()
  .min(6, { message: "Password must be at least 6 characters long" })
  .regex(/(?=.*[a-z])/, {
    message: "Password must contain at least one lowercase letter",
  })
  .regex(/(?=.*[A-Z])/, {
    message: "Password must contain at least one uppercase letter",
  })
  .regex(/(?=.*[!@#$%^&*(),.?":{}|<>])/, {
    message: "Password must contain at least one special character",
  });

const signupValidation = z.object({
  name: nameValidation,
  email: emailValidation,
  password: passwordValidation,
});

const loginValidation = z.object({
  email: emailValidation,
  password: passwordValidation,
});


// Zod middleware to validate request body
const validate = (schema) => (req, res, next) => {
  const result = schema.safeParse(req.body);
  
  if (!result.success) {
    return res.status(400).send({
      message: result.error?.errors[0]?.message,
      errors: result.error?.errors,
    });
  }
  next();
};

module.exports = {
  validate,
  loginValidation,
  signupValidation,
};
