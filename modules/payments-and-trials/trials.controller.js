const {
  findUserTrialsById,
  updateUserTrials
} = require("../user/users.model");

// Get current user's trials
const getTrials = async (req, res) => {
  try {
    const userTrials = await findUserTrialsById(req.user.id);
    res.json({ trials: userTrials?.trials || 0 });
  } catch (err) {
    console.error("Fetch trials error:", err);
    res.status(500).json({ message: "Server error fetching trials" });
  }
};

// Decrement trials by 1
const decrementTrials = async (req, res) => {
  try {
    // Get current trials
    const userTrials = await findUserTrialsById(req.user.id);
    
    if (!userTrials || userTrials.trials <= 0) {
      return res.status(400).json({ message: "No trials remaining" });
    }

    // Decrement trials by 1
    const newTrialsValue = userTrials.trials - 1;
    await updateUserTrials(req.user.id, newTrialsValue);

    res.json({ 
      message: "Trial decremented", 
      trials: newTrialsValue 
    });
  } catch (err) {
    console.error("Decrement trials error:", err);
    res.status(500).json({ message: "Failed to decrement trials" });
  }
};

module.exports = {
  getTrials,
  decrementTrials,
};