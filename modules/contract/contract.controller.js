const contractModel = require("./contractModel");

// Generate contract number
const generateContractNumber = (type) => {
  const prefix = {
    service_agreement: 'SRV',
    sales_agreement: 'SAL',
    freelance_contract: 'FRE',
    partnership_agreement: 'PRT'
  }[type] || 'CTR';
  
  const timestamp = Date.now().toString().slice(-6);
  const random = Math.floor(Math.random() * 900) + 100;
  return `${prefix}-${random}-${timestamp}`;
};

// Save a new contract
const saveContract = async (req, res) => {
  const contractData = req.body;

  try {
    const contractNumber = contractData.contract_number || 
      generateContractNumber(contractData.contract_type);

    const contractId = await contractModel.createContract({
      user_id: req.user.id,
      contract_number: contractNumber,
      contract_type: contractData.contract_type,
      title: contractData.title || `${contractData.contract_type?.replace('_', ' ') || 'Contract'}`,
      date_issued: new Date(),
      effective_date: contractData.effective_date,
      expiry_date: contractData.expiry_date || null,
      
      // Party A (Your Business)
      party_a_name: contractData.party_a_name || req.user.name,
      party_a_business: contractData.party_a_business || req.user.business_name,
      party_a_email: contractData.party_a_email || req.user.email_address,
      party_a_phone: contractData.party_a_phone || req.user.phone_number,
      party_a_address: contractData.party_a_address || req.user.business_address,
      party_a_id_number: contractData.party_a_id_number,
      party_a_kra_pin: contractData.party_a_kra_pin,
      
      // Party B (Client/Partner)
      party_b_name: contractData.party_b_name,
      party_b_business: contractData.party_b_business,
      party_b_email: contractData.party_b_email,
      party_b_phone: contractData.party_b_phone,
      party_b_address: contractData.party_b_address,
      party_b_id_number: contractData.party_b_id_number,
      party_b_kra_pin: contractData.party_b_kra_pin,
      
      // Contract Details
      project_description: contractData.project_description,
      scope_of_work: contractData.scope_of_work,
      deliverables: contractData.deliverables,
      contract_value: contractData.contract_value || 0,
      payment_terms: contractData.payment_terms,
      payment_schedule: contractData.payment_schedule,
      deposit_amount: contractData.deposit_amount || 0,
      milestones: contractData.milestones,
      
      // Type-specific details
      service_details: contractData.service_details,
      product_details: contractData.product_details,
      partnership_details: contractData.partnership_details,
      
      // Terms
      terms_conditions: contractData.terms_conditions,
      termination_clause: contractData.termination_clause,
      confidentiality_clause: contractData.confidentiality_clause || false,
      dispute_resolution: contractData.dispute_resolution,
      governing_law: contractData.governing_law || 'USA',
      
      // Signatures
      party_a_signature: contractData.party_a_signature,
      party_a_signature_date: contractData.party_a_signature_date,
      party_b_signature: contractData.party_b_signature,
      party_b_signature_date: contractData.party_b_signature_date,
      witness_name: contractData.witness_name,
      witness_signature: contractData.witness_signature,
      witness_date: contractData.witness_date,
      
      status: contractData.status || 'draft',
      notes: contractData.notes,
      // ✅ ADD CURRENCY FIELDS
      currency_code: contractData.currency_code || 'USD',
      currency_symbol: contractData.currency_symbol || '$',
      currency_name: contractData.currency_name || 'US Dollar',
    });

    res.status(201).json({ 
      success: true, 
      message: "Contract saved successfully",
      contractId,
      contractNumber
    });
  } catch (err) {
    console.error("Save contract error:", err);
    res.status(500).json({ message: "Failed to save contract" });
  }
};

// Get all contracts for the authenticated user
const getAllContracts = async (req, res) => {
  try {
    const contracts = await contractModel.findAllContractsByUser(req.user.id);
    res.status(200).json({ success: true, data: contracts });
  } catch (err) {
    console.error("Get contracts error:", err);
    res.status(500).json({ message: "Failed to fetch contracts" });
  }
};

// Get single contract by ID
const getContractById = async (req, res) => {
  const contractId = req.params.id;

  try {
    const contract = await contractModel.findContractById(contractId, req.user.id);

    if (!contract) {
      return res.status(404).json({ message: "Contract not found" });
    }

    res.status(200).json({ success: true, data: contract });
  } catch (err) {
    console.error("Get contract by ID error:", err);
    res.status(500).json({ message: "Failed to fetch contract" });
  }
};

// Update contract
const updateContract = async (req, res) => {
  const contractId = req.params.id;
  const contractData = req.body;

  try {
    const updated = await contractModel.updateContract(contractId, req.user.id, {
      title: contractData.title,
      effective_date: contractData.effective_date,
      expiry_date: contractData.expiry_date,
      
      party_b_name: contractData.party_b_name,
      party_b_business: contractData.party_b_business,
      party_b_email: contractData.party_b_email,
      party_b_phone: contractData.party_b_phone,
      party_b_address: contractData.party_b_address,
      party_b_id_number: contractData.party_b_id_number,
      party_b_kra_pin: contractData.party_b_kra_pin,
      
      project_description: contractData.project_description,
      scope_of_work: contractData.scope_of_work,
      deliverables: contractData.deliverables,
      contract_value: contractData.contract_value,
      payment_terms: contractData.payment_terms,
      payment_schedule: contractData.payment_schedule,
      deposit_amount: contractData.deposit_amount,
      milestones: contractData.milestones,
      
      service_details: contractData.service_details,
      product_details: contractData.product_details,
      partnership_details: contractData.partnership_details,
      
      terms_conditions: contractData.terms_conditions,
      termination_clause: contractData.termination_clause,
      confidentiality_clause: contractData.confidentiality_clause,
      dispute_resolution: contractData.dispute_resolution,
      governing_law: contractData.governing_law,
      
      party_a_signature: contractData.party_a_signature,
      party_a_signature_date: contractData.party_a_signature_date,
      party_b_signature: contractData.party_b_signature,
      party_b_signature_date: contractData.party_b_signature_date,
      witness_name: contractData.witness_name,
      witness_signature: contractData.witness_signature,
      witness_date: contractData.witness_date,
      
      status: contractData.status,
      notes: contractData.notes,
      // ✅ ADD CURRENCY FIELDS
      currency_code: contractData.currency_code || 'USD',
      currency_symbol: contractData.currency_symbol || '$',
      currency_name: contractData.currency_name || 'US Dollar',
    });

    if (!updated) {
      return res.status(404).json({ message: "Contract not found or not authorized" });
    }

    res.status(200).json({ success: true, message: "Contract updated successfully" });
  } catch (err) {
    console.error("Update contract error:", err);
    res.status(500).json({ message: "Failed to update contract" });
  }
};

// Delete contract
const deleteContract = async (req, res) => {
  const contractId = req.params.id;

  try {
    const deleted = await contractModel.deleteContractById(contractId, req.user.id);

    if (deleted === 0) {
      return res.status(404).json({ message: "Contract not found or not authorized" });
    }

    res.status(200).json({ success: true, message: "Contract deleted successfully" });
  } catch (err) {
    console.error("Delete contract error:", err);
    res.status(500).json({ message: "Failed to delete contract" });
  }
};

// Update contract status
const updateContractStatus = async (req, res) => {
  const contractId = req.params.id;
  const { status } = req.body;

  try {
    const updated = await contractModel.updateContractStatus(contractId, req.user.id, status);

    if (!updated) {
      return res.status(404).json({ message: "Contract not found or not authorized" });
    }

    res.status(200).json({ success: true, message: "Contract status updated successfully" });
  } catch (err) {
    console.error("Update contract status error:", err);
    res.status(500).json({ message: "Failed to update contract status" });
  }
};

module.exports = {
  saveContract,
  getAllContracts,
  getContractById,
  updateContract,
  deleteContract,
  updateContractStatus
};