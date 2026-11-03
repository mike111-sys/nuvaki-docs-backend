const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");
const nodemailer = require("nodemailer");
const { OAuth2Client } = require("google-auth-library");
const usersModel = require("../user/users.model");
const pendingModel = require("./pendingRegistrationsModel");
const { sendWelcomeEmail } = require("../../shared/email.service");

const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

// ---------- Helpers ----------
const getTransporter = () =>
  nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: Number(process.env.SMTP_PORT) || 587,
    secure: process.env.SMTP_SECURE === "true",
    auth: { user: process.env.SMTP_USER, pass: process.env.SMTP_PASS },
    connectionTimeout: 10000,
    greetingTimeout: 10000,
  });

const signUserToken = (user) =>
  jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: "24h" });

const signPendingToken = (pendingId, email) =>
  jwt.sign(
    { pendingId, email, purpose: "pending-registration" },
    process.env.JWT_SECRET,
    { expiresIn: "2h" }
  );

// ============================================================
// REGISTER (Email) — writes to pending_registrations ONLY
// ============================================================
const registerUser = async (req, res) => {
  const {
    name,
    business_name,
    phone_number,
    country,
    email_address,
    password,
  } = req.body;

  try {
    if (!email_address || !password || !name) {
      return res.status(400).json({
        success: false,
        message: "Name, email and password are required",
      });
    }

    // Already a real user?
    const existing = await usersModel.findUserByEmail(email_address);
    if (existing) {
      return res
        .status(409)
        .json({ success: false, message: "Email already registered" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const verificationToken = crypto.randomBytes(32).toString("hex");
    const verificationExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000);
    const pendingId = crypto.randomUUID();

    // Save to PENDING table — NOT users_information
    await pendingModel.upsertPending({
      id: pendingId,
      type: "email",
      name,
      email_address,
      password: hashedPassword,
      business_name: business_name || null,
      phone_number: phone_number || null,
      country: country || null,
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
      // Rollback the pending row so the user can retry cleanly
      await pendingModel.deleteById(pendingId);
      return res.status(500).json({
        success: false,
        message: "Could not send verification email. Please try again.",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Verification email sent. Check your inbox to complete registration.",
    });
  } catch (error) {
    console.error("registerUser error:", error);
    return res
      .status(500)
      .json({ success: false, message: "Failed to register user" });
  }
};

// ============================================================
// VERIFY EMAIL — promotes pending row into users_information
// ============================================================
const verifyEmail = async (req, res) => {
  const { token } = req.body;
  if (!token) {
    return res.status(400).json({ success: false, message: "Token required" });
  }
  try {
    const pending = await pendingModel.findByToken(token);
    if (!pending) {
      return res.status(400).json({
        success: false,
        message: "Invalid or expired verification token",
      });
    }

    // Double-check the email wasn't claimed in the meantime
    const claimed = await usersModel.findUserByEmail(pending.email_address);
    if (claimed) {
      await pendingModel.deleteById(pending.id);
      return res
        .status(409)
        .json({ success: false, message: "Email already registered" });
    }

    // NOW create the real user — verified
    const userId = crypto.randomUUID();
    await usersModel.createUser({
      id: userId,
      name: pending.name,
      business_name: pending.business_name,
      phone_number: pending.phone_number,
      country: pending.country,
      email_address: pending.email_address,
      password: pending.password, // already hashed
      trials: 5,
      created_at: new Date(),
      email_verified: 1,
      verification_token: null,
      verification_expiry: null,
    });

    // Clean up pending
    await pendingModel.deleteById(pending.id);

    // Welcome email (fire & forget)
    sendWelcomeEmail({
      to: pending.email_address,
      name: pending.name,
    }).catch((e) => console.error("Welcome email failed:", e.message));

    return res.json({
      success: true,
      message: "Email verified. You can now log in.",
    });
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
    const token = signUserToken(user);
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
// GOOGLE LOGIN — writes to pending_registrations ONLY (for new users)
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

    // Existing user → normal login
    const existingUser = await usersModel.findUserByEmail(email);
    if (existingUser) {
      // Link google_id if not linked
      if (!existingUser.google_id) {
        await usersModel.updateUserFields(existingUser.id, {
          google_id: googleId,
        });
      }
      const token = signUserToken(existingUser);
      return res.status(200).json({
        success: true,
        isNewUser: false,
        token,
        user: {
          id: existingUser.id,
          name: existingUser.name,
          email: existingUser.email_address,
          business_name: existingUser.business_name,
          country: existingUser.country,
          phone_number: existingUser.phone_number,
        },
      });
    }

    // New user → save pending, return a pending-only JWT
    const pendingId = crypto.randomUUID();
    await pendingModel.upsertPending({
      id: pendingId,
      type: "google",
      name: name || email.split("@")[0],
      email_address: email,
      google_id: googleId,
      // Store Google's verification status in a temp way — we trust Google
      // We'll set email_verified=1 at the moment of creation
    });

    const pendingToken = signPendingToken(pendingId, email);

    return res.status(200).json({
      success: true,
      isNewUser: true,
      pendingToken,
      pendingUser: { name, email },
    });
  } catch (error) {
    console.error("googleLogin error:", error);
    return res
      .status(401)
      .json({ success: false, message: "Invalid Google token" });
  }
};

// ============================================================
// COMPLETE GOOGLE REGISTRATION — creates the real user
// ============================================================
const completeGoogleRegistration = async (req, res) => {
  const { pendingId } = req.pending;
  const { business_name, country, phone_number, password } = req.body;

  try {
    const pending = await pendingModel.findById(pendingId);
    if (!pending) {
      return res.status(400).json({
        success: false,
        message: "Pending registration expired. Please start again.",
      });
    }

    // Guard against race (email now claimed)
    const claimed = await usersModel.findUserByEmail(pending.email_address);
    if (claimed) {
      await pendingModel.deleteById(pendingId);
      return res
        .status(409)
        .json({ success: false, message: "Email already registered" });
    }

    const hashedPassword = password
      ? await bcrypt.hash(password, 10)
      : null;

    // NOW create the real user
    const userId = crypto.randomUUID();
    await usersModel.createUser({
      id: userId,
      name: pending.name,
      business_name: business_name || null,
      phone_number: phone_number || null,
      country: country || null,
      email_address: pending.email_address,
      password: hashedPassword,
      trials: 5,
      created_at: new Date(),
      email_verified: 1, // Google already verified the email
      google_id: pending.google_id,
    });

    await pendingModel.deleteById(pendingId);

    // Issue the real JWT
    const token = signUserToken({ id: userId });

    return res.json({
      success: true,
      message: "Registration complete",
      token,
      user: {
        id: userId,
        name: pending.name,
        email: pending.email_address,
        business_name: business_name || null,
        country: country || null,
        phone_number: phone_number || null,
      },
    });
  } catch (error) {
    console.error("completeGoogleRegistration error:", error);
    return res
      .status(500)
      .json({ success: false, message: "Failed to complete registration" });
  }
};

// ============================================================
// FORGOT / RESET PASSWORD (unchanged)
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