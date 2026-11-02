// modules/admin/admin.controller.js
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const pool = require("../../shared/database");

const login = async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res
      .status(400)
      .json({ success: false, message: "Email and password are required" });
  }

  try {
    const [rows] = await pool.query(
      "SELECT * FROM admin_users WHERE email = ? LIMIT 1",
      [String(email).toLowerCase().trim()]
    );

    if (!rows.length) {
      return res
        .status(401)
        .json({ success: false, message: "Invalid email or password" });
    }

    const admin = rows[0];

    if (!admin.is_active) {
      return res
        .status(403)
        .json({ success: false, message: "Account disabled" });
    }

    const isMatch = await bcrypt.compare(password, admin.password);
    if (!isMatch) {
      return res
        .status(401)
        .json({ success: false, message: "Invalid email or password" });
    }

    await pool.query("UPDATE admin_users SET last_login = NOW() WHERE id = ?", [
      admin.id,
    ]);

    const token = jwt.sign(
      { id: admin.id, email: admin.email, role: admin.role, scope: "admin" },
      process.env.JWT_SECRET,
      { expiresIn: "8h" }
    );

    res.status(200).json({
      success: true,
      message: "Login successful",
      token,
      admin: {
        id: admin.id,
        name: admin.name,
        email: admin.email,
        role: admin.role,
      },
    });
  } catch (err) {
    console.error("Admin login error:", err);
    res.status(500).json({ success: false, message: "Internal server error" });
  }
};

const getMe = async (req, res) => {
  res.status(200).json({ success: true, admin: req.admin });
};

module.exports = { login, getMe };