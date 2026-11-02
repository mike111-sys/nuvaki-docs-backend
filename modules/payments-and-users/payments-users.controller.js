const pool = require("../../shared/database");

// Get all users with their information
const getAllUsers = async (req, res) => {
  try {
    const [users] = await pool.query(`
      SELECT 
        id,
        name,
        email_address,
        phone_number,
        business_name,
        trials,
        created_at,
        onboarding_completed
      FROM users_information
      ORDER BY created_at DESC
    `);

    res.status(200).json({
      success: true,
      data: users,
      count: users.length
    });
  } catch (error) {
    console.error("Error fetching users:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch users",
      error: error.message
    });
  }
};

// Get all payments with user information
const getAllPayments = async (req, res) => {
  try {
    const [payments] = await pool.query(`
      SELECT 
        p.id,
        p.user_id,
        p.plan_id,
        p.reference,
        p.amount,
        p.tokens_added,
        p.status,
        p.payment_method,
        p.payment_provider,
        p.created_at,
        p.updated_at,
        u.name as user_name,
        u.email_address as user_email,
        u.business_name as user_business,
        u.phone_number as user_phone
      FROM payments p
      LEFT JOIN users_information u ON p.user_id = u.id
      ORDER BY p.created_at DESC
    `);

    res.status(200).json({
      success: true,
      data: payments,
      count: payments.length
    });
  } catch (error) {
    console.error("Error fetching payments:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch payments",
      error: error.message
    });
  }
};

// Get users with their payment history
const getUsersWithPayments = async (req, res) => {
  try {
    const [results] = await pool.query(`
      SELECT 
        u.id,
        u.name,
        u.email_address,
        u.phone_number,
        u.business_name,
        u.trials,
        u.created_at as user_created_at,
        u.onboarding_completed,
        JSON_ARRAYAGG(
          JSON_OBJECT(
            'payment_id', p.id,
            'plan_id', p.plan_id,
            'reference', p.reference,
            'amount', p.amount,
            'tokens_added', p.tokens_added,
            'status', p.status,
            'payment_method', p.payment_method,
            'payment_provider', p.payment_provider,
            'created_at', p.created_at,
            'updated_at', p.updated_at
          )
        ) as payments
      FROM users_information u
      LEFT JOIN payments p ON u.id = p.user_id
      GROUP BY u.id
      ORDER BY u.created_at DESC
    `);

    // Process results to handle users with no payments
    const processedResults = results.map(user => ({
      ...user,
      payments: user.payments && user.payments[0] ? 
        JSON.parse(user.payments) : 
        []
    }));

    res.status(200).json({
      success: true,
      data: processedResults,
      count: processedResults.length
    });
  } catch (error) {
    console.error("Error fetching users with payments:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch users with payments",
      error: error.message
    });
  }
};

module.exports = {
  getAllUsers,
  getAllPayments,
  getUsersWithPayments
};