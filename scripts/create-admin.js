// scripts/create-admin.js
require("dotenv").config();
const bcrypt = require("bcrypt");
const crypto = require("crypto");
const pool = require("../shared/database");

(async () => {
  const name     = process.argv[2] || "Super Admin";
  const email    = (process.argv[3] || "info@nuvakidocs.com").toLowerCase();
  const password = process.argv[4] || "ChangeMe123!";
  const role     = process.argv[5] || "super_admin";

  if (password.length < 8) {
    console.error("❌ Password must be at least 8 characters");
    process.exit(1);
  }

  const id   = crypto.randomUUID();
  const hash = await bcrypt.hash(password, 10);

  try {
    await pool.query(
      "INSERT INTO admin_users (id, name, email, password, role, is_active) VALUES (?,?,?,?,?,1)",
      [id, name, email, hash, role]
    );
    console.log(`✅ Admin created successfully`);
    console.log(`   Email: ${email}`);
    console.log(`   Role:  ${role}`);
    console.log(`   ID:    ${id}`);
  } catch (err) {
    if (err.code === "ER_DUP_ENTRY") {
      console.error("❌ An admin with that email already exists");
    } else {
      console.error("❌ Failed:", err.message);
    }
  } finally {
    process.exit(0);
  }
})();