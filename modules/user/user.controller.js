const bcrypt = require("bcrypt");
const {
  findUserProfileById,
  updateUserProfile,
  findUserTrialsById,
  findUserPasswordById,
  updateUserPasswordById,
  findUserAccentColorById,
  updateUserAccentColorById
} = require("./users.model");
const pool = require("../../shared/database");

// Get current authenticated user
const getCurrentUser = async (req, res) => {
  const userId = req.user.id;

  try {
    const user = await findUserProfileById(userId);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json(user);
  } catch (error) {
    console.error("Error fetching user:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Update user data
const updateUser = async (req, res) => {
  const { name, business_name, phone_number, business_address, website, logo } = req.body;

  try {
    const result = await updateUserProfile(req.user.id, {
      name,
      business_name,
      phone_number,
      business_address,
      website,
      logo
    });

    if (result === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({ message: "User updated successfully" });
  } catch (error) {
    console.error("Error updating user:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Update user password
const updatePassword = async (req, res) => {
  const { currentPassword, newPassword } = req.body;

  try {
    // Step 1: Fetch user's password hash by ID
    const user = await findUserPasswordById(req.user.id);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Step 2: Check if current password matches
    const isMatch = await bcrypt.compare(currentPassword, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Current password is incorrect" });
    }

    // Step 3: Check new password strength
    if (newPassword.length < 6) {
      return res
        .status(400)
        .json({ message: "New password must be at least 6 characters long." });
    }

    // Step 4: Hash new password
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(newPassword, saltRounds);

    // Step 5: Update password in the database using ID
    const result = await updateUserPasswordById(req.user.id, hashedPassword);
    
    if (result === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({ message: "Password updated successfully" });
  } catch (error) {
    console.error("Error updating password:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Get user trials
const getUserTrials = async (req, res) => {
  try {
    const userTrials = await findUserTrialsById(req.user.id);

    if (!userTrials) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({ trials: userTrials.trials });
  } catch (error) {
    console.error("Fetch trials error:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

// Update accent color
const updateAccentColor = async (req, res) => {
  const { accentColor } = req.body;

  try {
    const result = await updateUserAccentColorById(req.user.id, accentColor);

    if (result === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({ 
      message: "Accent color updated successfully",
      accentColor 
    });
  } catch (error) {
    console.error("Error updating accent color:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Get user accent color
const getAccentColor = async (req, res) => {
  try {
    const user = await findUserAccentColorById(req.user.id);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({ accentColor: user.accent_color || '#0d9488' });
  } catch (error) {
    console.error("Error fetching accent color:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Update user's default currency
const updateCurrency = async (req, res) => {
  const { currency_code, currency_symbol, currency_name } = req.body;
  
  if (!currency_code || !currency_symbol) {
    return res.status(400).json({ message: "Currency code and symbol are required" });
  }
  
  try {
    const [result] = await pool.query(
      `UPDATE users_information 
       SET currency_code = ?, currency_symbol = ?, currency_name = ? 
       WHERE id = ?`,
      [currency_code.toUpperCase(), currency_symbol, currency_name || currency_code, req.user.id]
    );
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "User not found" });
    }
    
    res.json({ 
      success: true, 
      message: "Default currency updated successfully",
      currency: {
        code: currency_code.toUpperCase(),
        symbol: currency_symbol,
        name: currency_name || currency_code
      }
    });
  } catch (error) {
    console.error("Error updating currency:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Get user's default currency
const getCurrency = async (req, res) => {
  try {
    const [rows] = await pool.query(
      "SELECT currency_code, currency_symbol, currency_name FROM users_information WHERE id = ?",
      [req.user.id]
    );
    
    if (rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }
    
    res.json({ 
      success: true, 
      currency: {
        code: rows[0].currency_code || 'USD',
        symbol: rows[0].currency_symbol || '$',
        name: rows[0].currency_name || 'US Dollar'
      }
    });
  } catch (error) {
    console.error("Error fetching currency:", error);
    res.status(500).json({ message: "Server error" });
  }
};

const updateOnboardingStatus = async (req, res) => {
  const userId = req.user.id;
  
  try {
    await pool.query(
      "UPDATE users_information SET onboarding_completed = ? WHERE id = ?",
      [true, userId]
    );
    
    res.json({ 
      success: true, 
      message: "Onboarding status updated successfully" 
    });
  } catch (error) {
    console.error("Error updating onboarding status:", error);
    res.status(500).json({ 
      success: false, 
      message: "Failed to update onboarding status" 
    });
  }
};

const getOnboardingStatus = async (req, res) => {
  const userId = req.user.id;
  
  try {
    const [rows] = await pool.query(
      "SELECT onboarding_completed FROM users_information WHERE id = ?",
      [userId]
    );
    
    res.json({ 
      success: true, 
      onboardingCompleted: rows[0]?.onboarding_completed || false 
    });
  } catch (error) {
    console.error("Error fetching onboarding status:", error);
    res.status(500).json({ 
      success: false, 
      message: "Failed to fetch onboarding status" 
    });
  }
};

module.exports = {
  getCurrentUser,
  updateUser,
  updatePassword,
  getUserTrials,
  updateAccentColor,
  getAccentColor,
  updateCurrency,
  getCurrency,
   updateOnboardingStatus,
  getOnboardingStatus,
};

