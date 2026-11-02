const multer = require("multer");
const path = require("path");
const fs = require("fs");
const {
  updateUserLogo,
  getUserLogo,
  clearUserLogo
} = require("../user/users.model");

// Configure storage for multer
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    // Use absolute path from project root
    const uploadPath = path.join(process.cwd(), 'uploads', 'logos');
    
    // Create directory if it doesn't exist
    if (!fs.existsSync(uploadPath)) {
      fs.mkdirSync(uploadPath, { recursive: true });
    }
    
    cb(null, uploadPath);
  },
  filename: function (req, file, cb) {
    // Create unique filename with user ID and timestamp
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    const fileExtension = path.extname(file.originalname);
    const fileName = `user-${req.user.id}-${uniqueSuffix}${fileExtension}`;
    cb(null, fileName);
  }
});

// File filter for images only
const fileFilter = (req, file, cb) => {
  const allowedTypes = /jpeg|jpg|png|gif/;
  const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
  const mimetype = allowedTypes.test(file.mimetype);
  
  if (mimetype && extname) {
    return cb(null, true);
  } else {
    cb(new Error('Only image files (jpeg, jpg, png, gif) are allowed!'));
  }
};

// Initialize upload middleware
const upload = multer({
  storage: storage,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB limit
  fileFilter: fileFilter
});

// Upload logo function
const uploadLogo = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: 'No file uploaded' });
    }

    // 1. Get current logo
    const userLogo = await getUserLogo(req.user.id);

    // 2. Delete old file if exists
    if (userLogo && userLogo.logo) {
      const oldFileName = path.basename(userLogo.logo);
      const oldPath = path.join(process.cwd(), 'uploads', 'logos', oldFileName);

      if (fs.existsSync(oldPath)) {
        fs.unlinkSync(oldPath);
      }
    }

    // 3. Save new logo
    const fileName = req.file.filename;
    const fileUrl = `/api/uploads/logos/${fileName}`;

    await updateUserLogo(req.user.id, fileUrl);

    res.json({ 
      success: true, 
      message: 'Logo updated successfully! Changes will reflect on documents on your next login.',
      logoUrl: fileUrl 
    });

  } catch (error) {
    console.error("Logo upload error:", error);
    res.status(500).json({ message: "Server error" });
  }
};


// Remove logo function
const removeLogo = async (req, res) => {
  try {
    // Get current logo path using model
    const userLogo = await getUserLogo(req.user.id);
    
    if (userLogo && userLogo.logo) {
      // Extract filename from URL
      const logoUrl = userLogo.logo;
      const fileName = path.basename(logoUrl);
      const logoPath = path.join(process.cwd(), 'uploads', 'logos', fileName);
      
      // Delete file from filesystem
      if (fs.existsSync(logoPath)) {
        fs.unlinkSync(logoPath);
      }
    }
    
    // Clear logo from database using model
    await clearUserLogo(req.user.id);
    
    res.json({ 
      success: true, 
      message: 'Logo removed successfully. Will reflect upon next login.' 
    });
  } catch (error) {
    console.error("Logo removal error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = {
  upload,
  uploadLogo,
  removeLogo
};