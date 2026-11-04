const invoiceModel = require("./invoice.model");
const invoiceItemsModel = require("./Invoice.items.model");

// Save a new invoice (updated with currency)
const saveInvoice = async (req, res) => {
  const {
    invoiceNumber,
    date,
    dueDate,
    client,
    items,
    taxRate,
    discountType,
    discountValue,
    notes,
    status,
    subtotal,
    discount,
    tax,
    total,
    currency_code,
    currency_symbol,
    currency_name,
    payment_method,
    businessDetails,
    payment_amount,  
    payment_method_used,
  } = req.body;

  const totalPaid = payment_amount || 0;
  const remainingBalance = total - totalPaid;
  const paymentStatus = totalPaid >= total ? 'paid' : (totalPaid > 0 ? 'partial' : 'unpaid');

  try {
    const invoiceItems = items.map((item) => ({
      description: item.description,
      quantity: item.quantity,
      price: item.price,
      total: item.quantity * item.price,
    }));

    const invoiceData = {
      user_id: req.user.id,
      invoice_number: invoiceNumber,
      date: date,
      due_date: dueDate || null,
      client_name: client.name,
      client_email: client.email || "",
      client_phone: client.phone || "",
      client_address: client.address || "",
      business_name: businessDetails?.business_name || "",      
    business_address: businessDetails?.address || "",           
    business_phone: businessDetails?.phone_number || "",    
    business_email: businessDetails?.email_address || "",      
      business_website: businessDetails?.website || "", 
      tax_rate: taxRate,
      discount_type: discountType,
      discount_value: discountValue,
      discount_amount: discount,
      tax_amount: tax,
      total_amount: total,
      notes: notes,
      status: status,
      currency_code: currency_code || 'USD',
      currency_symbol: currency_symbol || '$',
      currency_name: currency_name || 'US Dollar',
      payment_method: payment_method || 'cash',
       total_paid: totalPaid,      
    remaining_balance: remainingBalance,  
    payment_status: paymentStatus,  
    };

    const invoiceId = await invoiceModel.createInvoice(invoiceData);

    const itemsWithInvoiceId = invoiceItems.map((item) => ({
      ...item,
      invoice_id: invoiceId,
    }));

    await invoiceItemsModel.createMultipleInvoiceItems(itemsWithInvoiceId);

    res.status(201).json({ success: true, message: "Invoice saved successfully", invoiceId })

  } catch (err) {
    console.error("Save invoice error:", err);
    res.status(500).json({ message: "Failed to save invoice" });
  }
};

// Get all invoices for the authenticated user
const getAllInvoices = async (req, res) => {
  try {
    const invoices = await invoiceModel.findAllInvoicesByUser(req.user.id);
    res.status(200).json({ success: true, data: invoices });
  } catch (err) {
    console.error("Get invoices error:", err);
    res.status(500).json({ message: "Failed to fetch invoices" });
  }
};

// Get single invoice by ID
const getInvoiceById = async (req, res) => {
  const invoiceId = req.params.id;

  try {
    // Get invoice
    const invoice = await invoiceModel.findInvoiceById(invoiceId, req.user.id);

    if (!invoice) {
      return res.status(404).json({ message: "Invoice not found" });
    }

    // Get invoice items
    const items = await invoiceItemsModel.findInvoiceItemsByInvoiceId(invoiceId);
    invoice.items = items;

    res.status(200).json({ success: true, data: invoice });
  } catch (err) {
    console.error("Get invoice by ID error:", err);
    res.status(500).json({ message: "Failed to fetch invoice" });
  }
};

// Delete invoice by ID
const deleteInvoice = async (req, res) => {
  const invoiceId = req.params.id;

  try {
    // First, delete the invoice items
    await invoiceItemsModel.deleteInvoiceItemsByInvoiceId(invoiceId);

    // Then, delete the invoice itself
    const deletedRows = await invoiceModel.deleteInvoiceById(invoiceId, req.user.id);

    if (deletedRows === 0) {
      return res.status(404).json({ message: "Invoice not found or not authorized" });
    }

    res.status(200).json({ success: true, message: "Invoice deleted successfully" });
  } catch (err) {
    console.error("Delete invoice error:", err);
    res.status(500).json({ message: "Failed to delete invoice" });
  }
};

// Update an existing invoice
const updateInvoice = async (req, res) => {
  const invoiceId = req.params.id;
  const {
    invoiceNumber,
    date,
    dueDate,
    client,
    items,
    taxRate,
    discountType,
    discountValue,
    notes,
    status,
    subtotal,
    discount,
    tax,
    total,
    currency_code,
    currency_symbol,
    currency_name,
    payment_method,
    payment_amount, 
    payment_method_used,  
    businessDetails,
  } = req.body;

   const totalPaid = payment_amount || 0;
  const remainingBalance = total - totalPaid;
  const paymentStatus = totalPaid >= total ? 'paid' : (totalPaid > 0 ? 'partial' : 'unpaid');

  try {
    // First check if invoice exists and belongs to user
    const existingInvoice = await invoiceModel.findInvoiceById(invoiceId, req.user.id);
    
    if (!existingInvoice) {
      return res.status(404).json({ message: "Invoice not found or not authorized" });
    }

    // Prepare invoice data for update
    const invoiceData = {
      invoice_number: invoiceNumber,
      date: date,
      due_date: dueDate || null,
      client_name: client.name,
      client_email: client.email || "",
      client_phone: client.phone || "",
      client_address: client.address || "",
      tax_rate: taxRate,
      discount_type: discountType,
      discount_value: discountValue,
      discount_amount: discount,
      tax_amount: tax,
      total_amount: total,
      notes: notes,
      status: status,
   business_name: businessDetails?.business_name || "",
business_email: businessDetails?.email_address || "",
business_phone: businessDetails?.phone_number || "",
business_address: businessDetails?.address || "",
business_website: businessDetails?.website || "",
      currency_code: currency_code || 'USD',
      currency_symbol: currency_symbol || '$',
      currency_name: currency_name || 'US Dollar',
       payment_method: payment_method || 'cash',
       total_paid: totalPaid,      
  remaining_balance: remainingBalance, 
  payment_status: paymentStatus,       
    };

    // Update invoice
    await invoiceModel.updateInvoice(invoiceId, invoiceData);

    // Delete existing items and insert new ones
    await invoiceItemsModel.deleteInvoiceItemsByInvoiceId(invoiceId);
    
    // Prepare items with invoice_id
    const itemsWithInvoiceId = items.map((item) => ({
      invoice_id: parseInt(invoiceId),
      description: item.description,
      quantity: item.quantity,
      price: item.price,
      total: item.quantity * item.price,
    }));

    // Create new invoice items
    if (itemsWithInvoiceId.length > 0) {
      await invoiceItemsModel.createMultipleInvoiceItems(itemsWithInvoiceId);
    }

    res.status(200).json({ success: true, message: "Invoice updated successfully" });
  } catch (err) {
    console.error("Update invoice error:", err);
    res.status(500).json({ message: "Failed to update invoice" });
  }
};

module.exports = {
  saveInvoice,
  getAllInvoices,
  getInvoiceById,
  deleteInvoice,
  updateInvoice,
};