const axios = require("axios");
const paymentPlansModel = require("./payment.plans.model");
const paymentModel = require("./payment.model");
const usersModel = require("../user/users.model");
const { resolveCurrency } = require("../../shared/currency");
const pool = require("../../shared/database");   // ✅ import once

// Get all payment plans — currency-aware
exports.getPaymentPlans = async (req, res) => {
  try {
    const userId = req.user?.id;

    let currency = "KES";
    if (userId) {
      const [rows] = await pool.query(                 // ✅ array destructure
        "SELECT country FROM users_information WHERE id = ?",
        [userId]
      );
      currency = resolveCurrency(rows[0]?.country);
    } else {
      currency = "KES";
    }

    const plans = await paymentPlansModel.findAllPaymentPlansForCurrency(
      currency
    );
    res.json({
      success: true,
      currency,
      payment_channels:
        currency === "USD" ? ["card"] : ["card", "mobile_money"],
      data: plans,
    });
  } catch (error) {
    console.error("getPaymentPlans error:", error);
    res
      .status(500)
      .json({ success: false, message: "Failed to fetch payment plans" });
  }
};

// Initialize payment
exports.initializePayment = async (req, res) => {
  const { plan_id } = req.body;
  const userId = req.user?.id;

  if (!userId) {
    return res.status(401).json({ success: false, message: "Unauthorized" });
  }

  try {
    // --- 1. Determine user's currency ---
    const [rows] = await pool.query(                     // ✅ array destructure
      "SELECT country, email_address FROM users_information WHERE id = ?",
      [userId]
    );
    const userRow = rows[0];

    if (!userRow?.email_address) {
      return res
        .status(400)
        .json({ success: false, message: "User not found" });
    }

    const currency = resolveCurrency(userRow.country);
    const isUSD = currency === "USD";

    // --- 2. Fetch plan priced in correct currency ---
    const plan = await paymentPlansModel.findPaymentPlanForCurrency(
      plan_id,
      currency
    );
    if (!plan) {
      return res.status(400).json({ success: false, message: "Invalid plan" });
    }

    // --- 3. Cooldown check ---
    const recentPayment =
      await paymentModel.findRecentPaymentWithCooldownByPlan(userId, plan_id);

    if (recentPayment) {
      const secondsRemaining = Math.ceil(recentPayment.seconds_remaining);
      const minutesRemaining = Math.ceil(secondsRemaining / 60);

      let statusMessage = "";
      if (recentPayment.status === "pending") {
        statusMessage = `You have a pending payment for the "${plan.name}" plan. `;
      } else if (recentPayment.status === "successful") {
        statusMessage = `You recently purchased the "${plan.name}" plan. `;
      } else if (recentPayment.status === "failed") {
        statusMessage = `Your recent attempt to purchase the "${plan.name}" plan failed. `;
      }

      return res.status(429).json({
        success: false,
        message: `${statusMessage}Please wait ${minutesRemaining} minute${
          minutesRemaining > 1 ? "s" : ""
        } before trying again for this plan.`,
        data: {
          secondsRemaining,
          minutesRemaining,
          paymentId: recentPayment.id,
          planId: recentPayment.plan_id,
          planName: plan.name,
          createdAt: recentPayment.created_at,
          status: recentPayment.status,
          currency,
        },
      });
    }

    const reference = `PAY-${Date.now()}-${Math.floor(Math.random() * 1000)}`;

    // --- 4. Create payment record ---
    await paymentModel.createPayment({
      user_id: userId,
      plan_id: plan.id,
      reference: reference,
      amount: plan.price,
      currency: currency,
      tokens_added: plan.tokens,
      status: "pending",
    });

    // --- 5. Init with Paystack ---
    const amountInSubunit = Math.round(plan.price * 100);

    const paystackPayload = {
      amount: amountInSubunit,
      email: userRow.email_address,
      reference,
      currency: currency,
      callback_url: `${process.env.FRONTEND_URL}/payment/verify`,
      metadata: { userId, plan_id: plan.id, currency },
    };

    if (isUSD) {
      paystackPayload.channels = ["card"];
    }

    const response = await axios.post(
      "https://api.paystack.co/transaction/initialize",
      paystackPayload,
      {
        headers: {
          Authorization: `Bearer ${process.env.PAYSTACK_SECRET_KEY}`,
          "Content-Type": "application/json",
        },
      }
    );

    res.json({
      success: true,
      data: {
        authorization_url: response.data.data.authorization_url,
        reference,
        currency,
      },
    });
  } catch (error) {
    console.error(
      "initializePayment error:",
      error.response?.data || error.message
    );
    res
      .status(500)
      .json({ success: false, message: "Initialization failed" });
  }
};

// Verify payment — unchanged except currency is now recorded in verify
exports.verifyPayment = async (req, res) => {
  const { reference } = req.query;
  const userId = req.user.id;

  try {
    const payment = await paymentModel.findPaymentByReference(reference);

    if (!payment) {
      return res
        .status(404)
        .json({ success: false, message: "Payment not found" });
    }

    if (payment.status === "successful") {
      return res.json({ success: true, message: "Already verified" });
    }

    const response = await axios.get(
      `https://api.paystack.co/transaction/verify/${reference}`,
      {
        headers: {
          Authorization: `Bearer ${process.env.PAYSTACK_SECRET_KEY}`,
        },
      }
    );

    const paystackData = response.data.data;
    const paystackStatus = paystackData.status;

    if (paystackStatus !== "success") {
      await paymentModel.updatePaymentStatus(reference, "failed");
      return res
        .status(400)
        .json({ success: false, message: "Payment not successful" });
    }

    // Extra safety: verify currency matches what we expected
    if (
      payment.currency &&
      paystackData.currency &&
      paystackData.currency !== payment.currency
    ) {
      console.warn(
        `Currency mismatch for ${reference}: expected ${payment.currency}, got ${paystackData.currency}`
      );
      await paymentModel.updatePaymentStatus(reference, "failed");
      return res
        .status(400)
        .json({ success: false, message: "Currency mismatch — payment rejected" });
    }

    // Extra safety: verify amount matches
    const expectedSubunit = Math.round(Number(payment.amount) * 100);
    if (Number(paystackData.amount) !== expectedSubunit) {
      console.warn(
        `Amount mismatch for ${reference}: expected ${expectedSubunit}, got ${paystackData.amount}`
      );
      await paymentModel.updatePaymentStatus(reference, "failed");
      return res
        .status(400)
        .json({ success: false, message: "Amount mismatch — payment rejected" });
    }

    const planWithBonus = await paymentPlansModel.findPaymentPlanByIdWithBonus(
  payment.plan_id,
  payment.currency || "KES"
);
    const bonusTokens = planWithBonus?.bonus_tokens || 0;
    const totalTokens = payment.tokens_added + bonusTokens;

    const userTrials = await usersModel.findUserTrialsById(userId);
    const currentTrials = userTrials?.trials || 0;
    const updatedTrials = currentTrials + totalTokens;

    await usersModel.updateUserTrials(userId, updatedTrials);
    await paymentModel.updatePaymentStatus(reference, "successful");

    res.json({
      success: true,
      message: "Payment verified successfully",
      data: {
        trials: updatedTrials,
        tokensAdded: payment.tokens_added,
        bonusTokens,
        reference,
        currency: payment.currency,
      },
    });
  } catch (error) {
    console.error("Verification error:", error);
    res.status(500).json({ success: false, message: "Verification failed" });
  }
};

// getPaymentHistory and getPendingPayments unchanged — but now they include currency automatically.
exports.getPaymentHistory = async (req, res) => {
  const userId = req.user.id;
  try {
    const history = await paymentModel.findPaymentHistoryByUser(userId);
    res.json({ success: true, data: history });
  } catch (error) {
    res.status(500).json({ success: false, message: "Could not get history" });
  }
};

exports.getPendingPayments = async (req, res) => {
  const userId = req.user.id;
  try {
    const recentPayments =
      await paymentModel.findRecentPaymentsWithCooldownByPlan(userId);
    res.json({
      success: true,
      data: recentPayments.map((payment) => ({
        ...payment,
        canRetry: payment.seconds_remaining <= 0,
      })),
    });
  } catch (error) {
    res
      .status(500)
      .json({ success: false, message: "Error fetching recent payments" });
  }
};