const pool = require("../../shared/database");

// Create a new receipt

const createReceipt = async (receiptData) => {
  const {
    user_id,
    receipt_number,
    date,
    business_name,
    business_address,
    business_phone,
    business_email,
    business_website,
    customer_name,
    customer_address,
    customer_phone,
    customer_email,
    payment_method,
    tax_rate,
    total_amount,
    notes,
    currency_code,
    currency_symbol,
    currency_name,
  } = receiptData;

  const [result] = await pool.query(
    `INSERT INTO receipts (
      user_id,
      receipt_number,
      date,
      business_name,
      business_address,
      business_phone,
      business_email,
      business_website,
      customer_name,
      customer_address,
      customer_phone,
      customer_email,
      payment_method,
      tax_rate,
      total_amount,
      notes,
      currency_code,
      currency_symbol,
      currency_name
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      user_id,
      receipt_number,
      date,
      business_name,
      business_address,
      business_phone,
      business_email,
      business_website,
      customer_name,
      customer_address,
      customer_phone,
      customer_email,
      payment_method,
      tax_rate,
      total_amount,
      notes,
      currency_code,
      currency_symbol,
      currency_name,
    ]
  );

  return result.insertId;
};

// Update an existing receipt
const updateReceipt = async (receiptId, receiptData) => {
  const {
    receipt_number,
    date,
    business_name,
    business_address,
    business_phone,
    business_email,
    business_website,
    customer_name,
    customer_address,
    customer_phone,
    customer_email,
    payment_method,
    tax_rate,
    total_amount,
    notes,
    currency_code,
    currency_symbol,
    currency_name,
  } = receiptData;

  const [result] = await pool.query(
    `UPDATE receipts SET
      receipt_number = ?,
      date = ?,
      business_name = ?,
      business_address = ?,
      business_phone = ?,
      business_email = ?,
      business_website = ?,
      customer_name = ?,
      customer_address = ?,
      customer_phone = ?,
      customer_email = ?,
      payment_method = ?,
      tax_rate = ?,
      total_amount = ?,
      notes = ?,
      currency_code = ?,
      currency_symbol = ?,
      currency_name = ?
    WHERE id = ?`,
    [
      receipt_number,
      date,
      business_name,
      business_address,
      business_phone,
      business_email,
      business_website,
      customer_name,
      customer_address,
      customer_phone,
      customer_email,
      payment_method,
      tax_rate,
      total_amount,
      notes,
      currency_code,
      currency_symbol,
      currency_name,
      receiptId
    ]
  );

  return result.affectedRows;
};

// Get all receipts for a user

const findAllReceiptsByUser = async (userId) => {
  const [receipts] = await pool.query(
    "SELECT * FROM receipts WHERE user_id = ? ORDER BY date DESC",
    [userId]
  );
  return receipts;
};

// Get receipt by ID for a specific user

const findReceiptById = async (receiptId, userId) => {
  const [rows] = await pool.query(
    "SELECT * FROM receipts WHERE id = ? AND user_id = ?",
    [receiptId, userId]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Get receipt by ID without user check (for internal use)

const findReceiptByIdOnly = async (receiptId) => {
  const [rows] = await pool.query("SELECT * FROM receipts WHERE id = ?", [
    receiptId,
  ]);
  return rows.length > 0 ? rows[0] : null;
};

// Delete a receipt

const deleteReceiptById = async (receiptId, userId) => {
  const [result] = await pool.query(
    "DELETE FROM receipts WHERE id = ? AND user_id = ?",
    [receiptId, userId]
  );
  return result.affectedRows;
};

module.exports = {
  createReceipt,
  updateReceipt,
  findAllReceiptsByUser,
  findReceiptById,
  findReceiptByIdOnly,
  deleteReceiptById,
};
