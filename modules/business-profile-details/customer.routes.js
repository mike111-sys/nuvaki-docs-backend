const express = require("express");
const router = express.Router();
const customerController = require("./customer.controller");
const auth = require("../../shared/auth.middleware");

// All routes require authentication
router.use(auth);

// Customer CRUD operations
router.post("/", customerController.createCustomer);
router.get("/", customerController.getAllCustomers);
router.get("/recent", customerController.getRecentCustomers);
router.get("/:id", customerController.getCustomerById);
router.put("/:id", customerController.updateCustomer);
router.delete("/:id", customerController.deleteCustomer);

module.exports = router;