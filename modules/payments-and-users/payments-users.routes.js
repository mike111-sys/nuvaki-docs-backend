// modules/payments-and-users/payments-users.routes.js
const { Router } = require("express");
const paymentsUsersController = require("./payments-users.controller");
const { requireAdmin } = require("../admin/admin.middleware");

const router = Router();

// 🔒 Every route below now requires a valid admin token
router.use(requireAdmin);

router.get("/users", paymentsUsersController.getAllUsers);
router.get("/payments", paymentsUsersController.getAllPayments);
router.get("/users-with-payments", paymentsUsersController.getUsersWithPayments);

module.exports = router;