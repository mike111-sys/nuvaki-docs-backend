// modules/admin/admin.emails.controller.js
const pool = require("../../shared/database");
const { sendUpdateEmail } = require("../../shared/email.service");

// Simple helper: split an array into chunks of N
const chunk = (arr, size) => {
  const out = [];
  for (let i = 0; i < arr.length; i += size) out.push(arr.slice(i, i + size));
  return out;
};

const BATCH_SIZE = 10; // send 10 emails in parallel per batch

// POST /api/admin/messages/send
// body: { recipients: "all" | string[] of emails, subject, message }
const sendBulkMessage = async (req, res) => {
  const { recipients, subject, message } = req.body;

  if (!subject || !subject.trim()) {
    return res
      .status(400)
      .json({ success: false, message: "Subject is required" });
  }
  if (!message || !message.trim()) {
    return res
      .status(400)
      .json({ success: false, message: "Message is required" });
  }

  try {
    let targets = [];

    if (recipients === "all") {
      const [rows] = await pool.query(
        `SELECT email_address, name
         FROM users_information
         WHERE email_address IS NOT NULL AND email_address <> ''`
      );
      targets = rows.map((r) => ({
        email: r.email_address,
        name: r.name,
      }));
    } else if (Array.isArray(recipients) && recipients.length) {
      const placeholders = recipients.map(() => "?").join(",");
      const [rows] = await pool.query(
        `SELECT email_address, name
         FROM users_information
         WHERE email_address IN (${placeholders})`,
        recipients
      );
      targets = rows.map((r) => ({
        email: r.email_address,
        name: r.name,
      }));
    } else {
      return res
        .status(400)
        .json({ success: false, message: "No recipients specified" });
    }

    if (!targets.length) {
      return res
        .status(404)
        .json({ success: false, message: "No valid recipients found" });
    }

    let sent = 0;
    let failed = 0;
    const failures = [];

    // Batch dispatch to avoid hammering the SMTP server
    for (const batch of chunk(targets, BATCH_SIZE)) {
      const results = await Promise.allSettled(
        batch.map((t) =>
          sendUpdateEmail({
            to: t.email,
            subject: subject.trim(),
            body: message.trim(),
          })
        )
      );

      results.forEach((r, i) => {
        if (r.status === "fulfilled") {
          sent++;
        } else {
          failed++;
          failures.push({
            email: batch[i].email,
            error: r.reason?.message || "Unknown error",
          });
        }
      });
    }

console.log(`📧 Bulk send complete → sent:${sent} failed:${failed}`);
if (failures.length) {
  console.error("❌ Failure details:");
  failures.forEach((f) => console.error(`   → ${f.email} | ${f.error}`));
}

    res.json({
      success: true,
      total: targets.length,
      sent,
      failed,
      failures: failures.slice(0, 10), // cap to first 10 for the response
    });
  } catch (err) {
    console.error("Bulk email error:", err);
    res.status(500).json({
      success: false,
      message: "Failed to send emails",
      error: err.message,
    });
  }
};

module.exports = { sendBulkMessage };