// modules/admin/admin.routes.js
const { Router } = require("express");
const { login, getMe } = require("./admin.controller");
const { sendBulkMessage } = require("./admin.emails.controller");
const { requireAdmin } = require("./admin.middleware");

const router = Router();

// Public
router.post("/login", login);

// Protected
router.get("/me", requireAdmin, getMe);
router.post("/messages/send", requireAdmin, sendBulkMessage);

module.exports = router;