const pool = require("../../shared/database");

// ============================================================
// CREATE USER
// ============================================================
const createUser = async (userData) => {
  const {
    id,
    name,
    business_name,
    phone_number,
    country,
    email_address,
    password,
    trials,
    created_at,
    email_verified = 0,
    google_id = null,
    verification_token = null,
    verification_expiry = null,
  } = userData;

  const [result] = await pool.query(
    `INSERT INTO users_information
     (id, name, business_name, phone_number, country, email_address, password,
      trials, created_at, email_verified, google_id, verification_token, verification_expiry,
      currency_code, currency_symbol, currency_name)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
       CASE WHEN LOWER(TRIM(?)) = 'kenya' THEN 'KES' ELSE 'USD' END,
       CASE WHEN LOWER(TRIM(?)) = 'kenya' THEN 'KSh' ELSE '$'   END,
       CASE WHEN LOWER(TRIM(?)) = 'kenya' THEN 'Kenyan Shilling' ELSE 'US Dollar' END
     )`,
    [
      id,
      name,
      business_name || null,
      phone_number || null,
      country || null,
      email_address,
      password || null,
      trials ?? 5,
      created_at || new Date(),
      email_verified ? 1 : 0,
      google_id,
      verification_token,
      verification_expiry,
      country,  // <-- for currency_code CASE
      country,  // <-- for currency_symbol CASE
      country,  // <-- for currency_name CASE
    ]
  );

  return result.insertId;
};

// ============================================================
// FINDERS
// ============================================================

// Find user by email address
const findUserByEmail = async (email) => {
  const [rows] = await pool.query(
    "SELECT * FROM users_information WHERE email_address = ?",
    [email]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Find user by ID (kept as email-only alias — used by existing modules)
const findUserById = async (userId) => {
  const [rows] = await pool.query(
    "SELECT email_address AS email FROM users_information WHERE id = ?",
    [userId]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Find full user record by ID
const findUserRecordById = async (userId) => {
  const [rows] = await pool.query(
    "SELECT * FROM users_information WHERE id = ?",
    [userId]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Find user by google_id
const findUserByGoogleId = async (googleId) => {
  const [rows] = await pool.query(
    "SELECT * FROM users_information WHERE google_id = ?",
    [googleId]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Find user by verification token (must not be expired)
const findUserByVerificationToken = async (token) => {
  const [rows] = await pool.query(
    `SELECT * FROM users_information
     WHERE verification_token = ? AND verification_expiry > NOW()`,
    [token]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Find user trials by ID
const findUserTrialsById = async (userId) => {
  const [rows] = await pool.query(
    "SELECT trials FROM users_information WHERE id = ?",
    [userId]
  );
  return rows.length > 0 ? rows[0] : null;
};

// ============================================================
// EMAIL VERIFICATION
// ============================================================
const markEmailVerified = async (userId) => {
  const [result] = await pool.query(
    `UPDATE users_information
     SET email_verified = 1, verification_token = NULL, verification_expiry = NULL
     WHERE id = ?`,
    [userId]
  );
  return result.affectedRows;
};

// ============================================================
// RESET TOKEN
// ============================================================
const updateUserResetToken = async (email, token, expires) => {
  const [result] = await pool.query(
    "UPDATE users_information SET reset_token = ?, reset_token_expiry = ? WHERE email_address = ?",
    [token, expires, email]
  );
  return result.affectedRows;
};

const findUserByResetToken = async (token) => {
  const [rows] = await pool.query(
    "SELECT * FROM users_information WHERE reset_token = ? AND reset_token_expiry > ?",
    [token, Date.now()]
  );
  return rows.length > 0 ? rows[0] : null;
};

const updateUserPassword = async (email, hashedPassword) => {
  const [result] = await pool.query(
    "UPDATE users_information SET password = ?, reset_token = NULL, reset_token_expiry = NULL WHERE email_address = ?",
    [hashedPassword, email]
  );
  return result.affectedRows;
};

// ============================================================
// TRIALS
// ============================================================
const updateUserTrials = async (userId, newTrials) => {
  const [result] = await pool.query(
    "UPDATE users_information SET trials = ? WHERE id = ?",
    [newTrials, userId]
  );
  return result.affectedRows;
};

// ============================================================
// LOGO
// ============================================================
const updateUserLogo = async (userId, logoUrl) => {
  const [result] = await pool.query(
    "UPDATE users_information SET logo = ? WHERE id = ?",
    [logoUrl, userId]
  );
  return result.affectedRows;
};

const getUserLogo = async (userId) => {
  const [rows] = await pool.query(
    "SELECT logo FROM users_information WHERE id = ?",
    [userId]
  );
  return rows.length > 0 ? rows[0] : null;
};

const clearUserLogo = async (userId) => {
  const [result] = await pool.query(
    "UPDATE users_information SET logo = NULL WHERE id = ?",
    [userId]
  );
  return result.affectedRows;
};

// ============================================================
// PROFILE
// ============================================================
const findUserProfileById = async (userId) => {
  const [rows] = await pool.query(
    `SELECT id, name, email_address, phone_number, business_name,
            business_address, website, logo, trials, country,
            currency_code, currency_symbol, currency_name
     FROM users_information WHERE id = ?`,
    [userId]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Update profile (full profile — used by ProfileSettings page)
const updateUserProfile = async (userId, userData) => {
  const {
    name,
    business_name,
    phone_number,
    business_address,
    website,
    logo,
  } = userData;

  const [result] = await pool.query(
    "UPDATE users_information SET name = ?, business_name = ?, phone_number = ?, business_address = ?, website = ?, logo = ? WHERE id = ?",
    [
      name,
      business_name,
      phone_number,
      business_address,
      website,
      logo,
      userId,
    ]
  );
  return result.affectedRows;
};

// ============================================================
// PARTIAL UPDATE (used by completeGoogleRegistration)
// ============================================================
const updateUserFields = async (userId, updates) => {
  const allowed = [
    "name",
    "business_name",
    "phone_number",
    "country",
    "password",
    "email_verified",
    "google_id",
    "business_address",
    "website",
    "logo",
    "currency_code",
    "currency_symbol",
    "currency_name",
    "onboarding_completed",
  ];

  const fields = [];
  const values = [];

  for (const [key, value] of Object.entries(updates)) {
    if (value === undefined) continue;
    if (!allowed.includes(key)) continue;
    fields.push(`${key} = ?`);
    values.push(value);
  }

  if (fields.length === 0) return 0;

  values.push(userId);
  const [result] = await pool.query(
    `UPDATE users_information SET ${fields.join(", ")} WHERE id = ?`,
    values
  );
  return result.affectedRows;
};

// ============================================================
// PASSWORD (by ID — used in ProfileSettings)
// ============================================================
const findUserPasswordById = async (userId) => {
  const [rows] = await pool.query(
    "SELECT password FROM users_information WHERE id = ?",
    [userId]
  );
  return rows.length > 0 ? rows[0] : null;
};

const updateUserPasswordById = async (userId, hashedPassword) => {
  const [result] = await pool.query(
    "UPDATE users_information SET password = ? WHERE id = ?",
    [hashedPassword, userId]
  );
  return result.affectedRows;
};

// ============================================================
// ACCENT COLOR
// ============================================================
const findUserAccentColorById = async (userId) => {
  try {
    const [rows] = await pool.query(
      "SELECT accent_color FROM users_information WHERE id = ?",
      [userId]
    );
    return rows.length ? rows[0] : null;
  } catch (error) {
    console.error("Error fetching user accent color:", error);
    throw error;
  }
};

const updateUserAccentColorById = async (userId, accentColor) => {
  try {
    const [result] = await pool.query(
      "UPDATE users_information SET accent_color = ? WHERE id = ?",
      [accentColor, userId]
    );
    return result.affectedRows;
  } catch (error) {
    console.error("Error updating user accent color:", error);
    throw error;
  }
};

// ============================================================
// EXPORTS
// ============================================================
module.exports = {
  createUser,
  findUserByEmail,
  findUserById,
  findUserRecordById,
  findUserByGoogleId,
  findUserByVerificationToken,
  markEmailVerified,
  findUserTrialsById,
  updateUserResetToken,
  findUserByResetToken,
  updateUserPassword,
  updateUserTrials,
  updateUserLogo,
  getUserLogo,
  clearUserLogo,
  findUserProfileById,
  updateUserProfile,
  updateUserFields,
  findUserPasswordById,
  updateUserPasswordById,
  findUserAccentColorById,
  updateUserAccentColorById,
};