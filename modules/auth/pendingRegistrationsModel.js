const pool = require("../../shared/database");

const upsertPending = async (data) => {
  const {
    id,
    type,
    name,
    email_address,
    password,
    business_name,
    phone_number,
    country,
    google_id,
    verification_token,
    verification_expiry,
  } = data;

  // Delete any existing pending row for this email (fresh start)
  await pool.query("DELETE FROM pending_registrations WHERE email_address = ?", [
    email_address,
  ]);

  await pool.query(
    `INSERT INTO pending_registrations
     (id, type, name, email_address, password, business_name, phone_number,
      country, google_id, verification_token, verification_expiry)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      id,
      type,
      name || null,
      email_address,
      password || null,
      business_name || null,
      phone_number || null,
      country || null,
      google_id || null,
      verification_token || null,
      verification_expiry || null,
    ]
  );

  return id;
};

const findByToken = async (token) => {
  const [rows] = await pool.query(
    `SELECT * FROM pending_registrations
     WHERE verification_token = ? AND verification_expiry > NOW() LIMIT 1`,
    [token]
  );
  return rows[0] || null;
};

const findById = async (id) => {
  const [rows] = await pool.query(
    "SELECT * FROM pending_registrations WHERE id = ? LIMIT 1",
    [id]
  );
  return rows[0] || null;
};

const findByEmail = async (email) => {
  const [rows] = await pool.query(
    "SELECT * FROM pending_registrations WHERE email_address = ? LIMIT 1",
    [email]
  );
  return rows[0] || null;
};

const deleteById = async (id) => {
  await pool.query("DELETE FROM pending_registrations WHERE id = ?", [id]);
};

const deleteByEmail = async (email) => {
  await pool.query("DELETE FROM pending_registrations WHERE email_address = ?", [
    email,
  ]);
};

// Cleanup old pending rows (call on startup or via cron)
const cleanupExpired = async () => {
  await pool.query(
    "DELETE FROM pending_registrations WHERE created_at < NOW() - INTERVAL 2 DAY"
  );
};

module.exports = {
  upsertPending,
  findByToken,
  findById,
  findByEmail,
  deleteById,
  deleteByEmail,
  cleanupExpired,
};