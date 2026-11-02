// src/routes/receipts.js
const express = require("express");
const router = express.Router();
const receiptController = require("./receipt.controller");
const auth = require("../../shared/auth.middleware");

// Save receipt
router.post("/save", auth, receiptController.saveReceipt);

// Update receipt 
router.put("/:id", auth, receiptController.updateReceipt);

// Get all receipts for the authenticated user
router.get("/", auth, receiptController.getAllReceipts);

// Get single receipt by ID
router.get("/:id", auth, receiptController.getReceiptById);

// Delete receipt by ID
router.delete("/:id", auth, receiptController.deleteReceipt);

module.exports = router;
