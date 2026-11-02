require("dotenv").config();
const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const authRoutes = require("./modules/auth/auth.routes");
require("./shared/database"); // DB connection
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


const app = express();

const path = require("path");


// ✅ CORS config
const allowedOrigins = [
  "https://bizkitkenya.co.ke",
  "https://www.bizkitkenya.co.ke",
  "http://bizkitkenya.co.ke",
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

// ✅ Apply before routes
app.use(cors(corsOptions));
app.options("*", cors(corsOptions)); // For preflight

// ✅ Serve static files from uploads directory
app.use('/api/uploads', express.static(path.join(__dirname, 'uploads')));

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
  res
    .status(500)
    .json({ message: "Something went wrong!", error: err.message });
});

// ✅ Server start
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
