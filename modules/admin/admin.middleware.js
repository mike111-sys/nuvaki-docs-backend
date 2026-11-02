// modules/admin/admin.middleware.js
const jwt = require("jsonwebtoken");
const pool = require("../../shared/database");

const requireAdmin = async (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res
      .status(401)
      .json({ success: false, message: "Authorization header missing or invalid" });
  }

  const token = authHeader.split(" ")[1];

  let decoded;
  try {
    decoded = jwt.verify(token, process.env.JWT_SECRET);
  } catch (err) {
    console.error("Admin JWT verification failed:", err.message);
    return res
      .status(401)
      .json({ success: false, message: "Invalid or expired token" });
  }

  // Must be an admin-scoped token — never accept a normal user token
  if (decoded.scope !== "admin") {
    return res.status(403).json({ success: false, message: "Forbidden" });
  }

  try {
    const [rows] = await pool.query(
      "SELECT id, name, email, role, is_active FROM admin_users WHERE id = ? LIMIT 1",
      [decoded.id]
    );

    if (!rows.length || !rows[0].is_active) {
      return res
        .status(401)
        .json({ success: false, message: "Admin not found or inactive" });
    }

    req.admin = rows[0];
    next();
  } catch (err) {
    console.error("Admin lookup failed:", err);
    res.status(500).json({ success: false, message: "Server error" });
  }
};

module.exports = { requireAdmin };