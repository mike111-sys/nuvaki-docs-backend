const pool = require("../../shared/database");

// Helper function to safely parse JSON
const safeJsonParse = (value) => {
  if (!value) return null;
  if (typeof value !== 'string') return value;
  try {
    return JSON.parse(value);
  } catch (e) {
    console.error('Error parsing JSON:', e, 'Value:', value);
    return null;
  }
};

// Helper function to safely stringify JSON
const safeJsonStringify = (value) => {
  if (!value) return null;
  try {
    return JSON.stringify(value);
  } catch (e) {
    console.error('Error stringifying JSON:', e);
    return null;
  }
};

// Create a new contract
const createContract = async (contractData) => {
  const {
    user_id,
    contract_number,
    contract_type,
    title,
    date_issued,
    effective_date,
    expiry_date,
    
    party_a_name,
    party_a_business,
    party_a_email,
    party_a_phone,
    party_a_address,
    party_a_id_number,
    party_a_kra_pin,
    
    party_b_name,
    party_b_business,
    party_b_email,
    party_b_phone,
    party_b_address,
    party_b_id_number,
    party_b_kra_pin,
    
    project_description,
    scope_of_work,
    deliverables,
    contract_value,
    payment_terms,
    payment_schedule,
    deposit_amount,
    milestones,
    
    service_details,
    product_details,
    partnership_details,
    
    terms_conditions,
    termination_clause,
    confidentiality_clause,
    dispute_resolution,
    governing_law,
    
    party_a_signature,
    party_a_signature_date,
    party_b_signature,
    party_b_signature_date,
    witness_name,
    witness_signature,
    witness_date,
    
    status,
    notes,
    // ✅ ADD CURRENCY FIELDS
    currency_code,
    currency_symbol,
    currency_name,
  } = contractData;

  const [result] = await pool.query(
    `INSERT INTO contracts 
     (
       user_id, contract_number, contract_type, title, date_issued, effective_date, expiry_date,
       party_a_name, party_a_business, party_a_email, party_a_phone, party_a_address, party_a_id_number, party_a_kra_pin,
       party_b_name, party_b_business, party_b_email, party_b_phone, party_b_address, party_b_id_number, party_b_kra_pin,
       project_description, scope_of_work, deliverables, contract_value, payment_terms, payment_schedule, deposit_amount, milestones,
       service_details, product_details, partnership_details,
       terms_conditions, termination_clause, confidentiality_clause, dispute_resolution, governing_law,
       party_a_signature, party_a_signature_date, party_b_signature, party_b_signature_date, witness_name, witness_signature, witness_date,
       status, notes,
       currency_code, currency_symbol, currency_name
     ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      user_id, contract_number, contract_type, title, date_issued, effective_date, expiry_date,
      
      party_a_name, party_a_business, party_a_email, party_a_phone, party_a_address, party_a_id_number, party_a_kra_pin,
      
      party_b_name, party_b_business, party_b_email, party_b_phone, party_b_address, party_b_id_number, party_b_kra_pin,
      
      project_description, scope_of_work, deliverables, contract_value, payment_terms, payment_schedule, deposit_amount,
      safeJsonStringify(milestones),
      
      safeJsonStringify(service_details),
      safeJsonStringify(product_details),
      safeJsonStringify(partnership_details),
      
      terms_conditions, termination_clause, confidentiality_clause ? 1 : 0, dispute_resolution, governing_law || 'USA',
      
      party_a_signature, party_a_signature_date, party_b_signature, party_b_signature_date, 
      witness_name, witness_signature, witness_date,
      
      status || 'draft', notes,
      currency_code || 'USD',
      currency_symbol || '$',
      currency_name || 'US Dollar'
    ]
  );

  return result.insertId;
};

// Get all contracts for a user
const findAllContractsByUser = async (userId) => {
  const [contracts] = await pool.query(
    `SELECT * FROM contracts WHERE user_id = ? ORDER BY date_issued DESC`,
    [userId]
  );
  
  // Parse JSON fields safely
  return contracts.map(contract => ({
    ...contract,
    milestones: safeJsonParse(contract.milestones),
    service_details: safeJsonParse(contract.service_details),
    product_details: safeJsonParse(contract.product_details),
    partnership_details: safeJsonParse(contract.partnership_details)
  }));
};

// Get contract by ID for a specific user
const findContractById = async (contractId, userId) => {
  const [rows] = await pool.query(
    "SELECT * FROM contracts WHERE id = ? AND user_id = ?",
    [contractId, userId]
  );
  
  if (rows.length === 0) return null;
  
  const contract = rows[0];
  return {
    ...contract,
    milestones: safeJsonParse(contract.milestones),
    service_details: safeJsonParse(contract.service_details),
    product_details: safeJsonParse(contract.product_details),
    partnership_details: safeJsonParse(contract.partnership_details)
  };
};

// Update contract
const updateContract = async (contractId, userId, contractData) => {
  const {
    title,
    effective_date,
    expiry_date,
    
    party_b_name,
    party_b_business,
    party_b_email,
    party_b_phone,
    party_b_address,
    party_b_id_number,
    party_b_kra_pin,
    
    project_description,
    scope_of_work,
    deliverables,
    contract_value,
    payment_terms,
    payment_schedule,
    deposit_amount,
    milestones,
    
    service_details,
    product_details,
    partnership_details,
    
    terms_conditions,
    termination_clause,
    confidentiality_clause,
    dispute_resolution,
    governing_law,
    
    party_a_signature,
    party_a_signature_date,
    party_b_signature,
    party_b_signature_date,
    witness_name,
    witness_signature,
    witness_date,
    
    status,
    notes,
    // ✅ ADD CURRENCY FIELDS
    currency_code,
    currency_symbol,
    currency_name,
  } = contractData;

  const [result] = await pool.query(
    `UPDATE contracts SET
      title = ?,
      effective_date = ?,
      expiry_date = ?,
      party_b_name = ?,
      party_b_business = ?,
      party_b_email = ?,
      party_b_phone = ?, 
      party_b_address = ?,
      party_b_id_number = ?,
      party_b_kra_pin = ?,
      project_description = ?,
      scope_of_work = ?,
      deliverables = ?, 
      contract_value = ?,
      payment_terms = ?,
      payment_schedule = ?,
      deposit_amount = ?,
      milestones = ?,
      service_details = ?,
      product_details = ?,
      partnership_details = ?,
      terms_conditions = ?,
      termination_clause = ?,
      confidentiality_clause = ?,
      dispute_resolution = ?,
      governing_law = ?,
      party_a_signature = ?,
      party_a_signature_date = ?,
      party_b_signature = ?,
      party_b_signature_date = ?,
      witness_name = ?,
      witness_signature = ?,
      witness_date = ?,
      status = ?,
      notes = ?,
      currency_code = ?,
      currency_symbol = ?,
      currency_name = ?
    WHERE id = ? AND user_id = ?`,
    [
      title, effective_date, expiry_date,
      
      party_b_name, party_b_business, party_b_email, party_b_phone, 
      party_b_address, party_b_id_number, party_b_kra_pin,
      
      project_description, scope_of_work, deliverables, 
      contract_value, payment_terms, payment_schedule, deposit_amount,
      
      safeJsonStringify(milestones),
      safeJsonStringify(service_details),
      safeJsonStringify(product_details),
      safeJsonStringify(partnership_details),
      
      terms_conditions, termination_clause, confidentiality_clause ? 1 : 0,
      dispute_resolution, governing_law,
      
      party_a_signature, party_a_signature_date,
      party_b_signature, party_b_signature_date,
      witness_name, witness_signature, witness_date,
      
      status, notes,
      currency_code || 'USD',
      currency_symbol || '$',
      currency_name || 'US Dollar',
      contractId, userId
    ]
  );

  return result.affectedRows > 0;
};

// Delete contract
const deleteContractById = async (contractId, userId) => {
  const [result] = await pool.query(
    "DELETE FROM contracts WHERE id = ? AND user_id = ?",
    [contractId, userId]
  );
  return result.affectedRows;
};

// Update contract status
const updateContractStatus = async (contractId, userId, status) => {
  const [result] = await pool.query(
    "UPDATE contracts SET status = ? WHERE id = ? AND user_id = ?",
    [status, contractId, userId]
  );
  return result.affectedRows > 0;
};

module.exports = {
  createContract,
  findAllContractsByUser,
  findContractById,
  updateContract,
  deleteContractById,
  updateContractStatus
};