const receiptModel = require("./receipt.model");
const receiptItemsModel = require("./receipt.items.model");

// Save a new receipt

const saveReceipt = async (req, res) => {
  const {
    receipt_number,
    date,
    business_name,
    business_address,
    business_phone,
    business_email,
    business_website,
    customer_name,
    customer_address,
    customer_phone,
    customer_email,
    payment_method,
    items,
    tax_rate,
    total_amount,
    notes,
     currency_code,
  currency_symbol,
  currency_name,
  } = req.body;

  try {
    // Prepare receipt data for model
    const receiptData = {
      user_id: req.user.id,
      receipt_number,
      date,
      business_name,
      business_address,
      business_phone,
      business_email,
      business_website,
      customer_name,
      customer_address,
      customer_phone,
      customer_email,
      payment_method,
      tax_rate,
      total_amount,
      notes,
      currency_code: currency_code || 'USD',
  currency_symbol: currency_symbol || '$',
  currency_name: currency_name || 'US Dollar',
    };

    // Create receipt
    const receiptId = await receiptModel.createReceipt(receiptData);

    // Prepare items with receipt_id (no calculation needed as total is provided in the request)
    const itemsWithReceiptId = items.map((item) => ({
      receipt_id: receiptId,
      description: item.description,
      quantity: item.quantity,
      price: item.price,
      total: item.total,
    }));

    // Create receipt items
    await receiptItemsModel.createMultipleReceiptItems(itemsWithReceiptId);

    res
      .status(201)
      .json({ success: true, message: "Receipt saved successfully" });
  } catch (err) {
    console.error("Save receipt error:", err);
    res.status(500).json({ message: "Failed to save receipt" });
  }
};

// Get all receipts for the authenticated user

const getAllReceipts = async (req, res) => {
  try {
    const receipts = await receiptModel.findAllReceiptsByUser(req.user.id);
    res.status(200).json({ success: true, data: receipts });
  } catch (err) {
    console.error("Get receipts error:", err);
    res.status(500).json({ message: "Failed to fetch receipts" });
  }
};

// Update an existing receipt
const updateReceipt = async (req, res) => {
  const receiptId = req.params.id;
  const {
    receipt_number,
    date,
    business_name,
    business_address,
    business_phone,
    business_email,
    business_website,
    customer_name,
    customer_address,
    customer_phone,
    customer_email,
    payment_method,
    items,
    tax_rate,
    total_amount,
    notes,
    currency_code,
    currency_symbol,
    currency_name,
  } = req.body;

  try {
    // First check if receipt exists and belongs to user
    const existingReceipt = await receiptModel.findReceiptById(receiptId, req.user.id);
    
    if (!existingReceipt) {
      return res.status(404).json({ message: "Receipt not found or not authorized" });
    }

    // Prepare receipt data for update
    const receiptData = {
      receipt_number,
      date,
      business_name,
      business_address,
      business_phone,
      business_email,
      business_website,
      customer_name,
      customer_address,
      customer_phone,
      customer_email,
      payment_method,
      tax_rate,
      total_amount,
      notes,
      currency_code: currency_code || 'USD',
      currency_symbol: currency_symbol || '$',
      currency_name: currency_name || 'US Dollar',
    };

    // Update receipt
    await receiptModel.updateReceipt(receiptId, receiptData);

    // Delete existing items and insert new ones
    await receiptItemsModel.deleteReceiptItemsByReceiptId(receiptId);
    
    // Prepare items with receipt_id
    const itemsWithReceiptId = items.map((item) => ({
      receipt_id: parseInt(receiptId),
      description: item.description,
      quantity: item.quantity,
      price: item.price,
      total: item.total,
    }));

    // Create new receipt items
    if (itemsWithReceiptId.length > 0) {
      await receiptItemsModel.createMultipleReceiptItems(itemsWithReceiptId);
    }

    res.status(200).json({ success: true, message: "Receipt updated successfully" });
  } catch (err) {
    console.error("Update receipt error:", err);
    res.status(500).json({ message: "Failed to update receipt" });
  }
};

// Get single receipt by ID

const getReceiptById = async (req, res) => {
  const receiptId = req.params.id;

  try {
    // Get the receipt
    const receipt = await receiptModel.findReceiptById(receiptId, req.user.id);

    if (!receipt) {
      return res.status(404).json({ message: "Receipt not found" });
    }

    // Get the receipt items
    const items =
      await receiptItemsModel.findReceiptItemsByReceiptId(receiptId);
    receipt.items = items;

    res.status(200).json({ success: true, data: receipt });
  } catch (err) {
    console.error("Get receipt by ID error:", err);
    res.status(500).json({ message: "Failed to fetch receipt" });
  }
};

// Delete receipt by ID

const deleteReceipt = async (req, res) => {
  const receiptId = req.params.id;

  try {
    // First, delete the receipt items
    await receiptItemsModel.deleteReceiptItemsByReceiptId(receiptId);

    // Then, delete the receipt itself
    const deletedRows = await receiptModel.deleteReceiptById(
      receiptId,
      req.user.id
    );

    if (deletedRows === 0) {
      return res
        .status(404)
        .json({ message: "Receipt not found or not authorized" });
    }

    res
      .status(200)
      .json({ success: true, message: "Receipt deleted successfully" });
  } catch (err) {
    console.error("Delete receipt error:", err);
    res.status(500).json({ message: "Failed to delete receipt" });
  }
};

module.exports = {
  saveReceipt,
  updateReceipt,
  getAllReceipts,
  getReceiptById,
  deleteReceipt,
};
