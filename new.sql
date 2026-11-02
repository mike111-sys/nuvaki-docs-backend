-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 25, 2026 at 10:56 AM
-- Server version: 8.0.39
-- PHP Version: 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `biz-kit-kenya`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
CREATE TABLE IF NOT EXISTS `admin_users` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('super_admin','admin','viewer') NOT NULL DEFAULT 'admin',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `name`, `email`, `password`, `role`, `is_active`, `last_login`, `created_at`, `updated_at`) VALUES
('f66995d1-006f-4c0f-8e7d-5b74a0bc9cb3', 'Super Admin', 'admin@bizkitkenya.co.ke', '$2a$12$/ZIomRIOJG1qOy2b4kdqzuHoCVapVNH1IJzof0ytLoyucgpUG3L1u', 'super_admin', 1, '2026-09-11 06:55:17', '2026-09-10 08:41:09', '2026-09-11 03:55:17');

-- --------------------------------------------------------

--
-- Table structure for table `contracts`
--

DROP TABLE IF EXISTS `contracts`;
CREATE TABLE IF NOT EXISTS `contracts` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `currency_name` varchar(50) DEFAULT 'Kenyan Shilling',
  PRIMARY KEY (`id`),
  UNIQUE KEY `contract_number` (`contract_number`),
  KEY `fk_contracts_user_id` (`user_id`),
  KEY `idx_contract_type` (`contract_type`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `contracts`
--

INSERT INTO `contracts` (`id`, `user_id`, `contract_number`, `contract_type`, `title`, `date_issued`, `effective_date`, `expiry_date`, `party_a_name`, `party_a_business`, `party_a_email`, `party_a_phone`, `party_a_address`, `party_a_id_number`, `party_a_kra_pin`, `party_b_name`, `party_b_business`, `party_b_email`, `party_b_phone`, `party_b_address`, `party_b_id_number`, `party_b_kra_pin`, `project_description`, `scope_of_work`, `deliverables`, `contract_value`, `payment_terms`, `payment_schedule`, `deposit_amount`, `milestones`, `service_details`, `product_details`, `partnership_details`, `terms_conditions`, `termination_clause`, `confidentiality_clause`, `dispute_resolution`, `governing_law`, `party_a_signature`, `party_a_signature_date`, `party_b_signature`, `party_b_signature_date`, `witness_name`, `witness_signature`, `witness_date`, `status`, `notes`, `created_at`, `updated_at`, `currency_code`, `currency_symbol`, `currency_name`) VALUES
(7, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'SAL-159-325130', 'sales_agreement', 'ascc', '2026-06-14 22:45:36', '2026-06-13', NULL, 'C.E.O George', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '', '', 'Michael Chege', '', 'contact.mikechege@gmail.com', '0741238738', 'Nairobi, Kenya', '', '', '', '', '', 0.00, '', '', 0.00, '[]', NULL, '{\"items\": [], \"delivery_date\": \"\", \"warranty_period\": \"\", \"delivery_address\": \"\", \"inspection_period\": \"\"}', NULL, '1. GOVERNING LAW: This Agreement shall be governed by and construed in accordance with the laws of the Republic of Kenya.\n  \n2. DISPUTE RESOLUTION: Any dispute arising out of or in connection with this Agreement shall first be resolved through amicable negotiations. If negotiations fail, the dispute shall be referred to arbitration in accordance with the Arbitration Act, 1995 of Kenya.\n\n3. FORCE MAJEURE: Neither party shall be liable for any failure or delay in performance under this Agreement due to causes beyond its reasonable control.\n\n4. ENTIRE AGREEMENT: This Agreement constitutes the entire agreement between the parties and supersedes all prior agreements and understandings.\n\n5. SEVERABILITY: If any provision of this Agreement is held to be invalid or unenforceable, the remaining provisions shall remain in full force and effect.', 'Either party may terminate this Agreement by giving 30 days written notice to the other party. Upon termination, all outstanding payments shall become immediately due and payable.', 1, 'Any dispute arising from this Agreement shall first be resolved through negotiation. If negotiation fails, the dispute shall be referred to arbitration in Nairobi, Kenya.', 'Kenya', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'draft', '', '2026-06-14 19:45:36', '2026-06-14 19:49:04', 'KES', 'KSh', 'Kenyan Shilling'),
(8, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'SRV-552-555210', 'service_agreement', 'service agreement', '2026-06-16 10:27:37', '2026-06-16', NULL, 'C.E.O George', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '', '', 'Mary Njoki', '', 'marynjoki899@gmail.com', '0712838943', 'Kisumu, Kenya ', '', '', '', '', '', 0.00, '', '', 0.00, '[]', '{\"duration\": \"\", \"service_type\": \"\", \"support_period\": \"\", \"support_included\": false, \"materials_provided\": \"\"}', NULL, NULL, '1. GOVERNING LAW: This Agreement shall be governed by and construed in accordance with the laws of the Republic of Kenya.\n  \n2. DISPUTE RESOLUTION: Any dispute arising out of or in connection with this Agreement shall first be resolved through amicable negotiations. If negotiations fail, the dispute shall be referred to arbitration in accordance with the Arbitration Act, 1995 of Kenya.\n\n3. FORCE MAJEURE: Neither party shall be liable for any failure or delay in performance under this Agreement due to causes beyond its reasonable control.\n\n4. ENTIRE AGREEMENT: This Agreement constitutes the entire agreement between the parties and supersedes all prior agreements and understandings.\n\n5. SEVERABILITY: If any provision of this Agreement is held to be invalid or unenforceable, the remaining provisions shall remain in full force and effect.', 'Either party may terminate this Agreement by giving 30 days written notice to the other party. Upon termination, all outstanding payments shall become immediately due and payable.', 1, 'Any dispute arising from this Agreement shall first be resolved through negotiation. If negotiation fails, the dispute shall be referred to arbitration in Nairobi, Kenya.', 'Kenya', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'draft', '', '2026-06-16 07:27:36', '2026-06-16 07:27:36', 'KES', 'KSh', 'Kenyan Shilling'),
(9, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'FRE-811-555872', 'freelance_contract', 'freelance contract', '2026-06-16 23:35:25', '2026-06-15', NULL, 'C.E.O George', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '', '', 'Michael Chege', '', 'contact.mikechege@gmail.com', '0741238738', 'Narok, City', '', '', '', '', '', 1200.00, '', '', 20.00, '[]', NULL, NULL, NULL, '1. GOVERNING LAW: This Agreement shall be governed by and construed in accordance with the laws of the Republic of Kenya.\n  \n2. DISPUTE RESOLUTION: Any dispute arising out of or in connection with this Agreement shall first be resolved through amicable negotiations. If negotiations fail, the dispute shall be referred to arbitration in accordance with the Arbitration Act, 1995 of Kenya.\n\n3. FORCE MAJEURE: Neither party shall be liable for any failure or delay in performance under this Agreement due to causes beyond its reasonable control.\n\n4. ENTIRE AGREEMENT: This Agreement constitutes the entire agreement between the parties and supersedes all prior agreements and understandings.\n\n5. SEVERABILITY: If any provision of this Agreement is held to be invalid or unenforceable, the remaining provisions shall remain in full force and effect.', 'Either party may terminate this Agreement by giving 30 days written notice to the other party. Upon termination, all outstanding payments shall become immediately due and payable.', 1, 'Any dispute arising from this Agreement shall first be resolved through negotiation. If negotiation fails, the dispute shall be referred to arbitration in Nairobi, Kenya.', 'Kenya', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'draft', '', '2026-06-16 20:35:24', '2026-06-16 20:36:53', 'EUR', '€', 'Euro'),
(10, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'PRT-971-013999', 'partnership_agreement', 'freelance contract', '2026-07-29 19:20:35', '2026-06-14', NULL, 'C.E.O George', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '', '', 'Micha', '', '', '', '', '', '', '', '', '', 1200.00, '', '', 20.00, '[]', NULL, NULL, '{\"partnership_type\": \"profit_sharing\", \"withdrawal_terms\": \"\", \"contribution_party_a\": \"\", \"contribution_party_b\": \"\", \"management_structure\": \"\", \"profit_sharing_ratio_a\": 50, \"profit_sharing_ratio_b\": 50}', '1. GOVERNING LAW: This Agreement shall be governed by and construed in accordance with the laws of the Republic of Kenya.\n  \n2. DISPUTE RESOLUTION: Any dispute arising out of or in connection with this Agreement shall first be resolved through amicable negotiations. If negotiations fail, the dispute shall be referred to arbitration in accordance with the Arbitration Act, 1995 of Kenya.\n\n3. FORCE MAJEURE: Neither party shall be liable for any failure or delay in performance under this Agreement due to causes beyond its reasonable control.\n\n4. ENTIRE AGREEMENT: This Agreement constitutes the entire agreement between the parties and supersedes all prior agreements and understandings.\n\n5. SEVERABILITY: If any provision of this Agreement is held to be invalid or unenforceable, the remaining provisions shall remain in full force and effect.', 'Either party may terminate this Agreement by giving 30 days written notice to the other party. Upon termination, all outstanding payments shall become immediately due and payable.', 1, 'Any dispute arising from this Agreement shall first be resolved through negotiation. If negotiation fails, the dispute shall be referred to arbitration in Nairobi, Kenya.', 'Kenya', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'draft', '', '2026-07-29 16:20:34', '2026-07-29 16:20:34', 'EUR', '€', 'Euro'),
(11, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'SRV-323-735057', 'service_agreement', 'service agreement', '2026-07-30 21:56:14', '2026-07-29', NULL, 'C.E.O George', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '', '', 'Micha', '', '', '', '', '', '', '', '', '', 0.00, '', '', 0.00, '[]', '{\"duration\": \"\", \"service_type\": \"\", \"support_period\": \"\", \"support_included\": false, \"materials_provided\": \"\"}', NULL, NULL, '1. GOVERNING LAW: This Agreement shall be governed by and construed in accordance with the laws of the Republic of Kenya.\n  \n2. DISPUTE RESOLUTION: Any dispute arising out of or in connection with this Agreement shall first be resolved through amicable negotiations. If negotiations fail, the dispute shall be referred to arbitration in accordance with the Arbitration Act, 1995 of Kenya.\n\n3. FORCE MAJEURE: Neither party shall be liable for any failure or delay in performance under this Agreement due to causes beyond its reasonable control.\n\n4. ENTIRE AGREEMENT: This Agreement constitutes the entire agreement between the parties and supersedes all prior agreements and understandings.\n\n5. SEVERABILITY: If any provision of this Agreement is held to be invalid or unenforceable, the remaining provisions shall remain in full force and effect.', 'Either party may terminate this Agreement by giving 30 days written notice to the other party. Upon termination, all outstanding payments shall become immediately due and payable.', 1, 'Any dispute arising from this Agreement shall first be resolved through negotiation. If negotiation fails, the dispute shall be referred to arbitration in Nairobi, Kenya.', 'Kenya', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'draft', '', '2026-07-30 18:56:13', '2026-07-30 18:56:13', 'EUR', '€', 'Euro'),
(12, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'gghghgh', 'service_agreement', 'Laptop repair', '2026-07-31 12:11:04', '2026-08-01', '2026-08-07', 'Michael Chege', 'My business', 'mike@yahoo', '0712838943', 'Nairobi, nairoba', '11588888', 'HJSBNCSJCJS', 'Lynn Wamboi', 'Lynn Entreprises', 'lynn@gmail.com', '0112770394', 'Narok City', '23131', '87788', 'The repairer', 'High Dff', 'Phone screen', 12000.00, '10% Depo', 'Will be paid enough', 1000.00, '[]', '{\"duration\": \"\", \"service_type\": \"\", \"support_period\": \"\", \"support_included\": false, \"materials_provided\": \"\"}', NULL, NULL, '1. GOVERNsING LAW: This Agreement shall be governed by and construed in accordance with the laws of the Republic of Kenya.\n  \n2. DISPUTEs RESOLUTION: Any dispute arising out of or in connection with this Agreement shall first be resolved through amicable negotiations. If negotiations fail, the dispute shall be referred to arbitration in accordance with the Arbitration Act, 1995 of Kenya.\n\n3. FORCE MAJEURsE: Neither party shall be liable for any failure or delay in performance under this Agreement due to causes beyond its reasonable control.', 'hththt', 1, 'mercy', 'Kenyay', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'draft', 'maru', '2026-07-31 09:11:04', '2026-07-31 09:11:04', 'GBP', '£', 'British Pound'),
(13, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'PRT-380-389924', 'partnership_agreement', 'Laptop repair', '2026-08-01 18:50:50', '2026-07-31', '2026-08-06', 'C.E.O George', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '11588888', 'HJSBNCSJCJS', 'Lynn Wamboi', 'Lynn Entreprises', 'lynn@gmail.com', '0112770394', 'Narok City', '23131', '87788', 'The repairer', 'High Dff', 'Phone screen', 12000.00, '10% Depo', 'Will be paid enough', 1000.00, '[]', NULL, NULL, '{\"partnership_type\": \"profit_sharing\", \"withdrawal_terms\": \"\", \"contribution_party_a\": \"\", \"contribution_party_b\": \"\", \"management_structure\": \"\", \"profit_sharing_ratio_a\": 50, \"profit_sharing_ratio_b\": 50}', '1. GOVERNsING LAW: This Agreement shall be governed by and construed in accordance with the laws of the Republic of Kenya.\n  \n2. DISPUTEs RESOLUTION: Any dispute arising out of or in connection with this Agreement shall first be resolved through amicable negotiations. If negotiations fail, the dispute shall be referred to arbitration in accordance with the Arbitration Act, 1995 of Kenya.\n\n3. FORCE MAJEURsE: Neither party shall be liable for any failure or delay in performance under this Agreement due to causes beyond its reasonable control.', 'hththt', 1, 'mercy', 'Kenyay', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'draft', 'maru', '2026-08-01 15:50:49', '2026-08-01 15:50:49', 'EUR', '€', 'Euro'),
(14, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'SRV-838-251425', 'service_agreement', 'Laptop repair', '2026-08-01 19:21:41', '2026-07-30', '2026-08-05', 'C.E.O George', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '11588888', 'HJSBNCSJCJS', 'Lynn Wamboi', 'Lynn Entreprises', 'lynn@gmail.com', '0112770394', 'Narok City', '23131', '87788', 'The repairer', 'High Dff', 'Phone screen', 12000.00, '10% Depo', 'Will be paid enough', 1000.00, '[]', '{\"duration\": \"\", \"service_type\": \"\", \"support_period\": \"\", \"support_included\": false, \"materials_provided\": \"\"}', NULL, NULL, '1. GOVERNsING LAW: This Agreement shall be governed by and construed in accordance with the laws of the Republic of Kenya.\n  \n2. DISPUTEs RESOLUTION: Any dispute arising out of or in connection with this Agreement shall first be resolved through amicable negotiations. If negotiations fail, the dispute shall be referred to arbitration in accordance with the Arbitration Act, 1995 of Kenya.\n\n3. FORCE MAJEURsE: Neither party shall be liable for any failure or delay in performance under this Agreement due to causes beyond its reasonable control.', 'hththt', 1, 'mercy', 'Kenyay', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'draft', 'maru', '2026-08-01 16:21:41', '2026-08-01 16:21:41', 'EUR', '€', 'Euro'),
(15, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'SAL-797-471865', 'sales_agreement', 'Laptop repair', '2026-08-06 11:04:35', '2026-07-31', '2026-08-06', 'C.E.O George', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '11588888', 'HJSBNCSJCJS', 'Lynn Wamboi', 'Lynn Entreprises', 'lynn@gmail.com', '0112770394', 'Narok City', '23131', '87788', 'The repairer', 'High Dff', 'Phone screen', 12000.00, '10% Depo', 'Will be paid enough', 1000.00, '[]', NULL, '{\"items\": [], \"delivery_date\": \"\", \"warranty_period\": \"\", \"delivery_address\": \"\", \"inspection_period\": \"\"}', NULL, '1. GOVERNsING LAW: This Agreement shall be governed by and construed in accordance with the laws of the Republic of Kenya.\n  \n2. DISPUTEs RESOLUTION: Any dispute arising out of or in connection with this Agreement shall first be resolved through amicable negotiations. If negotiations fail, the dispute shall be referred to arbitration in accordance with the Arbitration Act, 1995 of Kenya.\n\n3. FORCE MAJEURsE: Neither party shall be liable for any failure or delay in performance under this Agreement due to causes beyond its reasonable control.', 'hththt', 1, 'mercy', 'Kenyay', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'draft', 'maru', '2026-08-06 08:04:35', '2026-08-06 08:04:35', 'EUR', '€', 'Euro'),
(16, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'FRE-911-584771', 'freelance_contract', 'gvh', '2026-08-06 11:08:28', '2026-08-06', NULL, 'C.E.O George', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '', '', 'jhbbn', '', '', '', '', '', '', '', '', '', 0.00, '', '', 0.00, '[]', NULL, NULL, NULL, '1. GOVERNING LAW: This Agreement shall be governed by and construed in accordance with the laws of the Republic of Kenya.\n  \n2. DISPUTE RESOLUTION: Any dispute arising out of or in connection with this Agreement shall first be resolved through amicable negotiations. If negotiations fail, the dispute shall be referred to arbitration in accordance with the Arbitration Act, 1995 of Kenya.\n\n3. FORCE MAJEURE: Neither party shall be liable for any failure or delay in performance under this Agreement due to causes beyond its reasonable control.\n\n4. ENTIRE AGREEMENT: This Agreement constitutes the entire agreement between the parties and supersedes all prior agreements and understandings.\n\n5. SEVERABILITY: If any provision of this Agreement is held to be invalid or unenforceable, the remaining provisions shall remain in full force and effect.', 'Either party may terminate this Agreement by giving 30 days written notice to the other party. Upon termination, all outstanding payments shall become immediately due and payable.', 1, 'Any dispute arising from this Agreement shall first be resolved through negotiation. If negotiation fails, the dispute shall be referred to arbitration in Nairobi, Kenya.', 'Kenya', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'draft', '', '2026-08-06 08:08:27', '2026-08-06 08:08:27', 'EUR', '€', 'Euro');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
CREATE TABLE IF NOT EXISTS `customers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_customers_user_id` (`user_id`),
  KEY `idx_customer_name` (`name`),
  KEY `idx_customer_email` (`email`),
  KEY `idx_customer_phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `user_id`, `name`, `email`, `phone`, `address`, `created_at`, `updated_at`) VALUES
(2, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'Michael Chege', 'contact.mikechege@gmail.com', '0741238738', 'Nairobi, Kenya', '2026-02-22 09:27:16', '2026-02-22 09:27:16'),
(3, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'Michael Chege', 'contact.mikechege@gmail.com', '0741238738', 'Nar', '2026-02-22 09:34:36', '2026-02-22 09:34:36'),
(4, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'Michael Chege', 'contact.mikechege@gmail.com', '0741238738', 'Narok, City', '2026-02-22 09:39:47', '2026-02-22 09:39:47'),
(8, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'Mary Njoki', 'marynjoki899@gmail.com', '0712838943', 'Kisumu, Kenya ', '2026-02-22 20:58:02', '2026-02-22 20:58:02'),
(10, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'Micha', NULL, NULL, NULL, '2026-06-13 21:26:09', '2026-06-13 21:26:09'),
(11, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'Francis M', 'frankchege56@gmail.com', '0740930900', 'Narok, City', '2026-07-17 20:43:25', '2026-07-17 20:43:25');

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
CREATE TABLE IF NOT EXISTS `invoices` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`),
  KEY `fk_user_id` (`user_id`),
  KEY `fk_invoice_quotation` (`quotation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `invoices`
--

INSERT INTO `invoices` (`id`, `user_id`, `invoice_number`, `date`, `due_date`, `client_name`, `client_email`, `client_address`, `business_name`, `business_address`, `business_phone`, `business_email`, `business_website`, `tax_rate`, `discount_type`, `discount_value`, `discount_amount`, `tax_amount`, `total_amount`, `notes`, `status`, `client_phone`, `quotation_id`, `quotation_number`, `total_paid`, `remaining_balance`, `payment_status`, `currency_code`, `currency_symbol`, `currency_name`, `default_payment_method`) VALUES
(13, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-266-295989', '2025-06-18 00:00:00', '2025-06-27', 'Madam Getrude', 'mizengogetrude@gmail.com', '', NULL, NULL, NULL, NULL, NULL, 0.00, 'percentage', 10.00, 200.00, 0.00, 1800.00, 'Thank you for choosing Ujuzi Digital Creations! Total amount of $ 1800.00 is due by 6/27/2025. We appreciate your business and look forward to serving you again.', 'pending', '', NULL, NULL, 0.00, 0.00, 'unpaid', 'USD', '$', 'US Dollar', 'cash'),
(15, 'e8a4b7b7-cb78-45db-847a-7e8ac8f407b9', 'INV-982-489008', '2025-06-24 00:00:00', '2025-06-30', 'Douglas', '', '', NULL, NULL, NULL, NULL, NULL, 0.00, '', 120.00, 120.00, 0.00, 8130.00, 'Thank you for choosing Joe outfits ! Payment is due by the specified date. We appreciate your business and look forward to serving you again.', '', NULL, NULL, NULL, 0.00, 0.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash'),
(21, 'e79e5915-b271-4a91-97ad-50ca1419419f', 'INV-891-395626', '2025-10-14 00:00:00', NULL, 'DR SHADRACK', '', 'MOSOCHO', NULL, NULL, NULL, NULL, NULL, 0.00, '', 0.00, 0.00, 0.00, 17500.00, 'Thank you for choosing kendox construction ltd! Payment is due by the specified date. We appreciate your business and look forward to serving you again.', '', '0720109389', NULL, NULL, 0.00, 0.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash'),
(22, 'e79e5915-b271-4a91-97ad-50ca1419419f', 'INV-391-897113', '2026-01-18 00:00:00', NULL, 'majengo hardware', '', 'nyakoe markert', NULL, NULL, NULL, NULL, NULL, 0.00, '', 0.00, 0.00, 0.00, 320310.00, 'Thank you for choosing kendox construction ltd! Payment is due by the specified date. We appreciate your business and look forward to serving you again.', '', '0705222273', NULL, NULL, 0.00, 0.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash'),
(23, 'e79e5915-b271-4a91-97ad-50ca1419419f', 'INV-265-232732', '2026-01-18 00:00:00', NULL, 'DR SHADRACK', '', 'MOSOCHO', NULL, NULL, NULL, NULL, NULL, 0.00, '', 0.00, 0.00, 0.00, 13250.00, 'Thank you for choosing kendox construction ltd! Payment is due by the specified date. We appreciate your business and look forward to serving you again.', '', '0720109389', NULL, NULL, 0.00, 0.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash'),
(24, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-969-361426', '2026-06-12 00:00:00', NULL, 'Mary Njoki', 'marynjoki899@gmail.com', 'Kisumu, Kenya ', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 234.00, 'Thank you for choosing Ujuzi Digital Creations! Total amount of € 234.00 is due by the specified date. We appreciate your business and look forward to serving you again.', 'pending', '0712838943', NULL, NULL, 0.00, 234.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(25, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-189-763835', '2026-06-13 00:00:00', NULL, 'Mary Njoki', 'marynjoki899@gmail.com', 'Kisumu, Kenya ', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 234.00, 'Thank you for choosing Ujuzi Digital Creations! Total amount of € 234.00 is due by the specified date. We appreciate your business and look forward to serving you again.', 'pending', '0712838943', NULL, NULL, 0.00, 234.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(26, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-869-649342', '2026-06-17 00:00:00', NULL, 'Michael Chege', 'contact.mikechege@gmail.com', 'Nairobi, Kenya', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 2131.00, 'Thank you for choosing Ujuzi Digital Creations! Total amount of € 2131.00 is due by the specified date. We appreciate your business and look forward to serving you again.', 'pending', '0741238738', NULL, NULL, 0.00, 2131.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(27, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-846-743238', '2026-06-18 00:00:00', '2026-06-24', 'Feiyole', '', '', NULL, NULL, NULL, NULL, NULL, 16.00, 'amount', 0.00, 0.00, 2080.00, 15080.00, 'Thank you for your prompt payment! We appreciate your business with Ujuzi Digital Creations. Your invoice has been settled in full.', 'paid', '', NULL, NULL, 0.00, 15080.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(28, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-835-267335', '2026-06-20 00:00:00', NULL, 'Mary Njoki', 'marynjoki899@gmail.com', 'Kisumu, Kenya ', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 132.00, 'Thank you for your partial payment of € 123.00. Remaining balance of € 9.00 is due by the specified date. We appreciate your business with Ujuzi Digital Creations!', 'pending', '0712838943', NULL, NULL, 0.00, 132.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(29, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-385-684071', '2026-06-19 00:00:00', NULL, 'Mary Njoki', 'marynjoki899@gmail.com', 'Kisumu, Kenya ', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 23.00, 'Thank you for choosing Ujuzi Digital Creations! Total amount of zxc 23.00 is due by the specified date. We appreciate your business and look forward to serving you again.', 'pending', '0712838943', NULL, NULL, 0.00, 23.00, 'unpaid', 'SAD', 'zxc', 'jasc', 'cash'),
(30, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-105-276584', '2026-06-20 00:00:00', NULL, 'sadd', '', '', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 234.00, 'Thank you for your partial payment of € 123.00. Remaining balance of € 111.00 is due by the specified date. We appreciate your business with Ujuzi Digital Creations!', 'pending', '', NULL, NULL, 0.00, 234.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(31, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-288-657838', '2026-06-18 00:00:00', '2026-06-24', 'Feiyole', '', '', NULL, NULL, NULL, NULL, NULL, 16.00, 'amount', 0.00, 0.00, 2080.00, 15080.00, 'Thank you for your prompt payment! We appreciate your business with Ujuzi Digital Creations. Your invoice has been settled in full.', 'paid', '', NULL, NULL, 0.00, 15080.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(32, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-622-901490', '2026-06-18 00:00:00', NULL, 'Mary Njoki', 'marynjoki899@gmail.com', 'Kisumu, Kenya ', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 23.00, 'Thank you for choosing Ujuzi Digital Creations! Total amount of € 23.00 is due by the specified date. We appreciate your business and look forward to serving you again.', 'pending', '0712838943', NULL, NULL, 0.00, 23.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(33, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-150-036776', '2026-06-18 00:00:00', NULL, 'Mary Njoki', 'marynjoki899@gmail.com', 'Kisumu, Kenya ', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 23.00, 'Thank you for choosing Ujuzi Digital Creations! Total amount of € 23.00 is due by the specified date. We appreciate your business and look forward to serving you again.', 'pending', '0712838943', NULL, NULL, 0.00, 23.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(35, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-334-360077', '2026-06-22 00:00:00', NULL, 'Mary Njoki', 'marynjoki899@gmail.coms', 'Kisumu, Kenya ', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 2300011.00, 'Thank you for choosing Ujuzi Digital Creations! Total amount of € 2300011.00 is due by the specified date. We appreciate your business and look forward to serving you again.', 'pending', '0712838943', NULL, NULL, 0.00, 23000.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(36, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-565-444444', '2026-06-22 00:00:00', NULL, 'Michael Chege', 'contact.mikechege@gmail.com', 'Narok, City', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 566.00, 'Thank you for choosing Ujuzi Digital Creations! Total amount of € 566.00 is due by the specified date. We appreciate your business and look forward to serving you again.', 'pending', '0741238738', NULL, NULL, 0.00, 566.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(37, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-251-566325', '2026-06-18 00:00:00', NULL, 'Mary Njoki', 'marynjoki899@gmail.com', 'Kisumu, Kenya ', NULL, NULL, NULL, NULL, NULL, 23.00, 'percentage', 2.00, 0.46, 5.18, 27.72, 'Thank you for choosing Ujuzi Digital Creations! Total amount of € 27.72 is due by the specified date. We appreciate your business and look forward to serving you again.', 'pending', '0712838943', NULL, NULL, 0.00, 27.72, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(38, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-256-776656', '2026-05-05 00:00:00', '2026-05-13', 'Grace Wanjiku', 'procurement@brightfutureacademy.ac.ke', 'Bright Future Academy, Kilifi Town, Kenya', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 16.00, 'amount', 0.00, 0.00, 59440.00, 430940.00, 'Thank you for choosing Ujuzi Digital Creations! Total amount of KSh 430940.00 is due by 5/13/2026. We appreciate your business and look forward to serving you again.', 'pending', '0711 987 654', NULL, NULL, 0.00, 430940.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'cash'),
(39, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-124-693348', '2026-06-14 00:00:00', '2026-06-22', 'Brian Kariuki', 'brian.kariuki@gmail.com', 'Umoja Estate, Nairobi, Kenya', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 1900.00, 'Thank you for your partial payment of KSh 500.00. Remaining balance of KSh 1400.00 is due by 22/06/2026. We appreciate your business with Pendo General Store!', 'pending', '+254 723 654 321', NULL, NULL, 0.00, 1900.00, 'unpaid', 'KES', 'KSh', 'Kenyan Shilling', 'mpesa'),
(40, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-111-704469', '2026-07-12 00:00:00', NULL, 'Mary Njoki', 'marynjoki899@gmail.com', 'Kisumu, Kenya ', NULL, NULL, NULL, NULL, NULL, 0.00, 'amount', 0.00, 0.00, 0.00, 23.00, 'Thank you for choosing Ujuzi Digital Creations! Total amount of € 23.00 is due by the specified date. We appreciate your business and look forward to serving you again.', 'pending', '0712838943', NULL, NULL, 0.00, 23.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(41, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-530-917469', '2026-07-12 00:00:00', NULL, 'Michael Chege', 'contact.mikechege@gmail.com', 'Narok, City', 'Ujuzi Diasdd', 'Kenyattaasdad. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujasddsa', 'httpsada', 0.00, 'amount', 0.00, 0.00, 0.00, 213.00, 'Thank you for choosing Ujuzi Diasdd! Total amount of € 213.00 is due by the specified date. We appreciate your business and look forward to serving you again.', 'pending', '0741238738', NULL, NULL, 0.00, 213.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(42, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-173-056001', '2026-07-13 00:00:00', NULL, 'Micha', '', '', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 0.00, 'amount', 0.00, 0.00, 0.00, 3242.00, 'Thank you for choosing Ujuzi Digital Creations! Total amount of € 3242.00 is due by the specified date. We appreciate your business and look forward to serving you again.', 'pending', '', NULL, NULL, 0.00, 3242.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(43, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-887-555228', '2026-07-13 00:00:00', '2026-07-12', 'Mary Njoki', 'marynjoki899@gmail.com', 'Kisumu, Kenya ', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 0.00, 'amount', 0.00, 0.00, 0.00, 2131.00, 'This invoice is now overdue. Outstanding balance: € 2131.00. Please contact Ujuzi Digital Creations at your earliest convenience to arrange payment. Late fees may apply.', 'overdue', '0712838943', NULL, NULL, 0.00, 2131.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(44, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-826-635853', '2026-07-14 00:00:00', NULL, 'Michael Chege', 'contact.mikechege@gmail.com', 'Narok, City', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 0.00, 'amount', 0.00, 0.00, 0.00, 12000.00, 'Thank you for your partial payment of € 120. Remaining balance of € 12000.00 is due by the specified date.', 'partially_paid', '0741238738', NULL, NULL, 0.00, 12000.00, 'unpaid', 'EUR', '€', 'Euro', 'cash'),
(45, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-359-718347', '2026-07-14 00:00:00', '2026-07-29', 'Mary Njoki', 'marynjoki899@gmail.com', 'Kisumu, Kenya ', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 0.00, 'amount', 0.00, 0.00, 0.00, 1222.00, 'Thank you for your partial payment of € 1. Remaining balance of € 1221.00 is due by 7/29/2026.', 'partially_paid', '0712838943', NULL, NULL, 1.00, 1221.00, 'partial', 'EUR', '€', 'Euro', 'cash'),
(46, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-704-725093', '2026-07-15 00:00:00', NULL, 'my my', 'mymy22gmailc.', 'csacc', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 0.00, 'amount', 0.00, 0.00, 0.00, 1200.00, 'Thank you for your partial payment of € 900. Remaining balance of € 300.00 is due by the specified date.', 'partially_paid', '07412387sda', NULL, NULL, 900.00, 300.00, 'partial', 'EUR', '€', 'Euro', 'mpesa'),
(47, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-655-013826', '2026-07-15 00:00:00', NULL, 'Micha', '', '', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 0.00, 'amount', 0.00, 0.00, 0.00, 3242.00, 'Thank you for your partial payment of € 3. Remaining balance of € 3239.00 is due by the specified date.', 'partially_paid', '', NULL, NULL, 3.00, 3239.00, 'partial', 'EUR', '€', 'Euro', 'cash'),
(48, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-163-106421', '2026-07-15 00:00:00', NULL, 'my my', 'mymy22gmailc.', 'csacc', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 0.00, 'amount', 0.00, 0.00, 0.00, 1200.00, 'Thank you for your partial payment of € 12. Remaining balance of € 1200.00 is due by the specified date.', 'partially_paid', '07412387sda', NULL, NULL, 12.00, 1188.00, 'partial', 'EUR', '€', 'Euro', 'mpesa'),
(49, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-213-199297', '2026-07-14 00:00:00', NULL, 'my my', 'mymy22gmailc.', 'csacc', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 0.00, 'amount', 0.00, 0.00, 0.00, 1200.00, 'Thank you for your partial payment of $ 122. Remaining balance of $ 1078.00 is due by the specified date.', 'partially_paid', '07412387sda', NULL, NULL, 122.00, 1078.00, 'partial', 'USD', '$', 'US Dollar', 'mpesa'),
(50, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-732-171286', '2026-07-15 00:00:00', NULL, 'my my', 'mymy22gmailc.', 'csacc', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 0.00, 'amount', 0.00, 0.00, 0.00, 12000.00, 'Thank you for your partial payment of € 1000. Remaining balance of € 11000.00 is due by the specified date.', 'partially_paid', '07412387sda', NULL, NULL, 1000.00, 11000.00, 'partial', 'EUR', '€', 'Euro', 'mpesa'),
(51, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-124-830797', '2026-07-16 00:00:00', NULL, 'asds', '', '', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 0.00, 'amount', 0.00, 0.00, 0.00, 10000.00, 'Thank you for your partial payment of € 1000. Remaining balance of € 9000.00 is due by the specified date.', 'partially_paid', '', NULL, NULL, 1000.00, 9000.00, 'partial', 'EUR', '€', 'Euro', 'cash'),
(57, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-709-001681', '2026-07-12 00:00:00', '2026-07-23', 'Francis M', 'frankchege56@gmail.com', 'Narok, City', 'Ujuzi Digitalsdad', 'Kenyatta Avenue, adas', '+254741238738', 'hello@ujuzicreations.cosdfsd', 'https://ujuzi.co.kasda', 16.00, 'amount', 100.00, 100.00, 1744.00, 12644.00, 'This invoice is now overdue. Outstanding balance: € 12644.00. Please contact Ujuzi Digitalsdad at your earliest convenience to arrange payment. Late fees may apply.', 'overdue', '0740930900', NULL, NULL, 0.00, 12644.00, 'unpaid', 'EUR', '€', 'Euro', 'mpesa'),
(59, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-215-691131', '2026-07-12 00:00:00', NULL, 'my mw', 'mymy22gmailc.', 'csacc', 'fasfaf', 'Kenyatta Avenuwefwef', '+25474123873832', 'hello@ujuzicreations.co.keegwg', 'https://ujuzi.co.kewegw', 0.00, 'amount', 0.00, 0.00, 0.00, 1200.00, 'Thank you for your partial payment of € 121. Remaining balance of € 1079.00 is due by the specified date.', 'partially_paid', '07412387sda', NULL, NULL, 121.00, 1079.00, 'partial', 'EUR', '€', 'Euro', 'mpesa'),
(60, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-256-478831', '2026-07-11 00:00:00', '2026-07-22', 'Francis M', 'frankchege56@gmail.com', 'Narok, City', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 16.00, 'amount', 100.00, 100.00, 1744.00, 12644.00, 'This invoice is now overdue. Outstanding balance: € 12644.00. Please contact Ujuzi Digital Creations at your earliest convenience to arrange payment. Late fees may apply.', 'overdue', '0740930900', NULL, NULL, 0.00, 12644.00, 'unpaid', 'EUR', '€', 'Euro', 'mpesa'),
(61, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-215-374631', '2026-07-15 00:00:00', NULL, 'asds', 'sss', '', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 0.00, 'amount', 0.00, 0.00, 0.00, 10000.00, 'Thank you for your partial payment of € 1000. Remaining balance of € 9000.00 is due by the specified date.', 'partially_paid', '', NULL, NULL, 1000.00, 9000.00, 'partial', 'EUR', '€', 'Euro', 'cash'),
(62, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-608-023200', '2026-07-19 00:00:00', '2026-07-21', 'Francis M', 'frankchege56@gmail.com', 'Narok, City', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 0.00, 'amount', 0.00, 0.00, 0.00, 4700.00, 'Thank you for your partial payment of € 120. Remaining balance of € 4580.00 is due by 7/21/2026.', 'partially_paid', '0740930900', NULL, NULL, 120.00, 4580.00, 'partial', 'EUR', '€', 'Euro', 'card'),
(64, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-773-333846', '2026-07-18 00:00:00', '2026-07-20', 'Francis M', 'frankchege56@gmail.com', 'Narok, City', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 0.00, 'amount', 0.00, 0.00, 0.00, 4700.00, 'Thank you for your partial payment of € 120. Remaining balance of € 4580.00 is due by 7/20/2026.', 'partially_paid', '0740930900', NULL, NULL, 120.00, 4580.00, 'partial', 'EUR', '€', 'Euro', 'card'),
(66, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'INV-573-339792', '2026-07-29 00:00:00', NULL, 'Francis M', 'frankchege56@gmail.com', 'Narok, City', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 0.00, 'amount', 0.00, 0.00, 0.00, 23.00, 'Thank you for choosing Ujuzi Digital Creations! Total amount of € 23.00 is due by the specified date. We appreciate your business and look forward to serving you again.', 'pending', '0740930900', NULL, NULL, 0.00, 23.00, 'unpaid', 'EUR', '€', 'Euro', 'cash');

-- --------------------------------------------------------

--
-- Table structure for table `invoice_items`
--

DROP TABLE IF EXISTS `invoice_items`;
CREATE TABLE IF NOT EXISTS `invoice_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `invoice_id` int NOT NULL,
  `description` text NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `fk_invoice_items_invoice_id` (`invoice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=179 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `invoice_items`
--

INSERT INTO `invoice_items` (`id`, `invoice_id`, `description`, `quantity`, `price`, `total`) VALUES
(25, 15, 'Trouser', 3, 800.00, 0.00),
(26, 15, 'Tshirt', 3, 450.00, 0.00),
(27, 15, 'Shoe', 2, 1500.00, 0.00),
(28, 15, 'Watch', 1, 500.00, 0.00),
(29, 15, 'Belt', 5, 200.00, 0.00),
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
(50, 24, 'laptop', 1, 234.00, 234.00),
(52, 25, 'sada', 1, 234.00, 234.00),
(58, 26, 'sada', 1, 2131.00, 2131.00),
(60, 28, 'sad', 1, 132.00, 132.00),
(66, 13, 'WhatsApp Icon Integration (basic setup & linking to WhatsApp chat)', 1, 350.00, 350.00),
(67, 13, 'WhatsApp Icon Animation (hover effects, slide-in, and pulse animation)', 1, 250.00, 250.00),
(68, 13, 'Video Modal Functionality (embedding video player with close/play controls)', 1, 300.00, 300.00),
(69, 13, 'Video Icon Setup (custom video button linked to modal)', 1, 400.00, 400.00),
(70, 13, 'Blur-to-Clear Image Loading Enhancement (lazy loading with smooth blur) and faster page loading.', 1, 700.00, 700.00),
(72, 29, 'asdd', 1, 23.00, 23.00),
(73, 30, 'ewfef', 1, 234.00, 234.00),
(75, 31, 'Computer whole package', 1, 13000.00, 13000.00),
(76, 27, 'Computer whole package', 1, 13000.00, 13000.00),
(77, 32, 'asdd', 1, 23.00, 23.00),
(78, 33, 'asdd', 1, 23.00, 23.00),
(82, 35, 'ffygjh', 1, 2300011.00, 2300011.00),
(83, 37, 'asddadaddadasasdadacscdevevererveververve', 1, 23.00, 23.00),
(84, 36, 'jjiij', 1, 566.00, 566.00),
(107, 39, 'Bread (800g)', 2, 70.00, 140.00),
(108, 39, 'Fresh Milk (500ml)', 3, 65.00, 195.00),
(109, 39, 'White Sugar (1kg)', 1, 185.00, 185.00),
(110, 39, 'Bar Soap', 4, 75.00, 300.00),
(111, 39, 'Wheat Flour (2kg)', 2, 170.00, 340.00),
(112, 39, 'Cooking Oil (500ml)', 1, 240.00, 240.00),
(113, 39, 'Drinking Water (1.5L)', 6, 50.00, 300.00),
(114, 39, 'Biscuits Pack', 5, 40.00, 200.00),
(115, 40, 'asdadaa', 1, 23.00, 23.00),
(117, 42, 'sdasda', 1, 3242.00, 3242.00),
(118, 41, 'sfafaf', 1, 213.00, 213.00),
(120, 44, 'myself', 1, 12000.00, 12000.00),
(124, 48, 'kiti moto', 1, 1200.00, 1200.00),
(126, 50, 'kiti baridi', 1, 12000.00, 12000.00),
(127, 51, 'sadd', 1, 10000.00, 10000.00),
(139, 57, 'Television 32 inch', 1, 10000.00, 10000.00),
(140, 57, 'Remote Controller', 2, 500.00, 1000.00),
(141, 43, 'fdsfss', 1, 2131.00, 2131.00),
(146, 46, 'kiti moto', 1, 1200.00, 1200.00),
(148, 49, 'kiti moto', 1, 1200.00, 1200.00),
(151, 59, 'kiti moto', 1, 1200.00, 1200.00),
(152, 45, 'svdsvv vsvd', 1, 1222.00, 1222.00),
(153, 38, 'HP LaserJet Printer', 2, 35000.00, 70000.00),
(154, 38, 'A4 Photocopy Paper (Box)', 10, 4200.00, 42000.00),
(155, 38, 'Office Chairs', 6, 12500.00, 75000.00),
(156, 38, 'Executive Office Desk', 2, 28000.00, 56000.00),
(157, 38, 'Epson Projector', 1, 69000.00, 69000.00),
(158, 38, 'Whiteboards (120cm × 90cm)', 3, 8500.00, 25500.00),
(159, 38, 'Black Toner Cartridge', 5, 6800.00, 34000.00),
(160, 60, 'Television 32 inch', 1, 10000.00, 10000.00),
(161, 60, 'Remote Controller', 2, 500.00, 1000.00),
(162, 47, 'dsfsfs', 1, 3242.00, 3242.00),
(163, 61, 'sadd', 1, 10000.00, 10000.00),
(172, 62, 'Table', 1, 2300.00, 2300.00),
(173, 62, 'Chair', 2, 1200.00, 2400.00),
(174, 64, 'Table', 1, 2300.00, 2300.00),
(175, 64, 'Chair', 2, 1200.00, 2400.00),
(177, 66, 'cxzx', 1, 23.00, 23.00);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
CREATE TABLE IF NOT EXISTS `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `plan_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `reference` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `tokens_added` int DEFAULT '0',
  `status` enum('pending','successful','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'pending',
  `payment_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `payment_provider` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_payments_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `user_id`, `plan_id`, `reference`, `amount`, `tokens_added`, `status`, `payment_method`, `payment_provider`, `metadata`, `created_at`, `updated_at`) VALUES
(39, 'b6721071-c843-4a44-ba69-96f6d2bfac1c', '2', 'PAY-1750481173602-8', 59.00, 20, '', NULL, NULL, NULL, '2025-06-21 07:46:13', '2025-06-21 07:46:47'),
(41, 'e8a4b7b7-cb78-45db-847a-7e8ac8f407b9', '1', 'PAY-1750779191774-29', 19.00, 6, '', NULL, NULL, NULL, '2025-06-24 18:33:11', '2025-06-24 18:35:08'),
(44, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1757053601989-657', 19.00, 6, '', NULL, NULL, NULL, '2025-09-05 09:26:41', '2025-09-05 09:27:09'),
(45, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1757830555739-799', 19.00, 6, '', NULL, NULL, NULL, '2025-09-14 09:15:55', '2025-09-14 09:16:24'),
(46, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1758442406311-262', 19.00, 6, '', NULL, NULL, NULL, '2025-09-21 11:13:26', '2025-09-21 11:13:48'),
(47, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1760373762425-69', 19.00, 6, '', NULL, NULL, NULL, '2025-10-13 19:42:42', '2025-10-13 19:43:14'),
(48, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1763968976389-218', 19.00, 6, '', NULL, NULL, NULL, '2025-11-24 10:22:56', '2025-11-24 10:23:44'),
(49, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1765352700379-84', 19.00, 6, '', NULL, NULL, NULL, '2025-12-10 10:45:00', '2025-12-10 10:45:26'),
(50, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1765783127969-243', 19.00, 6, '', NULL, NULL, NULL, '2025-12-15 10:18:47', '2025-12-15 10:19:16'),
(51, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1768303759365-502', 19.00, 6, '', NULL, NULL, NULL, '2026-01-13 14:29:19', '2026-01-13 14:29:47'),
(52, 'e79e5915-b271-4a91-97ad-50ca1419419f', '2', 'PAY-1768734472910-411', 59.00, 20, '', NULL, NULL, NULL, '2026-01-18 14:07:52', '2026-01-18 14:09:32'),
(53, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1769075911999-185', 19.00, 6, 'failed', NULL, NULL, NULL, '2026-01-22 12:58:31', '2026-01-22 12:58:40'),
(54, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2', 'PAY-1770881103286-732', 59.00, 20, 'failed', NULL, NULL, NULL, '2026-02-12 10:25:03', '2026-02-12 10:25:05'),
(55, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1771344412335-456', 19.00, 6, 'failed', NULL, NULL, NULL, '2026-02-17 19:06:52', '2026-02-17 19:06:54'),
(56, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1771346894006-461', 19.00, 6, 'failed', NULL, NULL, NULL, '2026-02-17 19:48:14', '2026-02-17 19:48:15'),
(57, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1771347974401-568', 19.00, 6, 'failed', NULL, NULL, NULL, '2026-02-17 20:06:14', '2026-02-17 20:06:18'),
(58, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1771348931718-693', 19.00, 6, 'failed', NULL, NULL, NULL, '2026-02-17 20:22:11', '2026-02-17 20:22:15'),
(59, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1771394121077-784', 19.00, 6, 'pending', NULL, NULL, NULL, '2026-02-18 08:55:21', '2026-02-18 08:55:21'),
(60, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1771394639849-738', 19.00, 6, 'failed', NULL, NULL, NULL, '2026-02-18 09:03:59', '2026-02-18 09:04:01'),
(61, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1785669978176-25', 19.00, 6, 'failed', NULL, NULL, NULL, '2026-08-02 14:26:18', '2026-08-02 14:26:19'),
(62, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2', 'PAY-1785847969217-333', 59.00, 20, 'successful', NULL, NULL, NULL, '2026-08-04 15:52:49', '2026-08-04 15:53:14'),
(63, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1785848148943-346', 19.00, 6, 'successful', NULL, NULL, NULL, '2026-08-04 15:55:48', '2026-08-04 15:56:06'),
(64, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2', 'PAY-1785848297096-887', 59.00, 20, 'successful', NULL, NULL, NULL, '2026-08-04 15:58:17', '2026-08-04 15:58:31'),
(65, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '3', 'PAY-1785848402366-524', 119.00, 45, 'failed', NULL, NULL, NULL, '2026-08-04 16:00:02', '2026-08-04 16:00:04'),
(66, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '4', 'PAY-1785848425532-227', 249.00, 100, 'successful', NULL, NULL, NULL, '2026-08-04 16:00:25', '2026-08-04 16:00:54'),
(67, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1785849828344-932', 19.00, 6, 'successful', NULL, NULL, NULL, '2026-08-04 16:23:48', '2026-08-04 16:24:07'),
(68, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1785849860048-540', 19.00, 6, 'failed', NULL, NULL, NULL, '2026-08-04 16:24:20', '2026-08-04 16:24:21'),
(69, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1785850860588-885', 19.00, 6, 'successful', NULL, NULL, NULL, '2026-08-04 16:41:00', '2026-08-04 16:41:16'),
(70, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2', 'PAY-1785850923725-959', 59.00, 20, 'failed', NULL, NULL, NULL, '2026-08-04 16:42:03', '2026-08-04 16:42:05'),
(71, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '3', 'PAY-1785850958061-903', 119.00, 45, 'successful', NULL, NULL, NULL, '2026-08-04 16:42:38', '2026-08-04 16:43:12'),
(72, '57e67e48-b196-4f84-86fb-72c7a24b6b94', '1', 'PAY-1785851098887-621', 19.00, 6, 'successful', NULL, NULL, NULL, '2026-08-04 16:44:58', '2026-08-04 16:45:15'),
(73, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '4', 'PAY-1785851269118-165', 249.00, 100, 'successful', NULL, NULL, NULL, '2026-08-04 16:47:49', '2026-08-04 16:48:03'),
(74, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '1', 'PAY-1785851484511-374', 19.00, 6, 'successful', NULL, NULL, NULL, '2026-08-04 16:51:24', '2026-08-04 16:51:48');

-- --------------------------------------------------------

--
-- Table structure for table `payment_plans`
--

DROP TABLE IF EXISTS `payment_plans`;
CREATE TABLE IF NOT EXISTS `payment_plans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tokens` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `bonus_tokens` int DEFAULT '0',
  `is_popular` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Table structure for table `quotations`
--

DROP TABLE IF EXISTS `quotations`;
CREATE TABLE IF NOT EXISTS `quotations` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `currency_name` varchar(50) DEFAULT 'Kenyan Shilling',
  PRIMARY KEY (`id`),
  KEY `fk_quotation_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `quotations`
--

INSERT INTO `quotations` (`id`, `quotation_number`, `user_id`, `date_issued`, `valid_until`, `status`, `client_name`, `client_email`, `client_phone`, `client_address`, `client_county`, `business_name`, `business_email`, `business_phone`, `business_address`, `business_kra_pin`, `subtotal`, `discount_type`, `discount_value`, `discount_amount`, `tax_rate`, `tax_amount`, `total_amount`, `payment_terms`, `delivery_terms`, `validity_period`, `notes`, `terms_conditions`, `converted_to_invoice`, `converted_invoice_id`, `converted_at`, `created_at`, `updated_at`, `currency_code`, `currency_symbol`, `currency_name`) VALUES
(2, 'QT-002-2026', 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2026-02-14', '2026-03-16', 'draft', 'Mary Wanjikuss', 'mary@gmail.com', '0799887766', 'Naivasha, Town Centre', 'Nakuru', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '', 22000.00, 'amount', 2000.00, 2000.00, 16.00, 3200.00, 23200.00, 'Full payment before delivery', 'Delivery within 5 days', '30', 'Second quotation for client.', 'All services subject to agreement.', 0, NULL, NULL, '2026-02-13 10:12:33', '2026-06-14 17:42:07', 'KES', 'KSh', 'Kenyan Shilling'),
(4, 'QT/2606/537', 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2026-06-14', '2026-07-14', 'draft', 'Michael Chege', 'contact.mikechege@gmail.com', '0741238738', 'Narok, City', '', '', '', '', '', '', 2342.00, 'amount', 0.00, 0.00, 16.00, 374.72, 2716.72, 'Payment due within 30 days', 'Delivery within 7 working days', '30', 'This quotation is valid until 7/14/2026. We look forward to doing business with you.', '1. Quotation valid for 30 days\n2. Prices inclusive of 16% VAT\n3. Full payment required before delivery\n4. Warranty: 12 months on hardware, 3 months on software', 0, NULL, NULL, '2026-06-14 17:34:35', '2026-06-14 17:37:11', 'KES', 'KSh', 'Kenyan Shilling'),
(5, 'QT/2606/899', 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2026-06-14', '2026-07-14', 'draft', 'Michael Chege', 'contact.mikechege@gmail.com', '0741238738', 'Narok, City', '', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '', 2312.00, 'amount', 0.00, 0.00, 16.00, 369.92, 2681.92, 'Payment due within 30 days', 'Delivery within 7 working days', '30', 'This quotation is valid until 7/14/2026. We look forward to doing business with you.', '1. Quotation valid for 30 days\n2. Prices inclusive of 16% VAT\n3. Full payment required before delivery\n4. Warranty: 12 months on hardware, 3 months on software', 0, NULL, NULL, '2026-06-14 17:37:42', '2026-06-14 17:41:49', 'KES', 'KSh', 'Kenyan Shilling'),
(6, 'QT/2606/857', 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2026-06-14', '2026-07-14', 'draft', 'Mercy', '', '', '', '', '', '', '', '', '', 2430.00, 'amount', 0.00, 0.00, 16.00, 388.80, 2818.80, 'Payment due within 30 days', 'Delivery within 7 working days', '30', 'This quotation is valid until 7/14/2026. We look forward to doing business with you.', '1. Quotation valid for 30 days\n2. Prices inclusive of 16% VAT\n3. Full payment required before delivery\n4. Warranty: 12 months on hardware, 3 months on software', 0, NULL, NULL, '2026-06-14 17:42:39', '2026-06-14 17:42:39', 'KES', 'KSh', 'Kenyan Shilling'),
(7, 'QT/2606/715', 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2026-06-14', '2026-07-14', 'draft', 'Fred', '', '', '', '', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '', 23420.00, 'amount', 0.00, 0.00, 16.00, 3747.20, 27167.20, 'Payment due within 30 days', 'Delivery within 7 working days', '30', 'This quotation is valid until 7/14/2026. We look forward to doing business with you.', '1. Quotation valid for 30 days\n2. Prices inclusive of 16% VAT\n3. Full payment required before delivery\n4. Warranty: 12 months on hardware, 3 months on software', 0, NULL, NULL, '2026-06-14 17:51:02', '2026-06-14 17:51:18', 'KES', 'KSh', 'Kenyan Shilling'),
(8, 'QT/2606/928', 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2026-06-14', '2026-07-14', 'draft', 'frank', '', '', '', '', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '', 21310.00, 'amount', 0.00, 0.00, 16.00, 3409.60, 24719.60, 'Payment due within 30 days', 'Delivery within 7 working days', '30', 'This quotation is valid until 7/14/2026. We look forward to doing business with you.', '1. Quotation valid for 30 days\n2. Prices inclusive of 16% VAT\n3. Full payment required before delivery\n4. Warranty: 12 months on hardware, 3 months on software', 0, NULL, NULL, '2026-06-14 17:56:03', '2026-06-14 17:56:03', 'KES', 'KSh', 'Kenyan Shilling'),
(9, 'QT/2606/792', 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2026-06-16', '2026-07-16', 'draft', 'Michael Chege', 'contact.mikechege@gmail.com', '0741238738', 'Narok, City', '', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '', 1200.00, 'amount', 0.00, 0.00, 16.00, 192.00, 1392.00, 'Payment due within 30 days', 'Delivery within 7 working days', '30', 'This quotation is valid until 7/16/2026. We look forward to doing business with you.', '1. Quotation valid for 30 days\n2. Prices inclusive of 16% VAT\n3. Full payment required before delivery\n4. Warranty: 12 months on hardware, 3 months on software', 0, NULL, NULL, '2026-06-16 10:06:33', '2026-06-16 10:06:33', 'KES', 'KSh', 'Kenyan Shilling'),
(10, 'QT/2606/328', 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2026-06-16', '2026-07-16', 'draft', 'Mary Njoki', 'marynjoki899@gmail.com', '0712838943', 'Kisumu, Kenya ', '', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '', 2342.00, 'amount', 0.00, 0.00, 16.00, 374.72, 2716.72, 'Payment due within 30 days', 'Delivery within 7 working days', '30', 'This quotation is valid until 7/16/2026. We look forward to doing business with you.', '1. Quotation valid for 30 days\n2. Prices inclusive of 16% VAT\n3. Full payment required before delivery\n4. Warranty: 12 months on hardware, 3 months on software', 0, NULL, NULL, '2026-06-16 23:10:20', '2026-06-16 23:14:51', 'UGX', 'USh', 'Ugandan Shilling'),
(12, 'QT/2607/114', 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2026-07-26', '2026-08-13', 'draft', 'Francis M', 'frankchege56@gmail.com', '0740930900', 'Narok, City', '', 'Afya', 'hello@ujuzicreations.co.kescs', '+25474123873821', 'Narok', '', 3600.00, 'amount', 160.00, 160.00, 15.00, 516.00, 3956.00, 'Payment due within 3 days', 'Delivery within 45 working days', '18', 'This quotation is valid until 7/27/2026. We look forward to doing business with you daWg', '1. Quotation valid infinity\n2. Prices inclusive of 15% VAT\n3. Full payment required before deliveryy\n4. Warranty: 18 months on hardware, 1 months on software', 0, NULL, NULL, '2026-07-26 16:38:46', '2026-07-27 13:17:43', 'KES', 'KSh', 'Kenyan Shilling'),
(14, 'QT/2607/114', 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2026-07-26', '2026-08-08', 'draft', 'Francis M', 'frankchege56@gmail.com', '0740930900', 'Narok, City', '', 'Ujuzi Digital Creations', 'hello@ujuzicreations.co.ke', '+254741238738', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '', 3600.00, 'amount', 160.00, 160.00, 15.00, 516.00, 3956.00, 'Payment due within 3 days', 'Delivery within 45 working days', '13', 'This quotation is valid until 7/27/2026. We look forward to doing business with you daWg', '1. Quotation valid infinity\n2. Prices inclusive of 15% VAT\n3. Full payment required before deliveryy\n4. Warranty: 18 months on hardware, 1 months on software', 0, NULL, NULL, '2026-07-26 17:12:04', '2026-07-26 17:12:04', 'EUR', '€', 'Euro'),
(15, 'QT/2607/114', 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', '2026-07-26', '2026-08-08', 'draft', 'Francis M', 'frankchege56@gmail.com', '0740930900', 'Narok, City', '', 'Afya', 'hello@ujuzicreations.co.kescs', '+25474123873821', 'Narok', '', 3600.00, 'amount', 160.00, 160.00, 15.00, 516.00, 3956.00, 'Payment due within 3 days', 'Delivery within 45 working days', '13', 'This quotation is valid until 7/27/2026. We look forward to doing business with you daWg', '1. Quotation valid infinity\n2. Prices inclusive of 15% VAT\n3. Full payment required before deliveryy\n4. Warranty: 18 months on hardware, 1 months on software', 0, NULL, NULL, '2026-07-27 13:10:12', '2026-07-27 13:11:01', 'KES', 'KSh', 'Kenyan Shilling');

-- --------------------------------------------------------

--
-- Table structure for table `quotation_items`
--

DROP TABLE IF EXISTS `quotation_items`;
CREATE TABLE IF NOT EXISTS `quotation_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `quotation_id` int NOT NULL,
  `item_code` varchar(50) DEFAULT NULL,
  `description` text NOT NULL,
  `quantity` decimal(10,2) NOT NULL DEFAULT '1.00',
  `unit` varchar(20) DEFAULT 'pcs',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `fk_quotation_items_quotation` (`quotation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `quotation_items`
--

INSERT INTO `quotation_items` (`id`, `quotation_id`, `item_code`, `description`, `quantity`, `unit`, `price`, `total`) VALUES
(15, 4, 'sdfss', 'fwefwf', 1.00, 'pcs', 2342.00, 2342.00),
(17, 5, 'adasf', 'sdffs', 1.00, 'pcs', 2312.00, 2312.00),
(18, 2, 'LOGO01', 'Logo Design', 1.00, 'service', 5000.00, 5000.00),
(19, 2, 'SOC01', 'Social Media Posters (10)', 10.00, 'pcs', 500.00, 5000.00),
(20, 2, 'WEB002', 'Landing Page Website', 1.00, 'service', 12000.00, 12000.00),
(21, 6, 'sadad', 'dsfs', 1.00, 'pcs', 2430.00, 2430.00),
(23, 7, 'sad', 'ewff', 1.00, 'pcs', 23420.00, 23420.00),
(26, 9, 'SKU', 'Hereby this....', 1.00, 'pcs', 1200.00, 1200.00),
(27, 8, 'adsd', 'dsvsvs', 1.00, 'pcs', 21310.00, 21310.00),
(29, 10, 'sdf', 'scacc', 1.00, 'pcs', 2342.00, 2342.00),
(32, 14, 'Chari', 'A very good chari', 2.00, 'hts', 1200.00, 2400.00),
(33, 14, 'Chaplin', 'a very good chaplin', 1.00, 'bts', 1200.00, 1200.00),
(36, 15, 'Chari', 'A very good chari', 2.00, 'hts', 1200.00, 2400.00),
(37, 15, 'Chaplin', 'a very good chaplin', 1.00, 'bts', 1200.00, 1200.00),
(38, 12, 'Chari', 'A very good chari', 2.00, 'hts', 1200.00, 2400.00),
(39, 12, 'Chaplin', 'a very good chaplin', 1.00, 'bts', 1200.00, 1200.00);

-- --------------------------------------------------------

--
-- Table structure for table `receipts`
--

DROP TABLE IF EXISTS `receipts`;
CREATE TABLE IF NOT EXISTS `receipts` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `currency_name` varchar(50) DEFAULT 'Kenyan Shilling',
  PRIMARY KEY (`id`),
  KEY `fk_receipts_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `receipts`
--

INSERT INTO `receipts` (`id`, `user_id`, `receipt_number`, `date`, `business_name`, `business_address`, `business_phone`, `business_email`, `business_website`, `customer_name`, `customer_email`, `customer_phone`, `customer_address`, `payment_method`, `payment_reference`, `subtotal`, `tax_rate`, `tax_amount`, `total_amount`, `notes`, `currency_code`, `currency_symbol`, `currency_name`) VALUES
(11, '80d8394d-317e-4f4d-960d-d61d5a3206cf', 'REC-954-948317', '2025-06-20 00:00:00', 'Mary\'s biz', '', '+254746074218', 'marychege425@gmail.com', NULL, 'Mercy', 'mercy@yahoo.com', '0712838943', '', 'cash', NULL, 0.00, 16.00, 0.00, 2900.00, 'Thank you for your purchase at Mary\'s biz!', 'KES', 'KSh', 'Kenyan Shilling'),
(12, 'e8a4b7b7-cb78-45db-847a-7e8ac8f407b9', 'REC-651-931336', '2025-06-24 00:00:00', 'Joe outfits ', '', '+254741669499', 'johh39684@gmail.com', NULL, 'Sharon', '', '0712345678', '', 'cash', NULL, 0.00, 0.00, 0.00, 12000.00, 'Thank you for your purchase at Joe outfits !', 'KES', 'KSh', 'Kenyan Shilling'),
(16, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-708-757908', '2025-09-01 00:00:00', 'Ujuzi Digital Creations', '', '+254741238738', 'hello@ujuzicreations.co.ke', NULL, 'Tabby', '', '0715320277', '', 'mpesa', NULL, 0.00, 0.00, 0.00, 5000.00, 'Thank you for your purchase at Ujuzi Digital Creations! We\'ll commence development today. Amount remaining will be ksh 5000 (To be settled after work is complete and you\'ve confirmed everything is working.', 'KES', 'KSh', 'Kenyan Shilling'),
(17, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-614-960743', '2025-09-05 00:00:00', 'Ujuzi Digital Creations', '', '+254741238738', 'hello@ujuzicreations.co.ke', NULL, 'Tabyy Elite', '', '0715320277', '', 'mpesa', NULL, 0.00, 0.00, 0.00, 5500.00, 'Thank you for your purchase at Ujuzi Digital Creations! The amount has been settled in full.. It\'s been a pleasure working with you. If you need any assistance feel free to reach out.', 'KES', 'KSh', 'Kenyan Shilling'),
(19, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-680-802431', '2025-10-01 00:00:00', 'Ujuzi Digital Creations', '', '+254741238738', 'hello@ujuzicreations.co.ke', NULL, 'Quickpulse Safaris & Travel', '', '0725880964', 'Spring Court, Watermark Business Park', 'mpesa', NULL, 0.00, 0.00, 0.00, 5000.00, 'Thank you for your purchase at Ujuzi Digital Creations! We\'ll commence development today. Amount remaining will be ksh 5000 (To be settled after work is complete and you\'ve confirmed everything is working.', 'KES', 'KSh', 'Kenyan Shilling'),
(20, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-680-542818', '2025-10-02 00:00:00', 'Ujuzi Digital Creations', '', '+254741238738', 'hello@ujuzicreations.co.ke', NULL, 'Chris', '', '0712012557', '', 'mpesa', NULL, 0.00, 0.00, 0.00, 6750.00, 'Thank you for your purchase at Ujuzi Digital Creations! We\'ll commence development today. Amount remaining will be ksh 6750 (To be settled after work is complete and you\'ve reviewed the website.', 'KES', 'KSh', 'Kenyan Shilling'),
(21, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-789-351285', '2025-10-13 00:00:00', 'Ujuzi Digital Creations', '', '+254741238738', 'hello@ujuzicreations.co.ke', NULL, 'Chris', '', '0712012557', '', 'mpesa', NULL, 0.00, 0.00, 0.00, 3600.00, 'Thank you for your purchase at Ujuzi Digital Creations! Remaining balance will be Ksh 3150.', 'KES', 'KSh', 'Kenyan Shilling'),
(25, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-362-012046', '2026-06-11 00:00:00', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 'Michael Chege for me', 'contact.mikechege@gmail.com', '0741238738', 'Nar', 'cash', NULL, 0.00, 0.00, 0.00, 119.99, 'Thank you for your purchase at Ujuzi Digital Creations!', 'EUR', '€', 'Euro'),
(26, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-211-342579', '2026-06-11 00:00:00', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 'Mary Njoki', 'marynjoki899@gmail.com', '0712838943', 'Kisumu, Kenya ', 'cash', NULL, 0.00, 1.00, 0.00, 2152.31, 'Thank you for your purchase at Ujuzi Digital Creations!', 'EUR', '€', 'Euro'),
(27, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-287-587181', '2026-06-15 00:00:00', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 'Michael Chege', 'contact.mikechege@gmail.com', '0741238738', 'Narok, City', 'cash', NULL, 0.00, 0.00, 0.00, 537.00, 'Thank you for your purchase at Ujuzi Digital Creations!', 'EUR', '€', 'Euro'),
(28, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-531-697492', '2026-06-14 00:00:00', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 'Michael Chege', 'contact.mikechege@gmail.com', '0741238738', 'Narok, City', 'cash', NULL, 0.00, 16.00, 0.00, 372.36, 'Thank you for your purchase at Ujuzi Digital Creations!', 'EUR', '€', 'Euro'),
(29, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-885-776894', '2026-06-15 00:00:00', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 'Michael Chege', 'contact.mikechege@gmail.com', '0741238738', 'Narok, City', 'cash', NULL, 0.00, 0.00, 0.00, 3212.94, 'Thank you for your purchase at Ujuzi Digital Creations!', 'SAD', 's', 'Kenyan Shilling'),
(30, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-309-681114', '2026-06-19 00:00:00', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 'Michael Chege', 'contact.mikechege@gmail.com', '0741238738', 'Narok, City', 'cash', NULL, 0.00, 0.00, 0.00, 120.00, 'Thank you for your purchase at Ujuzi Digital Creations!', 'EUR', '€', 'Euro'),
(31, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-205-703181', '2026-06-22 00:00:00', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 'Michael Chege', 'contact.mikechege@gmail.com', '0741238738', 'Narok, City', 'cash', NULL, 0.00, 0.00, 0.00, 123.00, 'Thank you for your purchase at Ujuzi Digital Creations!', 'EUR', '€', 'Euro'),
(32, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-243-727301', '2026-06-23 00:00:00', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 'Mary Njoki', 'marynjoki899@gmail.com', '0712838943', 'Kisumu, Kenya ', 'cash', NULL, 0.00, 0.00, 0.00, 450.00, 'Thank you for your purchase at Ujuzi Digital Creations!', 'EUR', '€', 'Euro'),
(33, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-433-297277', '2026-07-01 00:00:00', 'Afya Care Pharmacy', 'Kimathi Street, Nairobi', '+254 713 458 920', 'sales@afyacarepharmacy.co.ke', 'https://https://afyapharmacy.co.ke', 'Esther Nyambura', '', '', '', 'mpesa', NULL, 0.00, 0.00, 0.00, 1945.00, 'Thank you for your purchase at Afya Care Pharmacy!', 'KES', 'KSh', 'Kenyan Shilling'),
(34, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-419-112416', '2026-06-30 00:00:00', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', '+254741238738', 'hello@ujuzicreations.co.ke', 'https://ujuzi.co.ke', 'Esther Nyambura', '', '', '', 'mpesa', NULL, 0.00, 0.00, 0.00, 1945.00, 'Thank you for your purchase at Ujuzi Digital Creations!', 'EUR', '€', 'Euro'),
(35, 'e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'REC-874-636650', '2026-06-29 00:00:00', 'Afya center', 'Nairobi', '+2547412387382', 'hello@ujuzicreations.co.kes', 'https://ujuzi.co.kes', 'Esther Nyambura', '', '', '', 'mpesa', NULL, 0.00, 0.00, 0.00, 1945.00, 'Thank you for your purchase at Afya center!', 'EUR', '€', 'Euro');

-- --------------------------------------------------------

--
-- Table structure for table `receipt_items`
--

DROP TABLE IF EXISTS `receipt_items`;
CREATE TABLE IF NOT EXISTS `receipt_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `receipt_id` int NOT NULL,
  `description` text NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `fk_receipt_items_receipt_id` (`receipt_id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `receipt_items`
--

INSERT INTO `receipt_items` (`id`, `receipt_id`, `description`, `quantity`, `price`, `total`) VALUES
(20, 11, 'braids', 1, 2500.00, 2500.00),
(21, 12, 'Trao', 2, 5500.00, 11000.00),
(22, 12, 'Tisho', 1, 1000.00, 1000.00),
(69, 16, 'Web Development Initial Deposit', 1, 5000.00, 5000.00),
(70, 17, 'Web development & Social Media Integration', 1, 5500.00, 5500.00),
(72, 19, 'Website Development', 1, 5000.00, 5000.00),
(73, 20, 'Website development', 1, 6750.00, 6750.00),
(74, 21, 'Debtime Limited Web Development Service', 1, 3600.00, 3600.00),
(81, 25, 'computer', 1, 119.99, 119.99),
(83, 26, 'dsfsdfss', 1, 2131.00, 2131.00),
(84, 27, 'ad', 1, 213.00, 213.00),
(85, 27, 'sdvds', 1, 324.00, 324.00),
(87, 29, 'sada', 1, 3212.94, 3212.94),
(88, 30, 'hyuhy', 1, 120.00, 120.00),
(90, 32, 'Hi there', 1, 450.00, 450.00),
(91, 31, 'sax', 1, 123.00, 123.00),
(92, 33, 'Pain Relief Tablets', 2, 150.00, 300.00),
(93, 33, 'Vitamin C Tablets', 1, 450.00, 450.00),
(94, 33, 'Surgical Face Masks', 5, 25.00, 125.00),
(95, 33, 'Hand Sanitizer (100ml)', 1, 220.00, 220.00),
(96, 33, 'Digital Thermometer', 1, 850.00, 850.00),
(97, 34, 'Pain Relief Tablets', 2, 150.00, 300.00),
(98, 34, 'Vitamin C Tablets', 1, 450.00, 450.00),
(99, 34, 'Surgical Face Masks', 5, 25.00, 125.00),
(100, 34, 'Hand Sanitizer (100ml)', 1, 220.00, 220.00),
(101, 34, 'Digital Thermometer', 1, 850.00, 850.00),
(102, 28, 'fasda', 1, 321.00, 321.00),
(108, 35, 'Pain Relief Tablets', 2, 150.00, 300.00),
(109, 35, 'Vitamin C Tablets', 1, 450.00, 450.00),
(110, 35, 'Surgical Face Masks', 5, 25.00, 125.00),
(111, 35, 'Hand Sanitizer (100ml)', 1, 220.00, 220.00),
(112, 35, 'Digital Thermometer', 1, 850.00, 850.00);

-- --------------------------------------------------------

--
-- Table structure for table `users_information`
--

DROP TABLE IF EXISTS `users_information`;
CREATE TABLE IF NOT EXISTS `users_information` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `business_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `business_address` text COLLATE utf8mb4_general_ci,
  `website` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `logo` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `accent_color` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '#0d9488',
  `currency_code` varchar(10) COLLATE utf8mb4_general_ci DEFAULT 'KES',
  `currency_symbol` varchar(10) COLLATE utf8mb4_general_ci DEFAULT 'KSh',
  `currency_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT 'Kenyan Shilling',
  `phone_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email_address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `trials` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reset_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `reset_token_expiry` bigint DEFAULT NULL,
  `signature` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `onboarding_completed` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_address` (`email_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_information`
--

INSERT INTO `users_information` (`id`, `name`, `business_name`, `business_address`, `website`, `logo`, `accent_color`, `currency_code`, `currency_symbol`, `currency_name`, `phone_number`, `country`, `email_address`, `password`, `trials`, `created_at`, `reset_token`, `reset_token_expiry`, `signature`, `onboarding_completed`) VALUES
('25738224-2926-48a6-8774-c37830ea0681', 'Martin Muchomba Mutuura', 'Greenbridge', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254729690152', NULL, 'info.greenbridgeltd@gmail.com', '$2b$10$nPsbZ8P.K2JJycHq6BcMcuiTNh43jyv.swXvOdV1lYi/F191Tf4.2', 5, '2025-09-05 10:16:21', NULL, NULL, NULL, 0),
('44643d1f-456e-44ca-bb0d-530b7c94dfce', 'Cardimore Avwonda', 'Ashley Collymore Stores', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254791929454', NULL, 'ashleycollymoreke@gmail.com', '$2b$10$Fqu5TwsQFuGVBfkIe/ffk.pgRjxVGAQJgtHycWnARR.fjnif1oq5a', 5, '2025-10-29 18:20:06', NULL, NULL, NULL, 0),
('57e67e48-b196-4f84-86fb-72c7a24b6b94', 'Mike mivkey', 'Hshs djss', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254112770494', NULL, 'mikechege770@gmail.com', '$2b$10$GCoEpneWYtQTJwFvOMh6S.s1kBJUkOn7jncUXte5LAGhfgwpRBVVO', 11, '2025-07-18 06:57:37', NULL, NULL, NULL, 0),
('80d8394d-317e-4f4d-960d-d61d5a3206cf', 'mary chege', 'Mary\'s biz', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254746074218', NULL, 'marychege425@gmail.com', '$2b$10$/WQK6vojfVKSPV5.fW/Fb.g7U9dZf5NuFfP4/.NplvnGM4GxoWoXu', 4, '2025-06-20 06:48:33', NULL, NULL, NULL, 0),
('a7539aca-3c16-4820-b545-0d578f36d63a', 'Ujuzi Creations', 'Mama mboga', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254712838943', NULL, 'ujuzicreations@gmail.com', '$2b$10$z5H3gy1fhsqnjix9Bw8QT.6blpSLVJU6asahxmA32l4WOu7jiPxTa', 5, '2025-06-20 11:13:13', NULL, NULL, NULL, 0),
('b6721071-c843-4a44-ba69-96f6d2bfac1c', 'Fred Chege', 'Fc tech', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254704692424', NULL, 'fredchege199@gmail.com', '$2b$10$8vVmeaYZIeJJ0FRXLLzX1ezq9UEpSq2eMC5b30S9aX.qOjrr5Frrm', 27, '2025-06-21 01:35:02', NULL, NULL, NULL, 0),
('e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6', 'C.E.O George', 'Ujuzi Digital Creations', 'Kenyatta Avenue, House No. 09, Near Ngatha Nursing Home', 'https://ujuzi.co.ke', '/uploads/logos/user-e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6-1785330124775-174721386.png', '#6500ff', 'EUR', '€', 'Euro', '+254741238738', NULL, 'hello@ujuzicreations.co.ke', '$2b$10$GCoEpneWYtQTJwFvOMh6S.s1kBJUkOn7jncUXte5LAGhfgwpRBVVO', 626, '2025-06-20 01:31:23', NULL, NULL, '/uploads/signatures/signature-e5f7a98f-02dd-4fbe-b09c-c853c7d9aab6-1785329284736.png', 1),
('e79e5915-b271-4a91-97ad-50ca1419419f', 'wycliffe kendo', 'kendox construction ltd', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254707578773', NULL, 'wycliffekendo@gmail.com', '$2b$10$EfJMm6OIf8p3JsrJwo1XIOMXccUaFg1Uw3nIEZOdZSVKdT3/CJIHm', 24, '2025-10-14 12:03:32', NULL, NULL, NULL, 0),
('e8a4b7b7-cb78-45db-847a-7e8ac8f407b9', 'Johh', 'Joe outfits ', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254741669499', NULL, 'johh39684@gmail.com', '$2b$10$fdOULvbl4QnhCrvb3oNQueD4acGbL3umxZG8ug6zedSkTotEZV5oy', 9, '2025-06-24 12:26:36', NULL, NULL, NULL, 0),
('f522b088-d6c4-47f7-abaf-644535ce8b88', 'Faith Muthoni', 'Capstone ltd', NULL, NULL, NULL, '#0d9488', 'KES', 'KSh', 'Kenyan Shilling', '+254708324918', NULL, 'faithmuthonic940@gmail.com', '$2b$10$9ZFrODbbBdzEzNJuj5C7.eV9CfC1Xv5X40bVDhWyRi86c4iQtTW1u', 4, '2025-07-15 08:29:36', NULL, NULL, NULL, 0);

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
