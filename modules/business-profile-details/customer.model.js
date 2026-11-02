const pool = require("../../shared/database");

// Create a new customer
const createCustomer = async (customerData) => {
  const {
    user_id,
    name,
    email,
    phone,
    address
  } = customerData;

  const [result] = await pool.query(
    `INSERT INTO customers (
      user_id, name, email, phone, address
    ) VALUES (?, ?, ?, ?, ?)`,
    [
      user_id,
      name,
      email || null,
      phone || null,
      address || null
    ]
  );

  return result.insertId;
};

// Get all customers for a user
const findAllCustomersByUser = async (userId, searchTerm = '') => {
  let query = 'SELECT * FROM customers WHERE user_id = ?';
  const params = [userId];
  
  if (searchTerm) {
    query += ' AND (name LIKE ? OR email LIKE ? OR phone LIKE ?)';
    const searchPattern = `%${searchTerm}%`;
    params.push(searchPattern, searchPattern, searchPattern);
  }
  
  query += ' ORDER BY name ASC';
  
  const [customers] = await pool.query(query, params);
  return customers;
};

// Get single customer by ID
const findCustomerById = async (customerId, userId) => {
  const [rows] = await pool.query(
    'SELECT * FROM customers WHERE id = ? AND user_id = ?',
    [customerId, userId]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Update customer
const updateCustomer = async (customerId, userId, customerData) => {
  const {
    name,
    email,
    phone,
    address
  } = customerData;

  const [result] = await pool.query(
    `UPDATE customers SET 
      name = ?, email = ?, phone = ?, address = ?, updated_at = CURRENT_TIMESTAMP
    WHERE id = ? AND user_id = ?`,
    [
      name,
      email || null,
      phone || null,
      address || null,
      customerId,
      userId
    ]
  );

  return result.affectedRows;
};

// Delete customer
const deleteCustomer = async (customerId, userId) => {
  const [result] = await pool.query(
    'DELETE FROM customers WHERE id = ? AND user_id = ?',
    [customerId, userId]
  );
  return result.affectedRows;
};


// Get recent customers for a user
const findRecentCustomers = async (userId, limit = 5) => {
  const [customers] = await pool.query(
    'SELECT * FROM customers WHERE user_id = ? ORDER BY created_at DESC LIMIT ?',
    [userId, limit]
  );
  return customers;
};

module.exports = {
  createCustomer,
  findAllCustomersByUser,
  findCustomerById,
  updateCustomer,
  deleteCustomer,
  findRecentCustomers
};