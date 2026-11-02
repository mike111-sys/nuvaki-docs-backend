const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");
const nodemailer = require("nodemailer");
const usersModel = require("../user/users.model");
const { sendWelcomeEmail } = require("../../shared/email.service");

// Register user function
const registerUser = async (req, res) => {
  const {
    id,
    name,
    business_name,
    phone_number,
    country,          // ← NEW
    email_address,
    password,
    created_at,
  } = req.body;

  try {
    // Hash the password before storing
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(password, saltRounds);

    const defaultTrials = 5;

    const userData = {
      id,
      name,
      business_name: business_name || null,
      phone_number: phone_number || null,   // ← now optional
      country: country || null,             // ← NEW
      email_address,
      password: hashedPassword,
      trials: defaultTrials,
      created_at: created_at || new Date(),
    };

    await usersModel.createUser(userData);

    // 🔔 Fire welcome email (non-blocking — a failure must NOT break signup)
    if (email_address) {
      sendWelcomeEmail({ to: email_address, name })
        .then(() => console.log(`📧 Welcome email sent → ${email_address}`))
        .catch((err) =>
          console.error("Welcome email failed:", err.message)
        );
    }

    res.status(200).json({ success: true, message: "User saved to MySQL" });
  } catch (error) {
    console.error("Error inserting user:", error);

    if (error.code === "ER_DUP_ENTRY") {
      return res.status(400).json({
        success: false,
        message: "Email already exists",
      });
    }

    res.status(500).json({
      success: false,
      message: "Failed to insert user into MySQL",
    });
  }
};

// Login User function
const loginUser = async (req, res) => {
  const { email_address, password } = req.body;

  try {
    // Check if the user exists using model
    const user = await usersModel.findUserByEmail(email_address);

    if (!user) {
      return res.status(401).json({
        success: false,
        message: "Invalid email or password",
      });
    }

    // Compare passwords using bcrypt
    const isPasswordMatch = await bcrypt.compare(password, user.password);
    if (!isPasswordMatch) {
      return res.status(401).json({
        success: false,
        message: "Invalid email or password",
      });
    }

    // Remove password before sending user data
    const { password: _, ...userData } = user;

    // Generate JWT token
    const token = jwt.sign(
      { id: user.id }, // payload
      process.env.JWT_SECRET,
      { expiresIn: "24h" } // token expiry
    );

    // Send response with user and token
    res.status(200).json({
      success: true,
      message: "Login successful",
      user: userData,
      token,
    });
  } catch (error) {
    console.error("Login error:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
};

// Forgot password function
const forgotPassword = async (req, res) => {
  const { email } = req.body;

  try {
    // Check if the user exists using model
    const user = await usersModel.findUserByEmail(email);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "Email not found",
      });
    }

    // Generate token & expiration
    const token = crypto.randomBytes(32).toString("hex");
    const expires = Date.now() + 3600000; // 1 hour

    // Save token in database using model
    await usersModel.updateUserResetToken(email, token, expires);

    // Create password reset link
    const resetLink = `${process.env.FRONTEND_URL}/reset-password?token=${token}`;

    // Configure Gmail transporter
    const transporter = nodemailer.createTransport({
      host: "smtp.gmail.com",
      port: 587,
      secure: false, // use TLS
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
      },
    });

    // Send reset email
    await transporter.sendMail({
      from: process.env.EMAIL_USER,
      to: email,
      subject: "Biz Kit Kenya - Password Reset",
      html: `
          <p>Hello,</p>
          <p>You requested a password reset at Biz Kit Kenya. Click the link below to reset your password:</p>
          <p><a href="${resetLink}">${resetLink}</a></p>
          <p>This link will expire in 1 hour.</p>
        `,
    });

    // Respond with success
    res.json({
      success: true,
      message: "Reset link sent. Check your email.",
    });
  } catch (error) {
    console.error("Forgot password error:", error);
    res.status(500).json({
      success: false,
      message: "Something went wrong",
    });
  }
};

// Verify reset token function
const verifyResetToken = async (req, res) => {
  const { token } = req.body;

  try {
    // Verify token using model
    const user = await usersModel.findUserByResetToken(token);

    if (!user) {
      return res.status(400).json({
        success: false,
        message: "Invalid or expired token",
      });
    }

    res.json({ success: true });
  } catch (error) {
    console.error("Verify reset token error:", error);
    res.status(500).json({
      success: false,
      message: "Server error validating token",
    });
  }
};

// Reset password function
const resetPassword = async (req, res) => {
  const { token, password } = req.body;

  try {
    // Verify token again using model
    const user = await usersModel.findUserByResetToken(token);

    if (!user) {
      return res.status(400).json({
        success: false,
        message: "Invalid or expired token",
      });
    }

    // Hash new password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Update password and clear token fields using model
    await usersModel.updateUserPassword(user.email_address, hashedPassword);

    res.json({
      success: true,
      message: "Password has been reset successfully.",
    });
  } catch (error) {
    console.error("Reset password error:", error);
    res.status(500).json({
      success: false,
      message: "Server error resetting password",
    });
  }
};

module.exports = {
  registerUser,
  loginUser,
  forgotPassword,
  verifyResetToken,
  resetPassword,
};
