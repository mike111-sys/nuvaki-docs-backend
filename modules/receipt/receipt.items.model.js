const pool = require("../../shared/database");

// Create multiple receipt items

const createMultipleReceiptItems = async (items) => {
  if (items.length === 0) return [];

  const placeholders = items.map(() => "(?, ?, ?, ?, ?)").join(", ");
  const values = [];

  items.forEach((item) => {
    values.push(
      item.receipt_id,
      item.description,
      item.quantity,
      item.price,
      item.total
    );
  });

  const query = `
    INSERT INTO receipt_items 
      (receipt_id, description, quantity, price, total) 
    VALUES ${placeholders}
  `;

  const [result] = await pool.query(query, values);
  return result.affectedRows;
};

// Create a single receipt item

const createReceiptItem = async (item) => {
  const [result] = await pool.query(
    `INSERT INTO receipt_items (receipt_id, description, quantity, price, total) 
     VALUES (?, ?, ?, ?, ?)`,
    [item.receipt_id, item.description, item.quantity, item.price, item.total]
  );
  return result.insertId;
};

// Get all items for a receipt

const findReceiptItemsByReceiptId = async (receiptId) => {
  const [items] = await pool.query(
    "SELECT * FROM receipt_items WHERE receipt_id = ? ORDER BY id",
    [receiptId]
  );
  return items;
};

// Delete all items for a receipt

const deleteReceiptItemsByReceiptId = async (receiptId) => {
  const [result] = await pool.query(
    "DELETE FROM receipt_items WHERE receipt_id = ?",
    [receiptId]
  );
  return result.affectedRows;
};

module.exports = {
  createMultipleReceiptItems,
  createReceiptItem,
  findReceiptItemsByReceiptId,
  deleteReceiptItemsByReceiptId,
};
