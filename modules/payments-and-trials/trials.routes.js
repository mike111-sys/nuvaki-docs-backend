const express = require("express");
const router = express.Router();
const trialsController = require("./trials.controller");
const auth = require("../../shared/auth.middleware");

// Get current user's trials
router.get("/", auth, trialsController.getTrials);

// Decrement trials by 1
router.patch("/decrement", auth, trialsController.decrementTrials);

module.exports = router;
