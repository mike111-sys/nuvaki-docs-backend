require("dotenv").config();
const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const path = require("path");

// ---- DB first (creates the pool) ----
require("./shared/database");

// ---- Route imports ----
const authRoutes = require("./modules/auth/auth.routes");
const dashboardRoutes = require("./modules/dashboard/dashboard.routes");
const userRoutes = require("./modules/user/user.routes");
const trialsRoutes = require("./modules/payments-and-trials/trials.routes");
const invoiceRoutes = require("./modules/invoice/invoices.routes");
const receiptRoutes = require("./modules/receipt/receipts.routes");
const quotationRoutes = require("./modules/quotation/quotations.routes");
const contractRoutes = require("./modules/contract/contracts.routes");
const paymentsRoutes = require("./modules/payments-and-trials/payments.routes");
const customerRoutes = require("./modules/business-profile-details/customer.routes");
const paymentsUsersRoutes = require("./modules/payments-and-users/payments-users.routes");
const adminRoutes = require("./modules/admin/admin.routes");

// ---- Pending model ----
const pendingModel = require("./modules/auth/pendingRegistrationsModel");

const app = express();

// ✅ CORS config
const allowedOrigins = [
  "https://nuvakidocs.com",
  "https://www.nuvakidocs.com",
  "http://nuvakidocs.com",
  "http://localhost:5173",
  "http://localhost:8081",
];

const corsOptions = {
  origin: function (origin, callback) {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error("Not allowed by CORS"));
    }
  },
  credentials: true,
  methods: "GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS",
  allowedHeaders: ["Content-Type", "Authorization"],
  optionsSuccessStatus: 204,
};

app.use(cors(corsOptions));
app.options("*", cors(corsOptions));

// ✅ Static files
app.use("/api/uploads", express.static(path.join(__dirname, "uploads")));

// ✅ Body parsers
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// ✅ Routes
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/user", userRoutes);
app.use("/api/users/trials", trialsRoutes);
app.use("/api/invoices", invoiceRoutes);
app.use("/api/receipts", receiptRoutes);
app.use("/api/quotations", quotationRoutes);
app.use("/api/contracts", contractRoutes);
app.use("/api/payments", paymentsRoutes);
app.use("/api/customers", customerRoutes);
app.use("/api/payments-users", paymentsUsersRoutes);
app.use("/api/admin", adminRoutes);

// ✅ Error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: "Something went wrong!", error: err.message });
});

// ✅ Server start
const PORT = process.env.PORT || 5000;
const server = app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);

  // Give the DB pool 3s to connect, then clean up expired pending rows.
  // Then repeat every hour.
  setTimeout(() => {
    pendingModel
      .cleanupExpired()
      .then(() => console.log("🧹 Pending registrations cleaned"))
      .catch((err) =>
        console.error("Pending cleanup failed:", err.message)
      );
  }, 3000);

  setInterval(() => {
    pendingModel
      .cleanupExpired()
      .catch((err) =>
        console.error("Pending cleanup failed:", err.message)
      );
  }, 60 * 60 * 1000);
});

// Graceful shutdown (optional but good practice on VPS)
process.on("SIGTERM", () => {
  console.log("SIGTERM received, closing server...");
  server.close(() => process.exit(0));
});