const express = require("express");
const router = express.Router();
const auth = require("../../shared/auth.middleware");
const payments = require("./payment.controller");

router.get("/plans", auth, payments.getPaymentPlans);
router.post("/initialize", auth, payments.initializePayment);
router.get("/verify", auth, payments.verifyPayment);
router.get("/history", auth, payments.getPaymentHistory);
router.get("/pending", auth, payments.getPendingPayments);

module.exports = router;
