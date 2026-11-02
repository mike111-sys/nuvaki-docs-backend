const express = require("express");
const router = express.Router();
const invoiceController = require("./Invoice.controller");
const auth = require("../../shared/auth.middleware");

router.post("/save", auth, invoiceController.saveInvoice);
router.put("/:id", auth, invoiceController.updateInvoice); 
router.get("/", auth, invoiceController.getAllInvoices);
router.get("/:id", auth, invoiceController.getInvoiceById);
router.delete("/:id", auth, invoiceController.deleteInvoice);

module.exports = router;