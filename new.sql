-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 10, 2026 at 06:39 PM
-- Server version: 8.0.42
-- PHP Version: 8.4.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gcajyemt_nuvaki_docs`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

CREATE TABLE `admin_users` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('super_admin','admin','viewer') NOT NULL DEFAULT 'admin',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `name`, `email`, `password`, `role`, `is_active`, `last_login`, `created_at`, `updated_at`) VALUES
('f66995d1-006f-4c0f-8e7d-5b74a0bc9cb3', 'Super Admin', 'admin@nuvakidocs.com', '$2a$12$/ZIomRIOJG1qOy2b4kdqzuHoCVapVNH1IJzof0ytLoyucgpUG3L1u', 'super_admin', 1, '2026-09-11 06:55:17', '2026-09-10 08:41:09', '2026-11-09 06:46:41');

-- --------------------------------------------------------

--
-- Table structure for table `contracts`
--

CREATE TABLE `contracts` (
  `id` int NOT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `contract_number` varchar(50) NOT NULL,
  `contract_type` enum('service_agreement','sales_agreement','freelance_contract','partnership_agreement') NOT NULL,
  `title` varchar(255) NOT NULL,
  `date_issued` datetime NOT NULL,
  `effective_date` date NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `party_a_name` varchar(255) NOT NULL,
  `party_a_business` varchar(255) NOT NULL,
  `party_a_email` varchar(255) DEFAULT NULL,
  `party_a_phone` varchar(20) DEFAULT NULL,
  `party_a_address` text,
  `party_a_id_number` varchar(50) DEFAULT NULL,
  `party_a_kra_pin` varchar(50) DEFAULT NULL,
  `party_b_name` varchar(255) NOT NULL,
  `party_b_business` varchar(255) DEFAULT NULL,
  `party_b_email` varchar(255) DEFAULT NULL,
  `party_b_phone` varchar(20) DEFAULT NULL,
  `party_b_address` text,
  `party_b_id_number` varchar(50) DEFAULT NULL,
  `party_b_kra_pin` varchar(50) DEFAULT NULL,
  `project_description` text,
  `scope_of_work` text,
  `deliverables` text,
  `contract_value` decimal(10,2) DEFAULT '0.00',
  `payment_terms` text,
  `payment_schedule` text,
  `deposit_amount` decimal(10,2) DEFAULT '0.00',
  `milestones` json DEFAULT NULL,
  `service_details` json DEFAULT NULL,
  `product_details` json DEFAULT NULL,
  `partnership_details` json DEFAULT NULL,
  `terms_conditions` text,
  `termination_clause` text,
  `confidentiality_clause` tinyint(1) DEFAULT '0',
  `dispute_resolution` text,
  `governing_law` varchar(100) DEFAULT 'Kenya',
  `party_a_signature` text,
  `party_a_signature_date` datetime DEFAULT NULL,
  `party_b_signature` text,
  `party_b_signature_date` datetime DEFAULT NULL,
  `witness_name` varchar(255) DEFAULT NULL,
  `witness_signature` text,
  `witness_date` datetime DEFAULT NULL,
  `status` enum('draft','sent','signed','completed','terminated','expired') NOT NULL DEFAULT 'draft',
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `currency_code` varchar(10) DEFAULT 'KES',
  `currency_symbol` varchar(10) DEFAULT 'KSh',
  `currency_name` varchar(50) DEFAULT 'Kenyan Shilling'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int NOT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `user_id`, `name`, `email`, `phone`, `address`, `created_at`, `updated_at`) VALUES
(5, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'ssacca', 'dsvd@dsa.com', NULL, NULL, '2026-09-11 10:41:44', '2026-09-11 10:41:44');

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` int NOT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `invoice_number` varchar(255) NOT NULL,
  `date` datetime NOT NULL,
  `due_date` date DEFAULT NULL,
  `client_name` varchar(255) NOT NULL,
  `client_email` varchar(255) DEFAULT NULL,
  `client_address` text,
  `business_name` varchar(255) DEFAULT NULL,
  `business_address` varchar(255) DEFAULT NULL,
  `business_phone` varchar(50) DEFAULT NULL,
  `business_email` varchar(255) DEFAULT NULL,
  `business_website` varchar(255) DEFAULT NULL,
  `tax_rate` decimal(10,2) NOT NULL DEFAULT '0.00',
  `discount_type` enum('percentage','fixed','amount') DEFAULT NULL,
  `discount_value` decimal(10,2) NOT NULL DEFAULT '0.00',
  `discount_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tax_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `notes` text,
  `status` enum('draft','sent','paid','overdue','pending','partially_paid') NOT NULL DEFAULT 'pending',
  `client_phone` varchar(20) DEFAULT NULL,
  `quotation_id` int DEFAULT NULL,
  `quotation_number` varchar(50) DEFAULT NULL,
  `total_paid` decimal(10,2) DEFAULT '0.00',
  `remaining_balance` decimal(10,2) DEFAULT '0.00',
  `payment_status` enum('unpaid','partial','paid','overdue') DEFAULT 'unpaid',
  `currency_code` varchar(10) DEFAULT 'KES',
  `currency_symbol` varchar(10) DEFAULT 'KSh',
  `currency_name` varchar(50) DEFAULT 'Kenyan Shilling',
  `default_payment_method` varchar(50) DEFAULT 'cash',
  `logo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `invoices`
--

INSERT INTO `invoices` (`id`, `user_id`, `invoice_number`, `date`, `due_date`, `client_name`, `client_email`, `client_address`, `business_name`, `business_address`, `business_phone`, `business_email`, `business_website`, `tax_rate`, `discount_type`, `discount_value`, `discount_amount`, `tax_amount`, `total_amount`, `notes`, `status`, `client_phone`, `quotation_id`, `quotation_number`, `total_paid`, `remaining_balance`, `payment_status`, `currency_code`, `currency_symbol`, `currency_name`, `default_payment_method`, `logo`) VALUES
(13, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-266-295989', '2025-06-21 00:00:00', '2025-06-30', 'Madam Getrude', 'mizengogetrude@gmail.com', '', NULL, NULL, NULL, NULL, NULL, 0.00, 'percentage', 10.00, 200.00, 0.00, 1800.00, 'Thank you for choosing Ujuzi Digital Creations! Payment is due by the specified date. We appreciate your business and look forward to serving you again.', '', NULL, NULL, NULL, 0.00, 0.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash', NULL),
(20, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-492-916336', '2025-09-21 00:00:00', NULL, 'Mercy Chege', '', '', NULL, NULL, NULL, NULL, NULL, 0.00, '', 0.00, 0.00, 0.00, 324.00, 'Thank you for choosing Ujuzi Digital Creations! Payment is due by the specified date. We appreciate your business and look forward to serving you again.', '', '', NULL, NULL, 0.00, 0.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash', NULL),
(21, 'e79e5915-b271-4a91-97ad-50ca1419419f', 'INV-891-395626', '2025-10-14 00:00:00', NULL, 'DR SHADRACK', '', 'MOSOCHO', NULL, NULL, NULL, NULL, NULL, 0.00, '', 0.00, 0.00, 0.00, 17500.00, 'Thank you for choosing kendox construction ltd! Payment is due by the specified date. We appreciate your business and look forward to serving you again.', '', '0720109389', NULL, NULL, 0.00, 0.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash', NULL),
(22, 'e79e5915-b271-4a91-97ad-50ca1419419f', 'INV-391-897113', '2026-01-18 00:00:00', NULL, 'majengo hardware', '', 'nyakoe markert', NULL, NULL, NULL, NULL, NULL, 0.00, '', 0.00, 0.00, 0.00, 320310.00, 'Thank you for choosing kendox construction ltd! Payment is due by the specified date. We appreciate your business and look forward to serving you again.', '', '0705222273', NULL, NULL, 0.00, 0.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash', NULL),
(23, 'e79e5915-b271-4a91-97ad-50ca1419419f', 'INV-265-232732', '2026-01-18 00:00:00', NULL, 'DR SHADRACK', '', 'MOSOCHO', NULL, NULL, NULL, NULL, NULL, 0.00, '', 0.00, 0.00, 0.00, 13250.00, 'Thank you for choosing kendox construction ltd! Payment is due by the specified date. We appreciate your business and look forward to serving you again.', '', '0720109389', NULL, NULL, 0.00, 0.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash', NULL),
(24, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-538-226274', '2026-02-08 00:00:00', NULL, 'fdsf', '', '', NULL, NULL, NULL, NULL, NULL, 0.00, '', 0.00, 0.00, 0.00, 322.00, 'Thank you for choosing Ujuzi Digital Creations! Payment is due by the specified date. We appreciate your business and look forward to serving you again.', '', '', NULL, NULL, 0.00, 0.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash', NULL),
(25, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-699-294620', '2026-02-08 00:00:00', NULL, 'fsfsdfds', '', '', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 2342.00, 'Thank you for choosing Ujuzi Digital Creations! Payment is due by the specified date. We appreciate your business and look forward to serving you again.', '', '', NULL, NULL, 0.00, 0.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash', NULL),
(26, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-952-345727', '2026-02-08 00:00:00', NULL, 'fsdf', '', '', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 123.00, 'Thank you for choosing Ujuzi Digital Creations! Payment is due by the specified date. We appreciate your business and look forward to serving you again.', '', '', NULL, NULL, 0.00, 0.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash', NULL),
(27, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-264-569602', '2026-02-21 00:00:00', NULL, 'Chris', '', '', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 14000.00, 'Thank you for choosing Ujuzi Digital Creations.\n-----------------------------------------------------------------------------\nThe remaining payments after making the initial deposit will be;\n- Ksh 14,000 after major development progress\n- Ksh 14,000 after completion and final review\n--------------------------------------------------------------------------------\nPayment process;\nLipa na Mpesa Buy Goods & Services,\nTill number: 3399220', '', '', NULL, NULL, 0.00, 0.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash', NULL),
(28, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-264-569602', '2026-02-21 00:00:00', NULL, 'Chris', '', '', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 14000.00, 'Thank you for choosing Ujuzi Digital Creations.\n-----------------------------------------------------------------------------\nThe remaining payments after making the initial deposit will be;\n- Ksh 14,000 after major development progress\n- Ksh 14,000 after completion and final review\n--------------------------------------------------------------------------------\nPayment process;\nLipa na Mpesa Buy Goods & Services,\nTill number: 3399220', '', '', NULL, NULL, 0.00, 0.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash', NULL),
(33, '4a881750-11b9-44fd-b473-99548b3af7a7', 'INV-493-438695', '2026-08-03 00:00:00', NULL, 'Ghshs', '', '', 'My biz biz', '', '+254112770494', 'ujuzicreations@gmail.com', '', 0.00, 'amount', 0.00, 0.00, 0.00, 128.00, 'Thank you for choosing My biz biz! Total amount of KSh 128.00 is due by the specified date. We appreciate your business and look forward to serving you again.', 'pending', '', NULL, NULL, 0.00, 128.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `invoice_items`
--

CREATE TABLE `invoice_items` (
  `id` int NOT NULL,
  `invoice_id` int NOT NULL,
  `description` text NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `invoice_items`
--

INSERT INTO `invoice_items` (`id`, `invoice_id`, `description`, `quantity`, `price`, `total`) VALUES
(19, 13, 'WhatsApp Icon Integration (basic setup & linking to WhatsApp chat)', 1, 350.00, 0.00),
(20, 13, 'WhatsApp Icon Animation (hover effects, slide-in, and pulse animation)', 1, 250.00, 0.00),
(21, 13, 'Video Modal Functionality (embedding video player with close/play controls)', 1, 300.00, 0.00),
(22, 13, 'Video Icon Setup (custom video button linked to modal)', 1, 400.00, 0.00),
(23, 13, 'Blur-to-Clear Image Loading Enhancement (lazy loading with smooth blur) and faster page loading.', 1, 700.00, 0.00),
(37, 20, 'sadndsa', 1, 324.00, 0.00),
(38, 21, 'SIMBA CEMENT', 20, 850.00, 0.00),
(39, 21, 'TRANSPORT', 1, 500.00, 0.00),
(40, 22, 'maisha mabati 32g', 80, 840.00, 0.00),
(41, 22, 'roofing nails', 2, 8500.00, 0.00),
(42, 22, 'd8', 30, 530.00, 0.00),
(43, 22, 'ordinary nails', 5, 6400.00, 0.00),
(44, 22, 'd10', 50, 820.00, 0.00),
(45, 22, 'd16', 10, 2150.00, 0.00),
(46, 22, 'balance', 1, 125710.00, 0.00),
(47, 23, 'TRANSPORT', 1, 500.00, 0.00),
(48, 23, 'simba cement', 15, 850.00, 0.00),
(49, 24, 'wegw', 1, 322.00, 0.00),
(50, 25, 'gfgreg', 1, 2342.00, 0.00),
(51, 26, 'egwwg', 1, 123.00, 0.00),
(52, 27, 'Web App Development Initial Deposit', 1, 14000.00, 0.00),
(53, 28, 'Web App Development Initial Deposit', 1, 14000.00, 0.00),
(58, 33, 'Hzh', 2, 64.00, 128.00);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int NOT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `plan_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `reference` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `currency` varchar(10) NOT NULL DEFAULT 'KES',
  `tokens_added` int DEFAULT '0',
  `status` enum('pending','successful','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'pending',
  `payment_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `payment_provider` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `user_id`, `plan_id`, `reference`, `amount`, `currency`, `tokens_added`, `status`, `payment_method`, `payment_provider`, `metadata`, `created_at`, `updated_at`) VALUES
(39, 'b6721071-c843-4a44-ba69-96f6d2bfac1c', '2', 'PAY-1750481173602-8', 59.00, 'KES', 20, '', NULL, NULL, NULL, '2025-06-21 07:46:13', '2025-06-21 07:46:47'),
(44, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1757053601989-657', 19.00, 'KES', 6, '', NULL, NULL, NULL, '2025-09-05 09:26:41', '2025-09-05 09:27:09'),
(45, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1757830555739-799', 19.00, 'KES', 6, '', NULL, NULL, NULL, '2025-09-14 09:15:55', '2025-09-14 09:16:24'),
(46, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1758442406311-262', 19.00, 'KES', 6, '', NULL, NULL, NULL, '2025-09-21 11:13:26', '2025-09-21 11:13:48'),
(47, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1760373762425-69', 19.00, 'KES', 6, '', NULL, NULL, NULL, '2025-10-13 19:42:42', '2025-10-13 19:43:14'),
(48, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1763968976389-218', 19.00, 'KES', 6, '', NULL, NULL, NULL, '2025-11-24 10:22:56', '2025-11-24 10:23:44'),
(49, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1765352700379-84', 19.00, 'KES', 6, '', NULL, NULL, NULL, '2025-12-10 10:45:00', '2025-12-10 10:45:26'),
(50, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1765783127969-243', 19.00, 'KES', 6, '', NULL, NULL, NULL, '2025-12-15 10:18:47', '2025-12-15 10:19:16'),
(51, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1768303759365-502', 19.00, 'KES', 6, '', NULL, NULL, NULL, '2026-01-13 14:29:19', '2026-01-13 14:29:47'),
(52, 'e79e5915-b271-4a91-97ad-50ca1419419f', '2', 'PAY-1768734472910-411', 59.00, 'KES', 20, '', NULL, NULL, NULL, '2026-01-18 14:07:52', '2026-01-18 14:09:32'),
(53, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1771348966887-871', 19.00, 'KES', 6, 'failed', NULL, NULL, NULL, '2026-02-17 20:22:46', '2026-02-17 20:22:47'),
(54, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2', 'PAY-1771349188491-829', 59.00, 'KES', 20, 'failed', NULL, NULL, NULL, '2026-02-17 20:26:28', '2026-02-17 20:26:29'),
(55, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1780462064070-613', 19.00, 'KES', 6, '', NULL, NULL, NULL, '2026-06-03 07:47:44', '2026-06-03 07:48:19'),
(56, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1781372611782-509', 19.00, 'KES', 6, '', NULL, NULL, NULL, '2026-06-13 20:43:31', '2026-06-13 20:46:15'),
(57, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1781373270889-690', 19.00, 'KES', 6, 'failed', NULL, NULL, NULL, '2026-06-13 20:54:30', '2026-06-13 20:54:31'),
(58, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1781544453443-983', 19.00, 'KES', 6, '', NULL, NULL, NULL, '2026-06-15 20:27:33', '2026-06-15 20:28:05'),
(59, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1785867069666-327', 19.00, 'KES', 6, 'successful', NULL, NULL, NULL, '2026-08-04 21:11:09', '2026-08-04 21:11:46'),
(60, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1786277523753-455', 19.00, 'KES', 6, 'failed', NULL, NULL, NULL, '2026-08-09 15:12:03', '2026-08-09 15:12:04'),
(61, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2', 'PAY-1786277570015-979', 59.00, 'KES', 20, 'failed', NULL, NULL, NULL, '2026-08-09 15:12:50', '2026-08-09 15:12:50'),
(62, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '3', 'PAY-1786277739000-652', 119.00, 'KES', 45, 'failed', NULL, NULL, NULL, '2026-08-09 15:15:39', '2026-08-09 15:15:40'),
(63, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '4', 'PAY-1786277764161-213', 249.00, 'KES', 100, 'failed', NULL, NULL, NULL, '2026-08-09 15:16:04', '2026-08-09 15:16:05'),
(64, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '6', 'PAY-1786277901678-348', 1899.00, 'KES', 1000, 'failed', NULL, NULL, NULL, '2026-08-09 15:18:21', '2026-08-09 15:18:22'),
(70, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1792991376489-236', 19.00, 'KES', 6, 'successful', NULL, NULL, NULL, '2026-10-26 08:09:36', '2026-10-26 08:10:49'),
(71, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2', 'PAY-1792991479981-441', 59.00, 'KES', 20, 'failed', NULL, NULL, NULL, '2026-10-26 08:11:19', '2026-10-26 08:11:20'),
(79, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1794231832495-296', 19.00, 'KES', 6, 'failed', NULL, NULL, NULL, '2026-11-09 13:43:52', '2026-11-09 13:43:53'),
(80, '4a881750-11b9-44fd-b473-99548b3af7a7', '1', 'PAY-1794232064467-819', 3.00, 'USD', 300, 'failed', NULL, NULL, NULL, '2026-11-09 13:47:44', '2026-11-09 13:47:45');

-- --------------------------------------------------------

--
-- Table structure for table `payment_plans`
--

CREATE TABLE `payment_plans` (
  `id` int NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tokens` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `bonus_tokens` int DEFAULT '0',
  `is_popular` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment_plans`
--

INSERT INTO `payment_plans` (`id`, `name`, `tokens`, `price`, `bonus_tokens`, `is_popular`, `created_at`) VALUES
(1, 'Lite Launch', 6, 19.00, 0, 0, '2025-05-23 15:40:58'),
(2, 'Freelancer Start', 20, 59.00, 2, 0, '2025-05-23 15:40:58'),
(3, 'Smart Hustler', 45, 119.00, 3, 0, '2025-05-23 15:40:58'),
(4, 'Solo Pro', 100, 249.00, 5, 0, '2025-05-23 15:40:58'),
(5, 'Business Builder', 300, 599.00, 10, 1, '2025-05-23 15:40:58'),
(6, 'Enterprise Elite', 1000, 1899.00, 25, 0, '2025-05-23 15:40:58');

-- --------------------------------------------------------

--
-- Table structure for table `payment_plans_usd`
--

CREATE TABLE `payment_plans_usd` (
  `id` int NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tokens` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `bonus_tokens` int DEFAULT '0',
  `is_popular` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment_plans_usd`
--

INSERT INTO `payment_plans_usd` (`id`, `name`, `tokens`, `price`, `bonus_tokens`, `is_popular`, `created_at`) VALUES
(1, 'Starter', 300, 3.00, 0, 0, '2026-10-29 15:23:46'),
(2, 'Pro', 1200, 10.00, 100, 1, '2026-10-29 15:23:46'),
(3, 'Enterprise', 3000, 20.00, 300, 0, '2026-10-29 15:23:46');

-- --------------------------------------------------------

--
-- Table structure for table `pending_registrations`
--

CREATE TABLE `pending_registrations` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type` enum('email','google') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email_address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `business_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `google_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `verification_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `verification_expiry` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quotations`
--

CREATE TABLE `quotations` (
  `id` int NOT NULL,
  `quotation_number` varchar(50) NOT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `date_issued` date NOT NULL,
  `valid_until` date DEFAULT NULL,
  `status` enum('draft','sent','accepted','expired','converted') NOT NULL DEFAULT 'draft',
  `client_name` varchar(255) NOT NULL,
  `client_email` varchar(255) DEFAULT NULL,
  `client_phone` varchar(20) DEFAULT NULL,
  `client_address` text,
  `client_county` varchar(100) DEFAULT NULL,
  `business_name` varchar(255) NOT NULL,
  `business_email` varchar(255) DEFAULT NULL,
  `business_phone` varchar(20) DEFAULT NULL,
  `business_address` text,
  `business_kra_pin` varchar(50) DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL DEFAULT '0.00',
  `discount_type` enum('percentage','amount') DEFAULT NULL,
  `discount_value` decimal(10,2) NOT NULL DEFAULT '0.00',
  `discount_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tax_rate` decimal(5,2) NOT NULL DEFAULT '16.00',
  `tax_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `payment_terms` varchar(255) DEFAULT NULL,
  `delivery_terms` varchar(255) DEFAULT NULL,
  `validity_period` varchar(50) DEFAULT '30 days',
  `notes` text,
  `terms_conditions` text,
  `converted_to_invoice` tinyint(1) DEFAULT '0',
  `converted_invoice_id` int DEFAULT NULL,
  `converted_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `currency_code` varchar(10) DEFAULT 'KES',
  `currency_symbol` varchar(10) DEFAULT 'KSh',
  `currency_name` varchar(50) DEFAULT 'Kenyan Shilling'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quotation_items`
--

CREATE TABLE `quotation_items` (
  `id` int NOT NULL,
  `quotation_id` int NOT NULL,
  `item_code` varchar(50) DEFAULT NULL,
  `description` text NOT NULL,
  `quantity` decimal(10,2) NOT NULL DEFAULT '1.00',
  `unit` varchar(20) DEFAULT 'pcs',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `receipts`
--

CREATE TABLE `receipts` (
  `id` int NOT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `receipt_number` varchar(255) NOT NULL,
  `date` datetime NOT NULL,
  `business_name` varchar(255) NOT NULL,
  `business_address` text,
  `business_phone` varchar(255) DEFAULT NULL,
  `business_email` varchar(255) DEFAULT NULL,
  `business_website` varchar(255) DEFAULT NULL,
  `customer_name` varchar(255) NOT NULL,
  `customer_email` varchar(255) DEFAULT NULL,
  `customer_phone` varchar(255) DEFAULT NULL,
  `customer_address` text,
  `payment_method` varchar(255) NOT NULL,
  `payment_reference` varchar(255) DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tax_rate` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tax_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `notes` text,
  `currency_code` varchar(10) DEFAULT 'KES',
  `currency_symbol` varchar(10) DEFAULT 'KSh',
  `currency_name` varchar(50) DEFAULT 'Kenyan Shilling'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `receipts`
--

INSERT INTO `receipts` (`id`, `user_id`, `receipt_number`, `date`, `business_name`, `business_address`, `business_phone`, `business_email`, `business_website`, `customer_name`, `customer_email`, `customer_phone`, `customer_address`, `payment_method`, `payment_reference`, `subtotal`, `tax_rate`, `tax_amount`, `total_amount`, `notes`, `currency_code`, `currency_symbol`, `currency_name`) VALUES
(16, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-708-757908', '2025-09-01 00:00:00', 'Ujuzi Digital Creations', '', '+254741238738', 'hello@ujuzicreations.co.ke', NULL, 'Tabby', '', '0715320277', '', 'mpesa', NULL, 0.00, 0.00, 0.00, 5000.00, 'Thank you for your purchase at Ujuzi Digital Creations! We\'ll commence development today. Amount remaining will be ksh 5000 (To be settled after work is complete and you\'ve confirmed everything is working.', 'KES', 'KSh', 'Kenyan Shilling'),
(17, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-614-960743', '2025-09-05 00:00:00', 'Ujuzi Digital Creations', '', '+254741238738', 'hello@ujuzicreations.co.ke', NULL, 'Tabyy Elite', '', '0715320277', '', 'mpesa', NULL, 0.00, 0.00, 0.00, 5500.00, 'Thank you for your purchase at Ujuzi Digital Creations! The amount has been settled in full.. It\'s been a pleasure working with you. If you need any assistance feel free to reach out.', 'KES', 'KSh', 'Kenyan Shilling'),
(19, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-680-802431', '2025-10-01 00:00:00', 'Ujuzi Digital Creations', '', '+254741238738', 'hello@ujuzicreations.co.ke', NULL, 'Quickpulse Safaris & Travel', '', '0725880964', 'Spring Court, Watermark Business Park', 'mpesa', NULL, 0.00, 0.00, 0.00, 5000.00, 'Thank you for your purchase at Ujuzi Digital Creations! We\'ll commence development today. Amount remaining will be ksh 5000 (To be settled after work is complete and you\'ve confirmed everything is working.', 'KES', 'KSh', 'Kenyan Shilling'),
(20, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-680-542818', '2025-10-02 00:00:00', 'Ujuzi Digital Creations', '', '+254741238738', 'hello@ujuzicreations.co.ke', NULL, 'Chris', '', '0712012557', '', 'mpesa', NULL, 0.00, 0.00, 0.00, 6750.00, 'Thank you for your purchase at Ujuzi Digital Creations! We\'ll commence development today. Amount remaining will be ksh 6750 (To be settled after work is complete and you\'ve reviewed the website.', 'KES', 'KSh', 'Kenyan Shilling'),
(21, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-789-351285', '2025-10-13 00:00:00', 'Ujuzi Digital Creations', '', '+254741238738', 'hello@ujuzicreations.co.ke', NULL, 'Chris', '', '0712012557', '', 'mpesa', NULL, 0.00, 0.00, 0.00, 3600.00, 'Thank you for your purchase at Ujuzi Digital Creations! Remaining balance will be Ksh 3150.', 'KES', 'KSh', 'Kenyan Shilling');

-- --------------------------------------------------------

--
-- Table structure for table `receipt_items`
--

CREATE TABLE `receipt_items` (
  `id` int NOT NULL,
  `receipt_id` int NOT NULL,
  `description` text NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `receipt_items`
--

INSERT INTO `receipt_items` (`id`, `receipt_id`, `description`, `quantity`, `price`, `total`) VALUES
(69, 16, 'Web Development Initial Deposit', 1, 5000.00, 5000.00),
(70, 17, 'Web development & Social Media Integration', 1, 5500.00, 5500.00),
(72, 19, 'Website Development', 1, 5000.00, 5000.00),
(73, 20, 'Website development', 1, 6750.00, 6750.00),
(74, 21, 'Debtime Limited Web Development Service', 1, 3600.00, 3600.00);

-- --------------------------------------------------------

--
-- Table structure for table `users_information`
--

CREATE TABLE `users_information` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `business_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `business_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `website` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `accent_color` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '#0d9488',
  `currency_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'KES',
  `currency_symbol` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'KSh',
  `currency_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Kenyan Shilling',
  `phone_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email_address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `google_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email_verified` tinyint(1) NOT NULL DEFAULT '0',
  `verification_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `verification_expiry` datetime DEFAULT NULL,
  `trials` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reset_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `reset_token_expiry` bigint DEFAULT NULL,
  `signature` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `onboarding_completed` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_information`
--

INSERT INTO `users_information` (`id`, `name`, `business_name`, `business_address`, `website`, `logo`, `accent_color`, `currency_code`, `currency_symbol`, `currency_name`, `phone_number`, `country`, `email_address`, `password`, `google_id`, `email_verified`, `verification_token`, `verification_expiry`, `trials`, `created_at`, `reset_token`, `reset_token_expiry`, `signature`, `onboarding_completed`) VALUES
('15ec951a-b518-4d68-b4ed-2cf1a8264985', 'Home Repair', 'Home Repair Service Limited', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', NULL, 'Kenya', 'homerepserv@gmail.com', '$2b$10$N66kB5HLZLLsfzEOZmFOH.ByNhpf4RkPgRQoW4hLfJ8ouiKO5k6ye', NULL, 1, NULL, NULL, 5, '2026-10-06 04:46:12', NULL, NULL, NULL, 1),
('25738224-2926-48a6-8774-c37830ea0681', 'Martin Muchomba Mutuura', 'Greenbridge', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254729690152', 'Kenya', 'info.greenbridgeltd@gmail.com', '$2b$10$nPsbZ8P.K2JJycHq6BcMcuiTNh43jyv.swXvOdV1lYi/F191Tf4.2', NULL, 1, NULL, NULL, 5, '2025-09-05 10:16:21', NULL, NULL, NULL, 0),
('2bbcec63-d272-4100-a1cd-93087dbc8a02', 'Ajeroh Kareithi', 'Garissa tana', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254721260012', 'Kenya', 'ajerohkareithia@gmail.com', '$2b$10$pu/Kpfe1qefWZf/wee7zJOFtvyjBSrxlli2OzY7v9GAOVkfLLZ.Me', NULL, 1, NULL, NULL, 5, '2026-08-17 17:51:24', NULL, NULL, NULL, 1),
('44643d1f-456e-44ca-bb0d-530b7c94dfce', 'Cardimore Avwonda', 'Ashley Collymore Stores', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254791929454', 'Kenya', 'ashleycollymoreke@gmail.com', '$2b$10$Fqu5TwsQFuGVBfkIe/ffk.pgRjxVGAQJgtHycWnARR.fjnif1oq5a', NULL, 1, NULL, NULL, 5, '2025-10-29 18:20:06', NULL, NULL, NULL, 0),
('4a881750-11b9-44fd-b473-99548b3af7a7', 'Ujuzi Creations', 'My biz biz', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254112770494', 'Kenya', 'ujuzicreations@gmail.com', '$2b$10$wWw16q9VdzPA5B0XxZWgCuoNporF8WsZHfTPSLSPHhg7kGMF7.R9a', NULL, 1, NULL, NULL, 4, '2026-09-12 10:31:50', NULL, NULL, NULL, 1),
('4e44f2fc-a2c9-4bae-b645-d850fcbc7bf7', 'Prime Laundry', 'Prime Laundry', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254713203071', 'Kenya', 'primelaundrys8@gmail.com', '$2b$10$Uj5fyt.E579/bjVL.4XhGuyWu.NPTLMl65aLxQQ9l3ZLD01WZrXBW', NULL, 1, NULL, NULL, 5, '2026-10-07 04:22:19', NULL, NULL, NULL, 1),
('7a2d4858-c162-456c-afc1-e8d301c61cf7', 'George K Nganga', 'Kimtakim construction ', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254726256141', 'Kenya', 'kngangageorge@gmail.com', '$2b$10$/a5xhnfB07/Xp/HShJIOfeActYNAc5UMCef3nWlcFeVlRcTgqv.Ra', NULL, 1, NULL, NULL, 5, '2026-08-18 03:39:30', NULL, NULL, NULL, 1),
('824c1278-ce71-4126-bc1a-abddbbc3a83a', 'Michael Chege', 'Ujuzi Digital Creations', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254741239839', 'Kenya', 'contact.mikechege@gmail.com', '$2b$10$CsVNBBWDhQ2ZafMyguLxq.zh/Fh/790bKzJbPFE10vSK8we/cdReO', '107857322809933249628', 1, NULL, NULL, 5, '2026-11-10 18:36:05', NULL, NULL, NULL, 1),
('9c4f0ae0-6a2b-4d85-8d1a-d032faecb441', 'Okoth BRIAN', 'Meridian Brook Schools ', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254745809497', 'Kenya', 'omondibrianomondi2018@gmail.com', '$2b$10$w2yAuCLWoYpVXcc75PgIFeix5sca7VrCz.c2HnixXukfojNDOs4ba', NULL, 1, NULL, NULL, 5, '2026-08-17 21:02:52', NULL, NULL, NULL, 1),
('b1712872-0122-4cbd-b697-122e0dc370a1', 'Immanuel Kyeni', 'Nuelite', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254790072466', 'Kenya', 'kyeniimmanuel@gmail.com', '$2b$10$vjFney4KfP2q0U9Deil34uTNcjI0H3nXOeaFckvTtoUzAhgstGlQ.', NULL, 1, NULL, NULL, 5, '2026-08-11 09:21:25', NULL, NULL, NULL, 1),
('b6721071-c843-4a44-ba69-96f6d2bfac1c', 'Fred Chege', 'Fc tech', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254704692424', 'Kenya', 'fredchege199@gmail.com', '$2b$10$8vVmeaYZIeJJ0FRXLLzX1ezq9UEpSq2eMC5b30S9aX.qOjrr5Frrm', NULL, 1, NULL, NULL, 27, '2025-06-21 01:35:02', NULL, NULL, NULL, 0),
('e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'C.E.O George', 'Ujuzi Digital Creations', NULL, NULL, '/uploads/logos/user-e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6-1786127822335-756546924.jpg', '#0d9488', 'USD', '$', 'US Dollar', '+254741238738', 'uganda', 'hello@ujuzicreations.co.ke', '$2b$10$wWw16q9VdzPA5B0XxZWgCuoNporF8WsZHfTPSLSPHhg7kGMF7.R9a', NULL, 1, NULL, NULL, 260, '2025-06-20 01:31:23', NULL, NULL, NULL, 1),
('e79e5915-b271-4a91-97ad-50ca1419419f', 'wycliffe kendo', 'kendox construction ltd', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254707578773', 'Kenya', 'wycliffekendo@gmail.com', '$2b$10$EfJMm6OIf8p3JsrJwo1XIOMXccUaFg1Uw3nIEZOdZSVKdT3/CJIHm', NULL, 1, NULL, NULL, 24, '2025-10-14 12:03:32', NULL, NULL, NULL, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_users`
--
ALTER TABLE `admin_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `contracts`
--
ALTER TABLE `contracts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `contract_number` (`contract_number`),
  ADD KEY `fk_contracts_user_id` (`user_id`),
  ADD KEY `idx_contract_type` (`contract_type`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_customers_user_id` (`user_id`),
  ADD KEY `idx_customer_name` (`name`),
  ADD KEY `idx_customer_email` (`email`),
  ADD KEY `idx_customer_phone` (`phone`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_id` (`user_id`),
  ADD KEY `fk_invoice_quotation` (`quotation_id`);

--
-- Indexes for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_invoice_items_invoice_id` (`invoice_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_payments_user_id` (`user_id`);

--
-- Indexes for table `payment_plans`
--
ALTER TABLE `payment_plans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payment_plans_usd`
--
ALTER TABLE `payment_plans_usd`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pending_registrations`
--
ALTER TABLE `pending_registrations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_email` (`email_address`),
  ADD KEY `idx_token` (`verification_token`);

--
-- Indexes for table `quotations`
--
ALTER TABLE `quotations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_quotation_user` (`user_id`);

--
-- Indexes for table `quotation_items`
--
ALTER TABLE `quotation_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_quotation_items_quotation` (`quotation_id`);

--
-- Indexes for table `receipts`
--
ALTER TABLE `receipts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_receipts_user_id` (`user_id`);

--
-- Indexes for table `receipt_items`
--
ALTER TABLE `receipt_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_receipt_items_receipt_id` (`receipt_id`);

--
-- Indexes for table `users_information`
--
ALTER TABLE `users_information`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email_address` (`email_address`),
  ADD UNIQUE KEY `uniq_google_id` (`google_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `contracts`
--
ALTER TABLE `contracts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT for table `invoice_items`
--
ALTER TABLE `invoice_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=208;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT for table `payment_plans`
--
ALTER TABLE `payment_plans`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `payment_plans_usd`
--
ALTER TABLE `payment_plans_usd`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `quotations`
--
ALTER TABLE `quotations`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `quotation_items`
--
ALTER TABLE `quotation_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `receipts`
--
ALTER TABLE `receipts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `receipt_items`
--
ALTER TABLE `receipt_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=132;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `contracts`
--
ALTER TABLE `contracts`
  ADD CONSTRAINT `fk_contracts_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_information` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `customers`
--
ALTER TABLE `customers`
  ADD CONSTRAINT `fk_customers_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_information` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `fk_invoice_quotation` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_information` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD CONSTRAINT `fk_invoice_items_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payments_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_information` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `quotations`
--
ALTER TABLE `quotations`
  ADD CONSTRAINT `fk_quotation_user` FOREIGN KEY (`user_id`) REFERENCES `users_information` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `quotation_items`
--
ALTER TABLE `quotation_items`
  ADD CONSTRAINT `fk_quotation_items_quotation` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `receipts`
--
ALTER TABLE `receipts`
  ADD CONSTRAINT `fk_receipts_user_id` FOREIGN KEY (`user_id`) REFERENCES `users_information` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `receipt_items`
--
ALTER TABLE `receipt_items`
  ADD CONSTRAINT `fk_receipt_items_receipt_id` FOREIGN KEY (`receipt_id`) REFERENCES `receipts` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
