// shared/email.service.js
const nodemailer = require("nodemailer");

const PORT = Number(process.env.SMTP_PORT || 465);

const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: PORT,
  // Port 465 = implicit TLS; 587 = STARTTLS
  secure: process.env.SMTP_SECURE === "true" || PORT === 465,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS,
  },
  // Fail fast if the SMTP server is unreachable
  connectionTimeout: 15000,
  greetingTimeout: 10000,
  socketTimeout: 20000,
});

// Verify once at startup so misconfig is caught immediately
transporter
  .verify()
  .then(() => console.log("📧 SMTP ready:", process.env.SMTP_HOST))
  .catch((err) => console.error("❌ SMTP verify failed:", err.message));

const FROM = `"${process.env.SMTP_FROM_NAME || "Biz Kit Kenya"}" <${
  process.env.SMTP_FROM_EMAIL || process.env.SMTP_USER
}>`;

// ---------------------------------------------------------------------------
// Base send wrapper
// ---------------------------------------------------------------------------

const sendMail = ({ to, subject, html, text, replyTo }) =>
  transporter.sendMail({
    from: FROM,
    to,
    subject,
    html,
    text,
    replyTo: replyTo || process.env.SMTP_FROM_EMAIL,
  });

// ---------------------------------------------------------------------------
// Layout wrapper — keeps every email visually consistent
// ---------------------------------------------------------------------------

const layout = (innerHtml) => `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Biz Kit Kenya</title>
</head>
<body style="margin:0;padding:0;background:#f8fafc;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Arial,sans-serif;">
  <div style="max-width:560px;margin:0 auto;padding:32px 20px;">
    <div style="background:#ffffff;border:1px solid #e2e8f0;border-radius:16px;padding:32px 28px;">
      <div style="margin-bottom:24px;">
        <img
          src="https://bizkitkenya.co.ke/assets/kenyan-flag-BuJecBcf.png"
          alt="Biz Kit Kenya"
          width="40"
          style="display:block;max-width:140px;height:auto;border:0;"
        />
      </div>
      ${innerHtml}
    </div>
    <p style="font-size:11px;color:#94a3b8;text-align:center;margin-top:20px;line-height:1.5;">
      Biz Kit Kenya · Nairobi, Kenya<br/>
      You're receiving this because you signed up at bizkitkenya.co.ke
    </p>
  </div>
</body>
</html>`;

// ---------------------------------------------------------------------------
// Welcome email (sent automatically on registration)
// ---------------------------------------------------------------------------

const sendWelcomeEmail = async ({ to, name }) => {
  const safeName = (name || "there").split(" ")[0];

  // Plain-text fallback (very important for deliverability)
  const text = `Hi ${safeName},

Thanks for signing up for Biz Kit Kenya.

You can now create, save and print professional invoices, receipts,
quotations and contracts -- all in one place.

Get started: https://bizkitkenya.co.ke/login

Need help? Just reply to this email.

-- 
Biz Kit Kenya
https://bizkitkenya.co.ke`;

  return sendMail({
    to,
    subject: "Welcome to Biz Kit Kenya",
    text,
    html: layout(`
      <h1 style="font-size:20px;margin:0 0 12px;color:#0f172a;">
        Welcome to Biz Kit Kenya
      </h1>
      <p style="font-size:15px;line-height:1.6;color:#475569;margin:0 0 14px;">
        Hi ${safeName},
      </p>
      <p style="font-size:15px;line-height:1.6;color:#475569;margin:0 0 14px;">
        Thanks for signing up. You can now create, save and print professional
        invoices, receipts, quotations and contracts -- all in one place.
      </p>
      <p style="font-size:15px;line-height:1.6;color:#475569;margin:0 0 22px;">
        Get started by logging in:
        <a href="https://bizkitkenya.co.ke/login" style="color:#0d9488;">
          https://bizkitkenya.co.ke/login
        </a>
      </p>
      <p style="font-size:13px;color:#64748b;margin:0;">
        Need help? Just reply to this email.
      </p>
    `),
  });
};

// ---------------------------------------------------------------------------
// Bulk / update email (used from the admin dashboard)
// ---------------------------------------------------------------------------

const sendUpdateEmail = async ({ to, subject, body }) => {
  const escapeHtml = (s) =>
    String(s)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");

  // Plain-text version -- identical to the body, no HTML at all
  const text = String(body).trim();

  return sendMail({
    to,
    subject,
    text,
    html: layout(`
      <div style="font-size:15px;line-height:1.7;color:#334155;white-space:pre-wrap;">${escapeHtml(
        body
      )}</div>
    `),
  });
};

module.exports = { sendMail, sendWelcomeEmail, sendUpdateEmail };