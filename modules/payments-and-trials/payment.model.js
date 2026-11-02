const pool = require("../../shared/database");

//  Create a new payment

const createPayment = async (paymentData) => {
  const { user_id, plan_id, reference, amount, currency, tokens_added, status } =
    paymentData;

  const [result] = await pool.query(
    `INSERT INTO payments (user_id, plan_id, reference, amount, currency, tokens_added, status)
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [user_id, plan_id, reference, amount, currency || "KES", tokens_added, status]
  );

  return result.insertId;
};

// Check for recent pending payments (within 8 minutes)

const findRecentPendingPayments = async (userId) => {
  const [rows] = await pool.query(
    `SELECT created_at FROM payments WHERE user_id = ? AND status = 'pending' 
     AND created_at > DATE_SUB(NOW(), INTERVAL 8 MINUTE)`,
    [userId]
  );
  return rows;
};

// Find payment by reference

const findPaymentByReference = async (reference) => {
  const [rows] = await pool.query(
    "SELECT * FROM payments WHERE reference = ?",
    [reference]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Update payment status

const updatePaymentStatus = async (reference, status) => {
  const [result] = await pool.query(
    "UPDATE payments SET status = ? WHERE reference = ?",
    [status, reference]
  );
  return result.affectedRows;
};

// Get payment history for a user with plan details

const findPaymentHistoryByUser = async (userId) => {
  const [rows] = await pool.query(
    `SELECT p.*, pl.name AS plan_name, pl.bonus_tokens 
     FROM payments p 
     JOIN payment_plans pl ON p.plan_id = pl.id
     WHERE p.user_id = ? ORDER BY p.created_at DESC`,
    [userId]
  );
  return rows;
};

// Get recent pending payments for a user (within 5 minutes)

const findRecentPaymentsByUser = async (userId) => {
  const [rows] = await pool.query(
    `SELECT plan_id, created_at, status 
     FROM payments 
     WHERE user_id = ? AND created_at > DATE_SUB(NOW(), INTERVAL 5 MINUTE)`,
    [userId]
  );
  return rows;
};


// Get recent payment with cooldown for a specific plan
const findRecentPaymentWithCooldownByPlan = async (userId, planId) => {
  const [rows] = await pool.query(
    `SELECT 
      id,
      plan_id,
      created_at,
      status,
      TIMESTAMPDIFF(SECOND, created_at, NOW()) as seconds_elapsed,
      GREATEST(0, 600 - TIMESTAMPDIFF(SECOND, created_at, NOW())) as seconds_remaining
     FROM payments 
     WHERE user_id = ? 
       AND plan_id = ?
       AND created_at > DATE_SUB(NOW(), INTERVAL 10 MINUTE)
     ORDER BY created_at DESC 
     LIMIT 1`,
    [userId, planId]
  );
  return rows.length > 0 ? rows[0] : null;
};

// Get all recent payments with cooldown grouped by plan
const findRecentPaymentsWithCooldownByPlan = async (userId) => {
  const [rows] = await pool.query(
    `SELECT 
      plan_id,
      MAX(created_at) as created_at,
      TIMESTAMPDIFF(SECOND, MAX(created_at), NOW()) as seconds_elapsed,
      GREATEST(0, 600 - TIMESTAMPDIFF(SECOND, MAX(created_at), NOW())) as seconds_remaining,
      (SELECT status FROM payments p2 
       WHERE p2.user_id = p1.user_id 
         AND p2.plan_id = p1.plan_id 
         AND p2.created_at = MAX(p1.created_at)
       LIMIT 1) as status
     FROM payments p1
     WHERE user_id = ? 
       AND created_at > DATE_SUB(NOW(), INTERVAL 10 MINUTE)
     GROUP BY plan_id`,
    [userId]
  );
  return rows;
};

module.exports = {
  createPayment,
  findRecentPendingPayments,
  findPaymentByReference,
  updatePaymentStatus,
  findPaymentHistoryByUser,
  findRecentPaymentsByUser,
findRecentPaymentWithCooldownByPlan,
findRecentPaymentsWithCooldownByPlan
};
