const express = require("express");
const router = express.Router();
const dashboardController = require("./dashboard.controller");
const auth = require("../../shared/auth.middleware");

router.get("/stats", auth, dashboardController.getDashboardStats);

module.exports = router;