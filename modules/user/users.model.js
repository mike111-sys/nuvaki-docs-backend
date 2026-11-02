const pool = require("../../shared/database");

// Create a new user

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
  } = userData;

  const [result] = await pool.query(
    `INSERT INTO users_information 
     (id, name, business_name, phone_number, country, email_address, password, trials, created_at)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      id,
      name,
      business_name,
      phone_number,
      country,
      email_address,
      password,
      trials,
      created_at,
    ]
  );

  return result.insertId;
};

// Find user by email address

const findUserByEmail = async (email) => {
  const [rows] = await pool.query(
    "SELECT * FROM users_information WHERE email_address = ?",
    [email]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Find user by ID

const findUserById = async (userId) => {
  const [rows] = await pool.query(
    "SELECT email_address AS email FROM users_information WHERE id = ?",
    [userId]
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

// Update user's reset token and expiry

const updateUserResetToken = async (email, token, expires) => {
  const [result] = await pool.query(
    "UPDATE users_information SET reset_token = ?, reset_token_expiry = ? WHERE email_address = ?",
    [token, expires, email]
  );
  return result.affectedRows;
};

// Find user by reset token (with expiry check)

const findUserByResetToken = async (token) => {
  const [rows] = await pool.query(
    "SELECT * FROM users_information WHERE reset_token = ? AND reset_token_expiry > ?",
    [token, Date.now()]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Update user password and clear reset token

const updateUserPassword = async (email, hashedPassword) => {
  const [result] = await pool.query(
    "UPDATE users_information SET password = ?, reset_token = NULL, reset_token_expiry = NULL WHERE email_address = ?",
    [hashedPassword, email]
  );
  return result.affectedRows;
};

// Update user trials

const updateUserTrials = async (userId, newTrials) => {
  const [result] = await pool.query(
    "UPDATE users_information SET trials = ? WHERE id = ?",
    [newTrials, userId]
  );
  return result.affectedRows;
};

// ============ NEW LOGO FUNCTIONS ============

// Update user logo
const updateUserLogo = async (userId, logoUrl) => {
  const [result] = await pool.query(
    "UPDATE users_information SET logo = ? WHERE id = ?",
    [logoUrl, userId]
  );
  return result.affectedRows;
};

// Get user logo
const getUserLogo = async (userId) => {
  const [rows] = await pool.query(
    "SELECT logo FROM users_information WHERE id = ?",
    [userId]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Clear user logo (set to NULL)
const clearUserLogo = async (userId) => {
  const [result] = await pool.query(
    "UPDATE users_information SET logo = NULL WHERE id = ?",
    [userId]
  );
  return result.affectedRows;
};

// ============ NEW USER PROFILE FUNCTIONS ============

// Get full user profile by ID
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

// Update user profile
const updateUserProfile = async (userId, userData) => {
  const { name, business_name, phone_number, business_address, website, logo } = userData;
  const [result] = await pool.query(
    "UPDATE users_information SET name = ?, business_name = ?, phone_number = ?, business_address = ?, website = ?, logo = ? WHERE id = ?",
    [name, business_name, phone_number, business_address, website, logo, userId]
  );
  return result.affectedRows;
};

// Get user password hash by ID
const findUserPasswordById = async (userId) => {
  const [rows] = await pool.query(
    "SELECT password FROM users_information WHERE id = ?",
    [userId]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Update user password by ID (for profile password changes)
const updateUserPasswordById = async (userId, hashedPassword) => {
  const [result] = await pool.query(
    "UPDATE users_information SET password = ? WHERE id = ?",
    [hashedPassword, userId]
  );
  return result.affectedRows;
};

// Get user accent color
const findUserAccentColorById = async (userId) => {
  try {
    const [rows] = await pool.query(
      'SELECT accent_color FROM users_information WHERE id = ?',
      [userId]
    );
    return rows.length ? rows[0] : null;
  } catch (error) {
    console.error('Error fetching user accent color:', error);
    throw error;
  }
};

// Update user accent color
const updateUserAccentColorById = async (userId, accentColor) => {
  try {
    const [result] = await pool.query(
      'UPDATE users_information SET accent_color = ? WHERE id = ?',
      [accentColor, userId]
    );
    return result.affectedRows;
  } catch (error) {
    console.error('Error updating user accent color:', error);
    throw error;
  }
};

module.exports = {
  createUser,
  findUserByEmail,
  findUserById,
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
  findUserPasswordById,
  updateUserPasswordById,
  findUserAccentColorById,
  updateUserAccentColorById
};
