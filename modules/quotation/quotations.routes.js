const express = require("express");
const router = express.Router();
const quotationController = require("./quotation.controller");
const auth = require("../../shared/auth.middleware");

// Save quotation
router.post("/save", auth, quotationController.saveQuotation);

// Update quotation
router.put("/:id", auth, quotationController.updateQuotation);

// Get all quotations
router.get("/", auth, quotationController.getAllQuotations);

// Get single quotation
router.get("/:id", auth, quotationController.getQuotationById);

// Convert quotation to invoice
router.post("/:id/convert-to-invoice", auth, quotationController.convertToInvoice);

// Delete quotation
router.delete("/:id", auth, quotationController.deleteQuotation);

// Update quotation status
router.patch("/:id/status", auth, quotationController.updateQuotationStatus);

module.exports = router;