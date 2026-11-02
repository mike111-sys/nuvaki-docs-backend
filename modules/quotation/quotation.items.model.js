const pool = require("../../shared/database");

// Create multiple quotation items
const createMultipleQuotationItems = async (items) => {
  if (items.length === 0) return [];

  // Change this: 6 placeholders -> 7 placeholders
  const placeholders = items.map(() => "(?, ?, ?, ?, ?, ?, ?)").join(", ");
  const values = [];

  items.forEach((item) => {
    values.push(
      item.quotation_id,
      item.item_code,
      item.description,
      item.quantity,
      item.unit,
      item.price,
      item.total
    );
  });

  const query = `
    INSERT INTO quotation_items 
      (quotation_id, item_code, description, quantity, unit, price, total) 
    VALUES ${placeholders}
  `;

  const [result] = await pool.query(query, values);
  return result.affectedRows;
};

// Get items by quotation ID
const findQuotationItemsByQuotationId = async (quotationId) => {
  const [items] = await pool.query(
    "SELECT * FROM quotation_items WHERE quotation_id = ? ORDER BY id",
    [quotationId]
  );
  return items;
};

// Delete items
const deleteQuotationItemsByQuotationId = async (quotationId) => {
  const [result] = await pool.query(
    "DELETE FROM quotation_items WHERE quotation_id = ?",
    [quotationId]
  );
  return result.affectedRows;
};

module.exports = {
  createMultipleQuotationItems,
  findQuotationItemsByQuotationId,
  deleteQuotationItemsByQuotationId
};