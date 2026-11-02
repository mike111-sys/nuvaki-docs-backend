const pool = require("../../shared/database");

// Create multiple invoice items

const createMultipleInvoiceItems = async (items) => {
  if (items.length === 0) return [];

  const placeholders = items.map(() => "(?, ?, ?, ?, ?)").join(", ");
  const values = [];

  items.forEach((item) => {
    values.push(
      item.invoice_id,
      item.description,
      item.quantity,
      item.price,
      item.total
    );
  });

  const query = `
    INSERT INTO invoice_items 
      (invoice_id, description, quantity, price, total) 
    VALUES ${placeholders}
  `;

  const [result] = await pool.query(query, values);
  return result.affectedRows;
};

// Create a single invoice item

const createInvoiceItem = async (item) => {
  const [result] = await pool.query(
    `INSERT INTO invoice_items 
       (invoice_id, description, quantity, price, total) 
     VALUES (?, ?, ?, ?, ?)`,
    [item.invoice_id, item.description, item.quantity, item.price, item.total]
  );
  return result.insertId;
};

// Get all items for an invoice

const findInvoiceItemsByInvoiceId = async (invoiceId) => {
  const [items] = await pool.query(
    "SELECT * FROM invoice_items WHERE invoice_id = ? ORDER BY id",
    [invoiceId]
  );
  return items;
};

// Delete all items for an invoice

const deleteInvoiceItemsByInvoiceId = async (invoiceId) => {
  const [result] = await pool.query(
    "DELETE FROM invoice_items WHERE invoice_id = ?",
    [invoiceId]
  );
  return result.affectedRows;
};

module.exports = {
  createMultipleInvoiceItems,
  createInvoiceItem,
  findInvoiceItemsByInvoiceId,
  deleteInvoiceItemsByInvoiceId,
};
