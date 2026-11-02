const { Router } = require("express");
const {
  registerUser,
  loginUser,
  forgotPassword,
  verifyResetToken,
  resetPassword,
} = require("./auth.controller");

const router = Router();

// Register route
router.post("/register", registerUser);

// Login route
router.post("/login", loginUser);

// Forgot password
router.post("/forgot-password", forgotPassword);

// Verify reset token
router.post("/verify-reset-token", verifyResetToken);

// Reset password
router.post("/reset-password", resetPassword);

module.exports = router;
