const pool = require("../../shared/database");

// ---- KES catalog (unchanged) ----
const findAllPaymentPlans = async () => {
  const [plans] = await pool.query(
    "SELECT * FROM payment_plans ORDER BY price ASC"
  );
  return plans;
};

const findPaymentPlanById = async (planId) => {
  const [rows] = await pool.query("SELECT * FROM payment_plans WHERE id = ?", [
    planId,
  ]);
  return rows.length > 0 ? rows[0] : null;
};

// ---- Currency-aware ----

// Return plans for a given currency
const findAllPaymentPlansForCurrency = async (currency) => {
  if (currency === "USD") {
    const [plans] = await pool.query(
      "SELECT * FROM payment_plans_usd ORDER BY price ASC"
    );
    return plans.map((p) => shapePlanForCurrency(p, "USD"));
  }
  const [plans] = await pool.query(
    "SELECT * FROM payment_plans ORDER BY price ASC"
  );
  return plans.map((p) => shapePlanForCurrency(p, "KES"));
};

// Single plan for a given currency
const findPaymentPlanForCurrency = async (planId, currency) => {
  const table = currency === "USD" ? "payment_plans_usd" : "payment_plans";
  const [rows] = await pool.query(
    `SELECT * FROM ${table} WHERE id = ?`,
    [planId]
  );
  if (rows.length === 0) return null;
  return shapePlanForCurrency(rows[0], currency);
};

// Bonus tokens for a given plan + currency (used by verifyPayment)
const findPaymentPlanByIdWithBonus = async (planId, currency = "KES") => {
  const table = currency === "USD" ? "payment_plans_usd" : "payment_plans";
  const [rows] = await pool.query(
    `SELECT bonus_tokens FROM ${table} WHERE id = ?`,
    [planId]
  );
  if (rows.length === 0) return null;
  return { bonus_tokens: Number(rows[0].bonus_tokens) || 0 };
};

// ---- Shape helper ----
// Both tables have the SAME column names (price, tokens, bonus_tokens),
// so the shape is identical regardless of currency. Only the source differs.
function shapePlanForCurrency(plan, currency) {
  const safePrice =
    currency === "USD"
      ? Math.max(1.0, Number(plan.price) || 1.0) // Paystack minimum
      : Number(plan.price);

  return {
    id: plan.id,
    name: plan.name,
    tokens: Number(plan.tokens) || 0,
    price: safePrice,
    bonus_tokens: Number(plan.bonus_tokens) || 0,
    is_popular: Boolean(plan.is_popular),
    currency: currency,
  };
}

module.exports = {
  findAllPaymentPlans,
  findPaymentPlanById,
  findPaymentPlanByIdWithBonus,
  findAllPaymentPlansForCurrency,
  findPaymentPlanForCurrency,
};