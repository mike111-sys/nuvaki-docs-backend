const pool = require("../../shared/database");

// Create quotation
const createQuotation = async (quotationData) => {
  const {
    quotation_number,
    user_id,
    date_issued,
    valid_until,
    status,
    client_name,
    client_email,
    client_phone,
    client_address,
    client_county,
    business_name,
    business_email,
    business_phone,
    business_address,
    business_kra_pin,
    subtotal,
    discount_type,
    discount_value,
    discount_amount,
    tax_rate,
    tax_amount,
    total_amount,
    payment_terms,
    delivery_terms,
    validity_period,
    notes,
    terms_conditions,
    converted_to_invoice,
    currency_code,
    currency_symbol,
    currency_name,
  } = quotationData;

  const [result] = await pool.query(
    `INSERT INTO quotations (
      quotation_number, user_id, date_issued, valid_until, status,
      client_name, client_email, client_phone, client_address, client_county,
      business_name, business_email, business_phone, business_address, business_kra_pin,
      subtotal, discount_type, discount_value, discount_amount,
      tax_rate, tax_amount, total_amount,
      payment_terms, delivery_terms, validity_period, notes, terms_conditions,
      converted_to_invoice, currency_code, currency_symbol, currency_name
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      quotation_number, user_id, date_issued, valid_until, status,
      client_name, client_email, client_phone, client_address, client_county,
      business_name, business_email, business_phone, business_address, business_kra_pin,
      subtotal, discount_type, discount_value, discount_amount,
      tax_rate, tax_amount, total_amount,
      payment_terms, delivery_terms, validity_period, notes, terms_conditions,
      converted_to_invoice || false,
      currency_code || 'USD',
      currency_symbol || '$',
      currency_name || 'US Dollar',
    ]
  );

  return result.insertId;
};

// Update an existing quotation
const updateQuotation = async (quotationId, quotationData) => {
  const {
    quotation_number,
    date_issued,
    valid_until,
    status,
    client_name,
    client_email,
    client_phone,
    client_address,
    client_county,
    business_name,
    business_email,
    business_phone,
    business_address,
    business_kra_pin,
    subtotal,
    discount_type,
    discount_value,
    discount_amount,
    tax_rate,
    tax_amount,
    total_amount,
    payment_terms,
    delivery_terms,
    validity_period,
    notes,
    terms_conditions,
    currency_code,
    currency_symbol,
    currency_name,
  } = quotationData;

  const [result] = await pool.query(
    `UPDATE quotations SET
      quotation_number = ?,
      date_issued = ?,
      valid_until = ?,
      status = ?,
      client_name = ?,
      client_email = ?,
      client_phone = ?,
      client_address = ?,
      client_county = ?,
      business_name = ?,
      business_email = ?,
      business_phone = ?,
      business_address = ?,
      business_kra_pin = ?,
      subtotal = ?,
      discount_type = ?,
      discount_value = ?,
      discount_amount = ?,
      tax_rate = ?,
      tax_amount = ?,
      total_amount = ?,
      payment_terms = ?,
      delivery_terms = ?,
      validity_period = ?,
      notes = ?,
      terms_conditions = ?,
      currency_code = ?,
      currency_symbol = ?,
      currency_name = ?
    WHERE id = ?`,
    [
      quotation_number,
      date_issued,
      valid_until,
      status,
      client_name,
      client_email,
      client_phone,
      client_address,
      client_county,
      business_name,
      business_email,
      business_phone,
      business_address,
      business_kra_pin,
      subtotal,
      discount_type,
      discount_value,
      discount_amount,
      tax_rate,
      tax_amount,
      total_amount,
      payment_terms,
      delivery_terms,
      validity_period,
      notes,
      terms_conditions,
      currency_code || 'USD',
      currency_symbol || '$',
      currency_name || 'US Dollar',
      quotationId
    ]
  );

  return result.affectedRows;
};

// Get all quotations for user
const findAllQuotationsByUser = async (userId) => {
  const [quotations] = await pool.query(
    `SELECT *, 
            DATE_FORMAT(date_issued, '%Y-%m-%d') as date_issued,
            DATE_FORMAT(valid_until, '%Y-%m-%d') as valid_until,
            currency_code, currency_symbol, currency_name
     FROM quotations 
     WHERE user_id = ? 
     ORDER BY created_at DESC`,
    [userId]
  );
  return quotations;
};

// Get quotation by ID
const findQuotationById = async (quotationId, userId) => {
  const [rows] = await pool.query(
    `SELECT *, DATE_FORMAT(date_issued, '%Y-%m-%d') as date_issued,
            DATE_FORMAT(valid_until, '%Y-%m-%d') as valid_until,
            DATE_FORMAT(converted_at, '%Y-%m-%d %H:%i:%s') as converted_at
     FROM quotations 
     WHERE id = ? AND user_id = ?`,
    [quotationId, userId]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Mark quotation as converted to invoice
const markAsConverted = async (quotationId, invoiceId, invoiceNumber) => {
  const [result] = await pool.query(
    `UPDATE quotations 
     SET converted_to_invoice = TRUE, 
         converted_invoice_id = ?,
         converted_at = NOW(),
         status = 'converted'
     WHERE id = ?`,
    [invoiceId, quotationId]
  );
  return result.affectedRows;
};

// Update quotation status
const updateQuotationStatus = async (quotationId, userId, status) => {
  const [result] = await pool.query(
    "UPDATE quotations SET status = ? WHERE id = ? AND user_id = ?",
    [status, quotationId, userId]
  );
  return result.affectedRows;
};

// Delete quotation
const deleteQuotationById = async (quotationId, userId) => {
  const [result] = await pool.query(
    "DELETE FROM quotations WHERE id = ? AND user_id = ?",
    [quotationId, userId]
  );
  return result.affectedRows;
};

module.exports = {
  createQuotation,
  updateQuotation,
  findAllQuotationsByUser,
  findQuotationById,
  markAsConverted,
  updateQuotationStatus,
  deleteQuotationById
};