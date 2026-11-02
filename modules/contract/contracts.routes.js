const express = require("express");
const router = express.Router();
const contractController = require("./contract.controller");
const auth = require("../../shared/auth.middleware");

// Save contract
router.post("/save", auth, contractController.saveContract);

// Get all contracts for the authenticated user
router.get("/", auth, contractController.getAllContracts);

// Get single contract by ID
router.get("/:id", auth, contractController.getContractById);

// Update contract
router.put("/:id", auth, contractController.updateContract);

// Delete contract by ID
router.delete("/:id", auth, contractController.deleteContract);

// Update contract status
router.patch("/:id/status", auth, contractController.updateContractStatus);

module.exports = router;