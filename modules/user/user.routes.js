const express = require("express");
const router = express.Router();
const userController = require("./user.controller");
const logoController = require("../business-profile-details/logo.controller");
const auth = require("../../shared/auth.middleware");

// Get current user
router.get("/me", auth, userController.getCurrentUser);

// Update user data
router.put("/", auth, userController.updateUser);

router.put("/onboarding", auth, userController.updateOnboardingStatus);
router.get("/onboarding-status", auth, userController.getOnboardingStatus);

// Update password
router.put("/password", auth, userController.updatePassword);

// Get user trials
router.get("/trials", auth, userController.getUserTrials);

// Upload logo
router.post("/upload-logo", auth, logoController.upload.single('logo'), logoController.uploadLogo);

// Remove logo
router.delete("/logo", auth, logoController.removeLogo);

// Update accent color
router.put("/accent-color", auth, userController.updateAccentColor);

// Get accent color
router.get("/accent-color", auth, userController.getAccentColor);

// Update user's default currency
router.put("/currency", auth, userController.updateCurrency);

// Get user's default currency
router.get("/currency", auth, userController.getCurrency);

module.exports = router;