const { Router } = require("express");
const pendingAuth = require("./pendingAuth.middleware");
const {
  registerUser,
  verifyEmail,
  loginUser,
  googleLogin,
  completeGoogleRegistration,
  forgotPassword,
  verifyResetToken,
  resetPassword,
} = require("./auth.controller");

const router = Router();

router.post("/register", registerUser);
router.post("/verify-email", verifyEmail);
router.post("/login", loginUser);
router.post("/google-login", googleLogin);
router.post("/complete-google-registration", pendingAuth, completeGoogleRegistration);
router.post("/forgot-password", forgotPassword);
router.post("/verify-reset-token", verifyResetToken);
router.post("/reset-password", resetPassword);

module.exports = router;