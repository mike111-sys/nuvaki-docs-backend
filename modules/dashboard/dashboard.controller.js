const pool = require("../../shared/database");

// Get dashboard statistics for a user
const getDashboardStats = async (req, res) => {
  const userId = req.user.id;

  try {
    // Get counts for all document types
    const [invoiceCount] = await pool.query(
      "SELECT COUNT(*) as count, SUM(total_amount) as total_value FROM invoices WHERE user_id = ?",
      [userId]
    );

    const [receiptCount] = await pool.query(
      "SELECT COUNT(*) as count, SUM(total_amount) as total_value FROM receipts WHERE user_id = ?",
      [userId]
    );

    const [quotationCount] = await pool.query(
      "SELECT COUNT(*) as count, SUM(total_amount) as total_value FROM quotations WHERE user_id = ?",
      [userId]
    );

    const [contractCount] = await pool.query(
      "SELECT COUNT(*) as count FROM contracts WHERE user_id = ?",
      [userId]
    );

    const [customerCount] = await pool.query(
      "SELECT COUNT(*) as count FROM customers WHERE user_id = ?",
      [userId]
    );

    // Get document status breakdown for all documents
    const [invoiceStatus] = await pool.query(
      `SELECT status, COUNT(*) as count 
       FROM invoices WHERE user_id = ? 
       GROUP BY status`,
      [userId]
    );

    const [receiptStatus] = await pool.query(
      `SELECT COUNT(*) as count FROM receipts WHERE user_id = ?`,
      [userId]
    );

    const [quotationStatus] = await pool.query(
      `SELECT status, COUNT(*) as count 
       FROM quotations WHERE user_id = ? 
       GROUP BY status`,
      [userId]
    );

    const [contractStatus] = await pool.query(
      `SELECT status, COUNT(*) as count 
       FROM contracts WHERE user_id = ? 
       GROUP BY status`,
      [userId]
    );

    // Get monthly document creation trends (last 6 months)
    const [monthlyTrends] = await pool.query(
      `SELECT 
        DATE_FORMAT(date, '%Y-%m') as month,
        COUNT(*) as count,
        'invoice' as type
      FROM invoices 
      WHERE user_id = ? AND date >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
      GROUP BY DATE_FORMAT(date, '%Y-%m')
      UNION ALL
      SELECT 
        DATE_FORMAT(date, '%Y-%m') as month,
        COUNT(*) as count,
        'receipt' as type
      FROM receipts 
      WHERE user_id = ? AND date >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
      GROUP BY DATE_FORMAT(date, '%Y-%m')
      UNION ALL
      SELECT 
        DATE_FORMAT(date_issued, '%Y-%m') as month,
        COUNT(*) as count,
        'quotation' as type
      FROM quotations 
      WHERE user_id = ? AND date_issued >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
      GROUP BY DATE_FORMAT(date_issued, '%Y-%m')
      ORDER BY month ASC`,
      [userId, userId, userId]
    );

    // Get recent documents (last 5 of each)
    const [recentInvoices] = await pool.query(
      `SELECT id, invoice_number as document_number, client_name, total_amount, date, status 
       FROM invoices WHERE user_id = ? 
       ORDER BY date DESC LIMIT 5`,
      [userId]
    );

    const [recentReceipts] = await pool.query(
      `SELECT id, receipt_number as document_number, customer_name, total_amount, date 
       FROM receipts WHERE user_id = ? 
       ORDER BY date DESC LIMIT 5`,
      [userId]
    );

    const [recentQuotations] = await pool.query(
      `SELECT id, quotation_number as document_number, client_name, total_amount, date_issued as date, status 
       FROM quotations WHERE user_id = ? 
       ORDER BY date_issued DESC LIMIT 5`,
      [userId]
    );

    const [recentContracts] = await pool.query(
      `SELECT id, contract_number as document_number, title, party_b_name, status, created_at as date 
       FROM contracts WHERE user_id = ? 
       ORDER BY created_at DESC LIMIT 5`,
      [userId]
    );

    // Get trials remaining
    const [userTrials] = await pool.query(
      "SELECT trials FROM users_information WHERE id = ?",
      [userId]
    );

    // Combine all data
    const stats = {
      counts: {
        invoices: invoiceCount[0]?.count || 0,
        receipts: receiptCount[0]?.count || 0,
        quotations: quotationCount[0]?.count || 0,
        contracts: contractCount[0]?.count || 0,
        customers: customerCount[0]?.count || 0,
        total: (invoiceCount[0]?.count || 0) + (receiptCount[0]?.count || 0) + 
               (quotationCount[0]?.count || 0) + (contractCount[0]?.count || 0),
      },
      totals: {
        invoices: invoiceCount[0]?.total_value || 0,
        receipts: receiptCount[0]?.total_value || 0,
        quotations: quotationCount[0]?.total_value || 0,
      },
      invoiceStatus: invoiceStatus,
      receiptStatus: receiptStatus[0]?.count || 0,
      quotationStatus: quotationStatus,
      contractStatus: contractStatus,
      monthlyTrends: monthlyTrends,
      recentDocuments: {
        invoices: recentInvoices,
        receipts: recentReceipts,
        quotations: recentQuotations,
        contracts: recentContracts,
      },
      trials: userTrials[0]?.trials || 0,
      documentDistribution: {
        invoices: invoiceCount[0]?.count || 0,
        receipts: receiptCount[0]?.count || 0,
        quotations: quotationCount[0]?.count || 0,
        contracts: contractCount[0]?.count || 0,
      }
    };

    res.json({ success: true, data: stats });
  } catch (error) {
    console.error("Error fetching dashboard stats:", error);
    res.status(500).json({ message: "Failed to fetch dashboard statistics" });
  }
};

module.exports = {
  getDashboardStats,
};