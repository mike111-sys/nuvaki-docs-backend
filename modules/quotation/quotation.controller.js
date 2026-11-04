const quotationModel = require("./quotation.model");
const quotationItemsModel = require("./quotation.items.model");
const invoiceModel = require("../invoice/invoice.model");
const invoiceItemsModel = require("../invoice/Invoice.items.model");
const { v4: uuidv4 } = require('uuid');

// Save a new quotation
const saveQuotation = async (req, res) => {
  try {
    const {
      quotationNumber,
      dateIssued,
      validUntil,
      client,
      items,
      subtotal,
      discountType,
      discountValue,
      discountAmount,
      taxRate,
      taxAmount,
      totalAmount,
      notes,
      paymentTerms,
      deliveryTerms,
      validityPeriod,
      termsConditions,
      status,
      business_name,
      business_email,
      business_phone,
      business_address,
      business_kra_pin,
      currency_code,
      currency_symbol,
      currency_name,
    } = req.body;

    // Calculate items total
    const quotationItems = items.map((item) => ({
      item_code: item.itemCode || null,
      description: item.description,
      quantity: item.quantity,
      unit: item.unit || 'pcs',
      price: item.price,
      total: item.quantity * item.price,
    }));

    // Get user's business details (as fallback)
    const user = req.user;

    // Prepare quotation data
    const quotationData = {
      quotation_number: quotationNumber,
      user_id: req.user.id,
      date_issued: dateIssued,
      valid_until: validUntil || null,
      status: status || 'draft',
      
      // Client details
      client_name: client.name,
      client_email: client.email || "",
      client_phone: client.phone || "",
      client_address: client.address || "",
      client_county: client.county || "",
      
      // ✅ FIXED: Use business fields from request body (with fallback to user data)
      business_name: business_name || user.business_name || "",
      business_email: business_email || user.email_address || "",
      business_phone: business_phone || user.phone_number || "",
      business_address: business_address || user.business_address || "",
      business_kra_pin: business_kra_pin || user.kra_pin || "",
      
      // Financials
      subtotal: subtotal,
      discount_type: discountType,
      discount_value: discountValue,
      discount_amount: discountAmount,
      tax_rate: taxRate || 16.00,
      tax_amount: taxAmount,
      total_amount: totalAmount,
      
      // Terms
      payment_terms: paymentTerms || "",
      delivery_terms: deliveryTerms || "",
      validity_period: validityPeriod || "30 days",
      notes: notes || "",
      terms_conditions: termsConditions || "",
      currency_code: currency_code || 'USD',
      currency_symbol: currency_symbol || '$',
      currency_name: currency_name || 'US Dollar',
      
      converted_to_invoice: false
    };

    // Create quotation
    const quotationId = await quotationModel.createQuotation(quotationData);

    // Add items
    const itemsWithQuotationId = quotationItems.map((item) => ({
      ...item,
      quotation_id: quotationId,
    }));

    await quotationItemsModel.createMultipleQuotationItems(itemsWithQuotationId);

    res.status(201).json({
      success: true,
      message: "Quotation saved successfully",
      quotationId,
      quotationNumber
    });

  } catch (err) {
    console.error("Save quotation error:", err);
    res.status(500).json({ message: "Failed to save quotation" });
  }
};

// Update an existing quotation (add this after saveQuotation)
const updateQuotation = async (req, res) => {
  try {
    const quotationId = req.params.id;
    
    // Check if quotation exists and belongs to user
    const existingQuotation = await quotationModel.findQuotationById(quotationId, req.user.id);
    
    if (!existingQuotation) {
      return res.status(404).json({ message: "Quotation not found or not authorized" });
    }

    const {
      quotationNumber,
      dateIssued,
      validUntil,
      client,
      items,
      subtotal,
      discountType,
      discountValue,
      discountAmount,
      taxRate,
      taxAmount,
      totalAmount,
      notes,
      paymentTerms,
      deliveryTerms,
      validityPeriod,
      termsConditions,
      status,
      // ✅ ADD THESE BUSINESS FIELDS FROM REQUEST BODY
      business_name,
      business_email,
      business_phone,
      business_address,
      business_kra_pin,
       currency_code,
      currency_symbol,
      currency_name,
    } = req.body;

    // Calculate items total
    const quotationItems = items.map((item) => ({
      item_code: item.itemCode || null,
      description: item.description,
      quantity: item.quantity,
      unit: item.unit || 'pcs',
      price: item.price,
      total: item.quantity * item.price,
    }));

    // Prepare quotation data - USE THE BUSINESS FIELDS FROM REQUEST
    const quotationData = {
      quotation_number: quotationNumber,
      date_issued: dateIssued,
      valid_until: validUntil || null,
      status: status || 'draft',
      
      // Client details
      client_name: client.name,
      client_email: client.email || "",
      client_phone: client.phone || "",
      client_address: client.address || "",
      client_county: client.county || "",
      
      // Business snapshot - USE VALUES FROM REQUEST BODY
      business_name: business_name || "",
      business_email: business_email || "",
      business_phone: business_phone || "",
      business_address: business_address || "",
      business_kra_pin: business_kra_pin || "",
      
      // Financials
      subtotal: subtotal,
      discount_type: discountType,
      discount_value: discountValue,
      discount_amount: discountAmount,
      tax_rate: taxRate || 16.00,
      tax_amount: taxAmount,
      total_amount: totalAmount,
      
      // Terms
      payment_terms: paymentTerms || "",
      delivery_terms: deliveryTerms || "",
      validity_period: validityPeriod || "30 days",
      notes: notes || "",
      terms_conditions: termsConditions || "",
      currency_code: currency_code || 'USD',
      currency_symbol: currency_symbol || '$',
      currency_name: currency_name || 'US Dollar',
    };

    // Update quotation
    await quotationModel.updateQuotation(quotationId, quotationData);

    // Delete existing items and insert new ones
    await quotationItemsModel.deleteQuotationItemsByQuotationId(quotationId);
    
    // Add new items
    const itemsWithQuotationId = quotationItems.map((item) => ({
      ...item,
      quotation_id: parseInt(quotationId),
    }));

    if (itemsWithQuotationId.length > 0) {
      await quotationItemsModel.createMultipleQuotationItems(itemsWithQuotationId);
    }

    res.status(200).json({
      success: true,
      message: "Quotation updated successfully",
      quotationId: parseInt(quotationId),
      quotationNumber
    });

  } catch (err) {
    console.error("Update quotation error:", err);
    res.status(500).json({ message: "Failed to update quotation" });
  }
};

// Get all quotations for user
const getAllQuotations = async (req, res) => {
  try {
    const quotations = await quotationModel.findAllQuotationsByUser(req.user.id);
    res.status(200).json({ success: true, data: quotations });
  } catch (err) {
    console.error("Get quotations error:", err);
    res.status(500).json({ message: "Failed to fetch quotations" });
  }
};

// Get single quotation
const getQuotationById = async (req, res) => {
  try {
    const quotationId = req.params.id;
    const quotation = await quotationModel.findQuotationById(quotationId, req.user.id);

    if (!quotation) {
      return res.status(404).json({ message: "Quotation not found" });
    }

    const items = await quotationItemsModel.findQuotationItemsByQuotationId(quotationId);
    quotation.items = items;

    res.status(200).json({ success: true, data: quotation });
  } catch (err) {
    console.error("Get quotation error:", err);
    res.status(500).json({ message: "Failed to fetch quotation" });
  }
};

// Convert quotation to invoice
const convertToInvoice = async (req, res) => {
  try {
    const quotationId = req.params.id;
    const { invoiceNumber } = req.body;

    // Get quotation
    const quotation = await quotationModel.findQuotationById(quotationId, req.user.id);
    
    if (!quotation) {
      return res.status(404).json({ message: "Quotation not found" });
    }

    if (quotation.converted_to_invoice) {
      return res.status(400).json({ message: "Quotation already converted to invoice" });
    }

    // Get quotation items
    const items = await quotationItemsModel.findQuotationItemsByQuotationId(quotationId);

    // Prepare invoice data
    const invoiceData = {
      user_id: req.user.id,
      invoice_number: invoiceNumber,
      date: new Date().toISOString().split('T')[0],
      due_date: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
      client_name: quotation.client_name,
      client_email: quotation.client_email,
      client_phone: quotation.client_phone,
      client_address: quotation.client_address,
      tax_rate: quotation.tax_rate,
      discount_type: quotation.discount_type,
      discount_value: quotation.discount_value,
      discount_amount: quotation.discount_amount,
      tax_amount: quotation.tax_amount,
      total_amount: quotation.total_amount,
      notes: `Quotation #${quotation.quotation_number} - ${quotation.notes || ''}`,
      status: 'pending',
      quotation_id: quotationId,
      quotation_number: quotation.quotation_number
    };

    // Create invoice
    const invoiceId = await invoiceModel.createInvoice(invoiceData);

    // Prepare invoice items
    const invoiceItems = items.map((item) => ({
      invoice_id: invoiceId,
      description: item.description,
      quantity: item.quantity,
      price: item.price,
      total: item.total
    }));

    await invoiceItemsModel.createMultipleInvoiceItems(invoiceItems);

    // Update quotation status
    await quotationModel.markAsConverted(quotationId, invoiceId, invoiceNumber);

    res.status(200).json({
      success: true,
      message: "Quotation converted to invoice successfully",
      invoiceId,
      invoiceNumber
    });

  } catch (err) {
    console.error("Convert to invoice error:", err);
    res.status(500).json({ message: "Failed to convert quotation to invoice" });
  }
};

// Delete quotation
const deleteQuotation = async (req, res) => {
  try {
    const quotationId = req.params.id;
    
    const quotation = await quotationModel.findQuotationById(quotationId, req.user.id);
    
    if (quotation && quotation.converted_to_invoice) {
      return res.status(400).json({ 
        message: "Cannot delete quotation that has been converted to invoice" 
      });
    }

    await quotationItemsModel.deleteQuotationItemsByQuotationId(quotationId);
    const deletedRows = await quotationModel.deleteQuotationById(quotationId, req.user.id);

    if (deletedRows === 0) {
      return res.status(404).json({ message: "Quotation not found" });
    }

    res.status(200).json({ success: true, message: "Quotation deleted successfully" });
  } catch (err) {
    console.error("Delete quotation error:", err);
    res.status(500).json({ message: "Failed to delete quotation" });
  }
};

// Update quotation status
const updateQuotationStatus = async (req, res) => {
  try {
    const quotationId = req.params.id;
    const { status } = req.body;

    const updated = await quotationModel.updateQuotationStatus(quotationId, req.user.id, status);

    if (updated === 0) {
      return res.status(404).json({ message: "Quotation not found" });
    }

    res.status(200).json({ success: true, message: "Quotation status updated" });
  } catch (err) {
    console.error("Update status error:", err);
    res.status(500).json({ message: "Failed to update status" });
  }
};

module.exports = {
  saveQuotation,
  updateQuotation,
  getAllQuotations,
  getQuotationById,
  convertToInvoice,
  deleteQuotation,
  updateQuotationStatus
};