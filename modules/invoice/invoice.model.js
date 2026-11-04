const pool = require("../../shared/database");

// Create a new invoice (updated with currency)
const createInvoice = async (invoiceData) => {
  const {
    user_id,
    invoice_number,
    date,
    due_date,
    client_name,
    client_email,
    client_phone,
    client_address,
     business_name,       
    business_address,     
    business_phone,       
    business_email,       
    business_website,     
    tax_rate,
    discount_type,
    discount_value,
    discount_amount,
    tax_amount,
    total_amount,
    notes,
    status,
    currency_code,
    currency_symbol,
    currency_name,
    payment_method,
     total_paid,         
    remaining_balance,   
    payment_status,     
  } = invoiceData;

const [result] = await pool.query(
  `INSERT INTO invoices 
    (
     user_id, invoice_number, date, due_date, client_name, client_email,
     client_phone, client_address, business_name, business_address, business_phone,
     business_email, business_website, tax_rate, discount_type, discount_value,
     discount_amount, tax_amount, total_amount, notes, status,
     currency_code, currency_symbol, currency_name, total_paid, remaining_balance,
     payment_status, default_payment_method
   ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
  [
    user_id,
    invoice_number,
    date,
    due_date || null,
    client_name,
    client_email || "",
    client_phone || "",
    client_address || "",
    business_name || "",     
    business_address || "",   
    business_phone || "",    
    business_email || "",     
    business_website || "",     
    tax_rate,
    discount_type,
    discount_value,
    discount_amount,
    tax_amount,
    total_amount,
    notes,
    status,
    currency_code || 'USD',
    currency_symbol || '$',
    currency_name || 'US Dollar',
    total_paid || 0,       
    remaining_balance || total_amount,  
    payment_status || 'unpaid', 
    payment_method || 'cash',
  ]
);

  return result.insertId;
};

// Update an existing invoice
const updateInvoice = async (invoiceId, invoiceData) => {
  const {
    invoice_number,
    date,
    due_date,
    client_name,
    client_email,
    client_phone,
    client_address,
    business_name,      
    business_address,    
    business_phone,      
    business_email,      
    business_website,     
    tax_rate,
    discount_type,
    discount_value,
    discount_amount,
    tax_amount,
    total_amount,
    notes,
    status,
    currency_code,
    currency_symbol,
    currency_name,
    payment_method,
      total_paid,     
    remaining_balance,  
    payment_status,
  } = invoiceData;

  const [result] = await pool.query(
    `UPDATE invoices SET
      invoice_number = ?,
      date = ?,
      due_date = ?,
      client_name = ?,
      client_email = ?,
      client_phone = ?,
      client_address = ?,
      business_name = ?,
      business_address = ?,
      business_phone = ?,
      business_email = ?,
      business_website = ?,
      tax_rate = ?,
      discount_type = ?,
      discount_value = ?,
      discount_amount = ?,
      tax_amount = ?,
      total_amount = ?,
      notes = ?,
      status = ?,
      currency_code = ?,
      currency_symbol = ?,
      currency_name = ?,
      total_paid = ?,
      remaining_balance = ?,
      payment_status = ?,
      default_payment_method = ?
    WHERE id = ?`,
    [
      invoice_number,
      date,
      due_date,
      client_name,
      client_email,
      client_phone,
      client_address, business_name || "",    
      business_address || "", 
      business_phone || "",     
      business_email || "",     
      business_website || "",    
      tax_rate,
      discount_type,
      discount_value,
      discount_amount,
      tax_amount,
      total_amount,
      notes,
      status,
      currency_code || 'USD',
      currency_symbol || '$',
      currency_name || 'US Dollar',
      total_paid || 0,
      remaining_balance || total_amount,
      payment_status || 'unpaid',
      payment_method || 'cash',
      invoiceId
    ]
  );

  return result.affectedRows;
};

// Get all invoices for a user
const findAllInvoicesByUser = async (userId) => {
  const [invoices] = await pool.query(
    "SELECT * FROM invoices WHERE user_id = ? ORDER BY date DESC",
    [userId]
  );
  return invoices;
};

// Get invoice by ID without user check (for internal use)
const findInvoiceByIdOnly = async (invoiceId) => {
  const [rows] = await pool.query(
    "SELECT * FROM invoices WHERE id = ?",
    [invoiceId]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Delete an invoice
const deleteInvoiceById = async (invoiceId, userId) => {
  const [result] = await pool.query(
    "DELETE FROM invoices WHERE id = ? AND user_id = ?",
    [invoiceId, userId]
  );
  return result.affectedRows;
};



// Get all payments for an invoice
const getPaymentsByInvoiceId = async (invoiceId, userId) => {
  // Get payment info from invoices table
  const [rows] = await pool.query(
    `SELECT 
      id,
      total_paid as amount,
      date as payment_date,
      default_payment_method as payment_method,
      NULL as reference_number,
      notes
     FROM invoices 
     WHERE id = ? AND user_id = ?`,
    [invoiceId, userId]
  );
  
  if (rows.length === 0) return [];
  
  // Format as payment history
  const invoice = rows[0];
  
  // If there's a total_paid > 0, create a payment record from it
  if (parseFloat(invoice.amount) > 0) {
    return [{
      id: invoice.id,
      amount: invoice.amount,
      payment_date: invoice.payment_date,
      payment_method: invoice.payment_method,
      reference_number: null,
      notes: invoice.notes || 'Payment recorded on invoice'
    }];
  }
  
  return [];
};

// Get invoice with payment details
const getInvoiceWithPayments = async (invoiceId, userId) => {
  const [invoices] = await pool.query(
    "SELECT * FROM invoices WHERE id = ? AND user_id = ?",
    [invoiceId, userId]
  );
  
  if (invoices.length === 0) return null;
  
  const invoice = invoices[0];
  const payments = await getPaymentsByInvoiceId(invoiceId, userId);
  
  return { ...invoice, payments };
};

// Get invoice by ID for a specific user (with payments)
const findInvoiceById = async (invoiceId, userId) => {
  const [rows] = await pool.query(
    "SELECT * FROM invoices WHERE id = ? AND user_id = ?",
    [invoiceId, userId]
  );
  
  if (rows.length === 0) return null;
  
  const invoice = rows[0];
  const payments = await getPaymentsByInvoiceId(invoiceId, userId);
  
  return { ...invoice, payments };
};

module.exports = {
  createInvoice,
  updateInvoice,
  findAllInvoicesByUser,
  findInvoiceById,
  findInvoiceByIdOnly,
  deleteInvoiceById,
  getPaymentsByInvoiceId,
  getInvoiceWithPayments,
};