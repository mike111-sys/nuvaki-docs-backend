const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");
const nodemailer = require("nodemailer");
const { OAuth2Client } = require("google-auth-library");
const usersModel = require("../user/users.model");
const { sendWelcomeEmail } = require("../../shared/email.service");

const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

// ---------- Helper: SMTP transporter ----------
const getTransporter = () =>
  nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: Number(process.env.SMTP_PORT) || 587,
    secure: process.env.SMTP_SECURE === "true",  // ← FIX: reads from .env
    auth: {
      user: process.env.SMTP_USER,
      pass: process.env.SMTP_PASS,
    },
    // Add these for faster failure diagnosis (optional but recommended)
    connectionTimeout: 10000,
    greetingTimeout: 10000,
  });

// ---------- Helper: sign JWT ----------
const signToken = (user) =>
  jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: "24h" });

// ============================================================
// REGISTER (Email/SMTP)
// ============================================================
const registerUser = async (req, res) => {
  const {
    id,
    name,
    business_name,
    phone_number,
    country,
    email_address,
    password,
  } = req.body;

  try {
    if (!email_address || !password || !name) {
      return res
        .status(400)
        .json({ success: false, message: "Name, email and password are required" });
    }

    const existing = await usersModel.findUserByEmail(email_address);
    if (existing) {
      return res
        .status(409)
        .json({ success: false, message: "Email already registered" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const verificationToken = crypto.randomBytes(32).toString("hex");
    const verificationExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000);

    const userId = id || crypto.randomUUID();

    await usersModel.createUser({
      id: userId,
      name,
      business_name: business_name || null,
      phone_number: phone_number || null,
      country: country || null,
      email_address,
      password: hashedPassword,
      trials: 5,
      created_at: new Date(),
      email_verified: 0,
      verification_token: verificationToken,
      verification_expiry: verificationExpiry,
    });

    // Send verification email
    try {
      const transporter = getTransporter();
      const verifyLink = `${process.env.FRONTEND_URL}/verify-email?token=${verificationToken}`;
      await transporter.sendMail({
        from: process.env.SMTP_USER,
        to: email_address,
        subject: "Verify your Biz Kit Kenya account",
        html: `
          <p>Hi ${name},</p>
          <p>Thanks for signing up to Biz Kit Kenya!</p>
          <p>Click the link below to verify your email. This link expires in 24 hours.</p>
          <p><a href="${verifyLink}">${verifyLink}</a></p>
        `,
      });
    } catch (emailErr) {
      console.error("SMTP send failed:", emailErr.message);
      console.error("SMTP config at send time:", {
        host: process.env.SMTP_HOST,
        port: process.env.SMTP_PORT,
        secureRaw: process.env.SMTP_SECURE,
        secureResolved: process.env.SMTP_SECURE === "true",
      });
      console.error("SMTP full error:", emailErr);
    }

    return res.status(200).json({
      success: true,
      message: "Registration successful. Check your email to verify.",
    });
  } catch (error) {
    console.error("registerUser error:", error);
    if (error.code === "ER_DUP_ENTRY") {
      return res
        .status(409)
        .json({ success: false, message: "Email already exists" });
    }
    return res
      .status(500)
      .json({ success: false, message: "Failed to register user" });
  }
};

// ============================================================
// VERIFY EMAIL
// ============================================================
const verifyEmail = async (req, res) => {
  const { token } = req.body;
  if (!token) {
    return res.status(400).json({ success: false, message: "Token required" });
  }
  try {
    const user = await usersModel.findUserByVerificationToken(token);
    if (!user) {
      return res
        .status(400)
        .json({ success: false, message: "Invalid or expired token" });
    }
    await usersModel.markEmailVerified(user.id);

    // Fire welcome email (optional)
    if (user.email_address) {
      sendWelcomeEmail({ to: user.email_address, name: user.name }).catch(
        (e) => console.error("Welcome email failed:", e.message)
      );
    }

    return res.json({ success: true, message: "Email verified" });
  } catch (error) {
    console.error("verifyEmail error:", error);
    return res
      .status(500)
      .json({ success: false, message: "Verification failed" });
  }
};

// ============================================================
// LOGIN
// ============================================================
const loginUser = async (req, res) => {
  const { email_address, password } = req.body;

  try {
    const user = await usersModel.findUserByEmail(email_address);
    if (!user) {
      return res
        .status(401)
        .json({ success: false, message: "Invalid email or password" });
    }

    if (!user.password) {
      return res.status(401).json({
        success: false,
        message: "This account uses Google sign-in. Please log in with Google.",
      });
    }

    const match = await bcrypt.compare(password, user.password);
    if (!match) {
      return res
        .status(401)
        .json({ success: false, message: "Invalid email or password" });
    }

    if (!user.email_verified) {
      return res.status(403).json({
        success: false,
        message: "Please verify your email before logging in.",
      });
    }

    const { password: _, ...userData } = user;
    const token = signToken(user);

    return res.status(200).json({
      success: true,
      message: "Login successful",
      user: userData,
      token,
    });
  } catch (error) {
    console.error("loginUser error:", error);
    return res
      .status(500)
      .json({ success: false, message: "Internal server error" });
  }
};

// ============================================================
// GOOGLE LOGIN
// ============================================================
const googleLogin = async (req, res) => {
  const { idToken } = req.body;

  if (!idToken) {
    return res
      .status(400)
      .json({ success: false, message: "Missing Google idToken" });
  }

  try {
    const ticket = await googleClient.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });
    const payload = ticket.getPayload();
    const { email, name, sub: googleId, email_verified } = payload;

    let user = await usersModel.findUserByEmail(email);
    let isNewUser = false;

    if (!user) {
      // New user — create a stub record, they'll complete profile in GoogleNextStep
      isNewUser = true;
      const newId = crypto.randomUUID();
      await usersModel.createUser({
        id: newId,
        name: name || email.split("@")[0],
        business_name: null,
        phone_number: null,
        country: null,
        email_address: email,
        password: null,
        trials: 5,
        created_at: new Date(),
        email_verified: email_verified ? 1 : 0,
        google_id: googleId,
      });
      user = await usersModel.findUserByEmail(email);
    } else if (!user.google_id) {
      // Existing email user logging in with Google — link google_id
      await usersModel.updateUserFields(user.id, { google_id: googleId });
    }
    const token = signToken(user);

    return res.status(200).json({
      success: true,
      token,
      isNewUser,
      user: {
        id: user.id,
        name: user.name,
        email: user.email_address,
        business_name: user.business_name,
        country: user.country,
        phone_number: user.phone_number,
      },
    });
  } catch (error) {
    console.error("googleLogin error:", error);
    return res
      .status(401)
      .json({ success: false, message: "Invalid Google token" });
  }
};

// ============================================================
// COMPLETE GOOGLE REGISTRATION (protected route)
// ============================================================
const completeGoogleRegistration = async (req, res) => {
  const userId = req.user.id; // set by auth middleware
  const { business_name, country, phone_number, password } = req.body;

  try {
    const updates = {};
    if (business_name) updates.business_name = business_name;
    if (country) updates.country = country;
    if (phone_number) updates.phone_number = phone_number;
    if (password) updates.password = await bcrypt.hash(password, 10);

    // If user set a password, they can log in via email too → mark verified
    if (password) updates.email_verified = 1;

    await usersModel.updateUserFields(userId, updates);

    return res.json({ success: true, message: "Profile completed" });
  } catch (error) {
    console.error("completeGoogleRegistration error:", error);
    return res
      .status(500)
      .json({ success: false, message: "Failed to complete registration" });
  }
};

// ============================================================
// FORGOT / RESET PASSWORD (unchanged logic)
// ============================================================
const forgotPassword = async (req, res) => {
  const { email } = req.body;
  try {
    const user = await usersModel.findUserByEmail(email);
    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "Email not found" });
    }

    const token = crypto.randomBytes(32).toString("hex");
    const expires = Date.now() + 3600000;
    await usersModel.updateUserResetToken(email, token, expires);

    const resetLink = `${process.env.FRONTEND_URL}/reset-password?token=${token}`;
    const transporter = getTransporter();
    await transporter.sendMail({
      from: process.env.SMTP_USER,
      to: email,
      subject: "Biz Kit Kenya - Password Reset",
      html: `
        <p>Hello,</p>
        <p>Click the link below to reset your password:</p>
        <p><a href="${resetLink}">${resetLink}</a></p>
        <p>This link expires in 1 hour.</p>
      `,
    });

    return res.json({ success: true, message: "Reset link sent." });
  } catch (error) {
    console.error("forgotPassword error:", error);
    return res
      .status(500)
      .json({ success: false, message: "Something went wrong" });
  }
};

const verifyResetToken = async (req, res) => {
  const { token } = req.body;
  try {
    const user = await usersModel.findUserByResetToken(token);
    if (!user) {
      return res
        .status(400)
        .json({ success: false, message: "Invalid or expired token" });
    }
    return res.json({ success: true });
  } catch (error) {
    console.error("verifyResetToken error:", error);
    return res
      .status(500)
      .json({ success: false, message: "Server error" });
  }
};

const resetPassword = async (req, res) => {
  const { token, password } = req.body;
  try {
    const user = await usersModel.findUserByResetToken(token);
    if (!user) {
      return res
        .status(400)
        .json({ success: false, message: "Invalid or expired token" });
    }
    const hashed = await bcrypt.hash(password, 10);
    await usersModel.updateUserPassword(user.email_address, hashed);
    return res.json({ success: true, message: "Password reset" });
  } catch (error) {
    console.error("resetPassword error:", error);
    return res
      .status(500)
      .json({ success: false, message: "Server error" });
  }
};

module.exports = {
  registerUser,
  verifyEmail,
  loginUser,
  googleLogin,
  completeGoogleRegistration,
  forgotPassword,
  verifyResetToken,
  resetPassword,
};