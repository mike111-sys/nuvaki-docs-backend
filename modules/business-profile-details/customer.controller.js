const customerModel = require("./customer.model");

// Create new customer
const createCustomer = async (req, res) => {
  try {
    const customerData = {
      user_id: req.user.id,
      ...req.body
    };

    const customerId = await customerModel.createCustomer(customerData);
    
    const newCustomer = await customerModel.findCustomerById(customerId, req.user.id);
    
    res.status(201).json({
      success: true,
      message: "Customer added successfully",
      data: newCustomer
    });
  } catch (error) {
    console.error("Create customer error:", error);
    res.status(500).json({ 
      success: false, 
      message: "Failed to add customer" 
    });
  }
};

// Get all customers for user
const getAllCustomers = async (req, res) => {
  try {
    const { search } = req.query;
    const customers = await customerModel.findAllCustomersByUser(req.user.id, search);
    
    res.status(200).json({
      success: true,
      data: customers
    });
  } catch (error) {
    console.error("Get customers error:", error);
    res.status(500).json({ 
      success: false, 
      message: "Failed to fetch customers" 
    });
  }
};

// Get single customer
const getCustomerById = async (req, res) => {
  try {
    const { id } = req.params;
    const customer = await customerModel.findCustomerById(id, req.user.id);
    
    if (!customer) {
      return res.status(404).json({ 
        success: false, 
        message: "Customer not found" 
      });
    }
    
    res.status(200).json({
      success: true,
      data: customer
    });
  } catch (error) {
    console.error("Get customer error:", error);
    res.status(500).json({ 
      success: false, 
      message: "Failed to fetch customer" 
    });
  }
};

// Update customer
const updateCustomer = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Check if customer exists
    const existingCustomer = await customerModel.findCustomerById(id, req.user.id);
    if (!existingCustomer) {
      return res.status(404).json({ 
        success: false, 
        message: "Customer not found" 
      });
    }
    
    const affectedRows = await customerModel.updateCustomer(id, req.user.id, req.body);
    
    if (affectedRows === 0) {
      return res.status(400).json({ 
        success: false, 
        message: "No changes made" 
      });
    }
    
    const updatedCustomer = await customerModel.findCustomerById(id, req.user.id);
    
    res.status(200).json({
      success: true,
      message: "Customer updated successfully",
      data: updatedCustomer
    });
  } catch (error) {
    console.error("Update customer error:", error);
    res.status(500).json({ 
      success: false, 
      message: "Failed to update customer" 
    });
  }
};

// Delete customer
const deleteCustomer = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Check if customer exists
    const existingCustomer = await customerModel.findCustomerById(id, req.user.id);
    if (!existingCustomer) {
      return res.status(404).json({ 
        success: false, 
        message: "Customer not found" 
      });
    }
    
    const affectedRows = await customerModel.deleteCustomer(id, req.user.id);
    
    if (affectedRows === 0) {
      return res.status(400).json({ 
        success: false, 
        message: "Failed to delete customer" 
      });
    }
    
    res.status(200).json({
      success: true,
      message: "Customer deleted successfully"
    });
  } catch (error) {
    console.error("Delete customer error:", error);
    res.status(500).json({ 
      success: false, 
      message: "Failed to delete customer" 
    });
  }
};

// Get recent customers
const getRecentCustomers = async (req, res) => {
  try {
    const limit = Math.min(Number(req.query.limit) || 5, 20);
const customers = await customerModel.findRecentCustomers(req.user.id, limit);
    
    res.status(200).json({
      success: true,
      data: customers
    });
  } catch (error) {
    console.error("Get recent customers error:", error);
    res.status(500).json({ 
      success: false, 
      message: "Failed to fetch recent customers" 
    });
  }
};

module.exports = {
  createCustomer,
  getAllCustomers,
  getCustomerById,
  updateCustomer,
  deleteCustomer,
  getRecentCustomers
};