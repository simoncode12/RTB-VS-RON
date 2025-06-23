-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Waktu pembuatan: 24 Jun 2025 pada 05.03
-- Versi server: 11.4.5-MariaDB-deb11
-- Versi PHP: 8.3.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `user_up`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `advertisers`
--

CREATE TABLE `advertisers` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `balance` decimal(10,2) DEFAULT 0.00,
  `status` enum('active','inactive','pending') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data untuk tabel `advertisers`
--

INSERT INTO `advertisers` (`id`, `name`, `email`, `website`, `contact_person`, `phone`, `balance`, `status`, `created_at`, `updated_at`, `notes`) VALUES
(1, 'Adsteer', 'support@adsteer.com', 'https://adsteer.com', 'Simon Adsteer', '082281671244', 0.00, 'active', '2025-06-23 05:56:53', '2025-06-23 05:56:53', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `bid_logs`
--

CREATE TABLE `bid_logs` (
  `id` int(11) NOT NULL,
  `request_id` varchar(100) NOT NULL,
  `campaign_id` int(11) DEFAULT NULL,
  `creative_id` int(11) DEFAULT NULL,
  `zone_id` int(11) DEFAULT NULL,
  `bid_amount` decimal(10,4) DEFAULT NULL,
  `win_price` decimal(10,4) DEFAULT NULL,
  `impression_id` varchar(100) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `country` varchar(3) DEFAULT NULL,
  `device_type` varchar(50) DEFAULT NULL,
  `browser` varchar(50) DEFAULT NULL,
  `os` varchar(50) DEFAULT NULL,
  `status` enum('bid','win','loss','click') DEFAULT 'bid',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data untuk tabel `bid_logs`
--

INSERT INTO `bid_logs` (`id`, `request_id`, `campaign_id`, `creative_id`, `zone_id`, `bid_amount`, `win_price`, `impression_id`, `user_agent`, `ip_address`, `country`, `device_type`, `browser`, `os`, `status`, `created_at`) VALUES
(3, 'bid_6859abb718049', 6, 1, NULL, 0.0094, 0.0094, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'win', '2025-06-23 19:41:02'),
(4, 'req_6859afd28b9e0', 6, 1, 1, 0.0094, 0.0094, 'imp_6859afd28b9e2', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:49:38'),
(5, 'req_6859afdaef5fc', 6, 1, 1, 0.0094, 0.0094, 'imp_6859afdaef5fd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:49:46'),
(6, 'req_6859afdc10609', 6, 1, 1, 0.0094, 0.0094, 'imp_6859afdc1060b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:49:48'),
(7, 'req_6859aff082983', 6, 1, 1, 0.0094, 0.0094, 'imp_6859aff082984', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:50:08'),
(8, 'req_6859aff3486c5', 6, 1, 1, 0.0094, 0.0094, 'imp_6859aff3486c6', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:50:11'),
(9, 'req_6859afff0fc75', 6, 1, 1, 0.0094, 0.0094, 'imp_6859afff0fc77', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:50:23'),
(10, 'req_6859b004ac580', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b004ac582', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:50:28'),
(11, 'req_6859b007a1b59', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b007a1b5b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:50:31'),
(12, 'req_6859b00f7bea5', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b00f7bea6', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:50:39'),
(13, 'req_6859b0324ee65', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b0324ee68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:51:14'),
(14, 'req_6859b0563d20f', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b0563d210', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:51:50'),
(15, 'req_6859b092ee56e', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b092ee56f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:52:50'),
(16, 'req_6859b0942be5a', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b0942be5b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:52:52'),
(17, 'req_6859b0b0e1ca3', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b0b0e1ca4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:53:20'),
(18, 'req_6859b2217ee4a', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b2217ee4b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:59:29'),
(19, 'req_6859b22bd375b', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b22bd375c', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:59:39'),
(20, 'req_6859b23c0b8c3', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b23c0b8c5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 19:59:56'),
(21, 'req_6859b259e2827', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b259e2829', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:00:25'),
(22, 'req_6859b2af1858a', 6, 2, 1, 0.0094, 0.0094, 'imp_6859b2af1858b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:01:51'),
(23, 'req_6859b2af41db3', 6, 2, 1, 0.0094, 0.0094, 'imp_6859b2af41db4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:01:51'),
(24, 'req_6859b2c321524', 6, 2, 1, 0.0094, 0.0094, 'imp_6859b2c321525', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:02:11'),
(25, 'req_6859b2c322c85', 6, 2, 1, 0.0094, 0.0094, 'imp_6859b2c322c86', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:02:11'),
(26, 'req_6859b2cea4532', 6, 2, 1, 0.0094, 0.0094, 'imp_6859b2cea4534', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:02:22'),
(27, 'req_6859b2cea8bb2', 6, 2, 1, 0.0094, 0.0094, 'imp_6859b2cea8bb3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:02:22'),
(28, 'req_6859b2d3b5097', 6, 2, 1, 0.0094, 0.0094, 'imp_6859b2d3b5098', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:02:27'),
(29, 'req_6859b2d3b7e1e', 6, 2, 1, 0.0094, 0.0094, 'imp_6859b2d3b7e20', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:02:27'),
(30, 'req_6859b2ef2fafe', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b2ef2fb01', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:02:55'),
(31, 'req_6859b2ef31285', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b2ef3129f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:02:55'),
(32, 'req_6859b2f81ed1a', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b2f81ed1c', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:03:04'),
(33, 'req_6859b2f823184', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b2f823185', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:03:04'),
(34, 'req_6859b305851e3', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b305851e4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:03:17'),
(35, 'req_6859b3997487f', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b39974881', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:05:45'),
(36, 'req_6859b3999ac28', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b3999ac29', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:05:45'),
(37, 'req_6859b3a63ed7a', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b3a63ed7b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:05:58'),
(38, 'req_6859b3a63f4dc', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b3a63f4dd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:05:58'),
(39, 'req_6859b3b222b50', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b3b222b52', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '23.106.56.19', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:06:10'),
(40, 'req_6859b3b2260f8', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b3b2260f9', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '23.106.56.19', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:06:10'),
(41, 'req_6859b3bd22a6f', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b3bd22a70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '23.106.56.19', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:06:21'),
(42, 'req_6859b3bd23b4c', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b3bd23b4e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '23.106.56.19', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:06:21'),
(43, 'req_6859b3d6d3b92', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b3d6d3b94', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '23.106.56.19', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:06:46'),
(44, 'req_6859b3d6d412d', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b3d6d412f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '23.106.56.19', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:06:46'),
(45, 'req_6859b3e09f15d', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b3e09f15f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '23.106.56.19', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:06:56'),
(46, 'req_6859b3e09fc7e', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b3e09fc7f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '23.106.56.19', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:06:56'),
(47, 'req_6859b407c4720', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b407c4721', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:07:35'),
(48, 'req_6859b4097b6f1', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b4097b6f3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:07:37'),
(49, 'req_6859b418499c5', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b418499c6', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:07:52'),
(50, 'req_6859b41875536', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b41875538', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:07:52'),
(51, 'req_6859b428acf5f', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b428acf60', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:08:08'),
(52, 'req_6859b428ae010', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b428ae011', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:08:08'),
(53, 'req_6859b4dbb59a5', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b4dbb59a6', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:11:07'),
(54, 'req_6859b4f573de6', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b4f573de7', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:11:33'),
(55, 'req_6859b4f915610', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b4f915611', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:11:37'),
(56, 'req_6859b5482029c', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b5482029d', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:12:56'),
(57, 'req_6859b5b352e2c', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b5b352e2d', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:14:43'),
(58, 'req_6859b5bb4a73c', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b5bb4a73e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:14:51'),
(59, 'req_6859b63aeacb6', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b63aeacb8', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:16:58'),
(60, 'req_6859b701794af', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b701794b1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:20:17'),
(61, 'req_6859b719930cc', 6, 1, 1, 0.0094, 0.0094, 'imp_6859b719930cd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:20:41'),
(62, '3858ce19-27ae-4363-9f07-920e2a22d629', 6, 4, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:54'),
(63, '06597306-ff4e-44c7-b4fb-9cd4f4281b19', 6, 2, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:54'),
(64, '4c3f30fa-ae73-47ca-830d-2299ad38f1b1', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:54'),
(65, '109f6028-c8ba-4087-8849-bad839106920', 6, 2, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:54'),
(66, '3f0bb77b-637e-45e9-9e93-aab508916775', 6, 1, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '190.2.150.207', 'NLD', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:56:55'),
(67, 'a23ace71-7f84-4d23-8eb0-3780e1f12b0f', 6, 4, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0', '103.211.20.240', 'IND', 'desktop', 'firefox', 'windows', 'win', '2025-06-23 20:56:55'),
(68, 'af927fa9-5182-46cd-a85f-43f27bbd373d', 6, 2, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0', '103.211.20.240', 'IND', 'desktop', 'firefox', 'windows', 'win', '2025-06-23 20:56:55'),
(69, 'f5bfec5c-4405-4fc2-b6b9-93e7dfe64cf5', 6, 2, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 12; vivo 1938) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.118 Mobile Safari/537.36 VivoBrowser/14.0.6.4', '163.171.204.36', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:55'),
(70, '76adb8c9-1d66-4240-a668-494fac7112f6', 6, 2, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0', '103.211.20.240', 'IND', 'desktop', 'firefox', 'windows', 'bid', '2025-06-23 20:56:55'),
(71, 'af9d3db7-b8f5-48fb-9748-1531707b2b4a', 6, 2, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 12; vivo 1938) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/123.0.6312.118 Mobile Safari/537.36 VivoBrowser/14.0.6.4', '163.171.204.36', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:56:55'),
(72, 'e58869c7-75c0-4aa4-af5e-bdd67302b4d2', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', '', 'HUN', 'desktop', 'chrome', 'windows', 'bid', '2025-06-23 20:56:56'),
(73, '506a6732-ab9c-4728-ae96-368e00f74f88', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', '', 'HUN', 'desktop', 'chrome', 'windows', 'bid', '2025-06-23 20:56:56'),
(74, '4545e9fb-15a5-435b-a5ae-2a9f509564bb', 6, 5, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:56:56'),
(75, 'c155b7ef-0acb-4095-b952-8a5630622d72', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:56'),
(76, '2cd57a5e-0704-400e-98a3-0a36551b47b5', 6, 4, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:56:56'),
(77, '7c6b81cf-6282-48ea-bc1c-4d1be4511e59', 6, 2, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:56:56'),
(78, 'c5758cfa-dd8a-4c8b-b70f-71295fea7d1f', 6, 2, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:56:57'),
(79, 'd73ad1fd-bac3-4c94-9a66-d9fa3d8d7b1e', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:57'),
(80, '6db84fd0-481d-4c39-a878-2f5da32f8b0b', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:57'),
(81, '05d02171-7a4d-4786-8a94-875bd69ed2ec', 6, 4, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:56:58'),
(82, 'ac6968a7-1948-47ee-90a0-ee3e65d00c6c', 6, 2, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:58'),
(83, '18492cc2-4d32-40fb-b442-e53f13fe5598', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:58'),
(84, 'a7e05fe0-73d2-45ee-931e-5d53fbcf2b79', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:58'),
(85, '860dec5b-8129-4283-856f-2879089b9ae8', 6, 2, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:58'),
(86, 'af2db415-909c-4775-b116-bde7e9ffce9e', 6, 2, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/137.0.7151.107 Mobile/15E148 Safari/604.1', '', 'IND', 'mobile', 'safari', 'macos', 'bid', '2025-06-23 20:56:58'),
(87, 'a883a856-bd13-4067-bbcf-34050ea6e87e', 6, 1, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/137.0.7151.107 Mobile/15E148 Safari/604.1', '', 'IND', 'mobile', 'safari', 'macos', 'win', '2025-06-23 20:56:58'),
(88, '65b37a06-410b-4ccb-acd8-80e5cc976d93', 6, 2, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/137.0.7151.107 Mobile/15E148 Safari/604.1', '', 'IND', 'mobile', 'safari', 'macos', 'win', '2025-06-23 20:56:58'),
(89, 'e292bf2c-3467-414d-8f8d-3d579b30d3b3', 6, 4, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/137.0.7151.107 Mobile/15E148 Safari/604.1', '', 'IND', 'mobile', 'safari', 'macos', 'bid', '2025-06-23 20:56:58'),
(90, '0bbebb6b-48b9-4546-bc6b-934477e54f1a', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:58'),
(91, '86d711df-dde8-4ab1-9cb9-7d9439c70545', 6, 1, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:56:58'),
(92, 'bb50c70d-66df-462f-b1f0-d067cdfc0f91', 6, 1, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:56:59'),
(93, 'a92e6f11-6ae0-4127-85e2-3a7cc8653ed8', 6, 4, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '86.33.84.171', 'HRV', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:56:59'),
(94, '50a7ccff-44be-4528-b2d7-6701ab8e76cb', 6, 4, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:59'),
(95, '23a620e2-9e9d-48a6-bb49-0fbf46cdbb6a', 6, 2, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:59'),
(96, 'b1034530-d71d-434f-8f76-f298bb33439d', 6, 2, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '86.33.84.171', 'HRV', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:59'),
(97, '3363ffcc-218c-42a5-b4c9-696dcfea1533', 6, 2, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:56:59'),
(98, '6be5e134-aa69-4f92-b770-01930406b999', 6, 7, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:139.0) Gecko/20100101 Firefox/139.0', '80.79.7.125', 'NLD', 'desktop', 'firefox', 'windows', 'win', '2025-06-23 20:56:59'),
(99, '2a942732-cc77-4ed4-a97e-91b6ee9f4bc2', 6, 2, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '86.33.84.171', 'HRV', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:56:59'),
(100, '43c6ea87-3fd8-40b3-85a1-8fe99a8fab91', 6, 4, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 OPT/5.5.4', '91.192.81.221', 'SGP', 'mobile', 'safari', 'macos', 'win', '2025-06-23 20:57:00'),
(101, '61339386-efa3-40bd-b9c1-c447dfb74963', 6, 2, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 OPT/5.5.4', '91.192.81.221', 'SGP', 'mobile', 'safari', 'macos', 'bid', '2025-06-23 20:57:00'),
(102, '7682d783-a85f-46fa-acc6-aab50545315e', 6, 2, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 OPT/5.5.4', '91.192.81.221', 'SGP', 'mobile', 'safari', 'macos', 'win', '2025-06-23 20:57:00'),
(103, '1ae04638-adba-475d-9b7e-497ad6a94682', 6, 1, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1 OPT/5.5.4', '91.192.81.221', 'SGP', 'mobile', 'safari', 'macos', 'win', '2025-06-23 20:57:00'),
(104, '29be4c8c-1b62-4df3-af27-91ed887e57a5', 6, 2, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:57:01'),
(105, 'a9deceb8-616f-4021-a8b3-87b36e01b408', 6, 4, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:57:02'),
(106, '6d2a6d0d-f816-4e13-ad2b-98e3de7a9358', 6, 5, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Mobile Safari/537.36', '113.169.244.249', 'VNM', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:57:02'),
(107, 'c32669a4-8cbc-4a62-81ce-b36e61778272', 6, 4, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:57:02'),
(108, '4efeea2d-ad42-4fdd-b865-be3880be1dc1', 6, 2, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:57:02'),
(109, 'c02f0e78-01c5-4aa8-b7b4-96f96214f25f', 6, 2, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:57:02'),
(110, '2c572cc4-00cb-4212-a77e-14132573fb9a', 6, 2, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:57:02'),
(111, 'e9daf6dd8630c6fecb84dd0fd1887b40-145855-292586', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'IDN', 'desktop', 'chrome', 'windows', 'bid', '2025-06-23 20:57:03'),
(112, 'e58e6c88-0583-42d7-9a71-fbe958f9c273', 6, 7, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '103.169.67.18', 'THA', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:57:04'),
(113, '4f8f1224-e966-4815-ad4d-e15c4d52dba0', 6, 4, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:57:04'),
(114, '4304c1b3-e48f-4206-a915-37b70cbcc4a7', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:57:05'),
(115, 'ce860bb2-7863-4151-8774-6816473e2d32', 6, 2, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:57:05'),
(116, '238d8476-5316-4036-8e4c-463d88a5db28', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:57:05'),
(117, 'be235220-bd06-42bd-ae1c-b5406b2bdaa9', 6, 2, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:57:05'),
(118, '6b49024a-e307-49b4-92aa-cc3b56217787', 6, 2, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36', '', 'USA', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:57:06'),
(119, 'e34ca45f-06dd-4ed5-b349-08bf63b8eb56', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '103.114.211.138', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:57:06'),
(120, '349e143d-b4b3-4791-b0bb-056e0d41bfd8', 6, 4, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '103.114.211.138', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:57:06'),
(121, '671dd648-80d0-4a8a-9845-ba753b9fab79', 6, 2, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '103.114.211.138', 'IND', 'mobile', 'chrome', 'linux', 'bid', '2025-06-23 20:57:06'),
(122, '050a4302-1336-4c74-8d9d-0cfa2c60fbba', 6, 2, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36', '103.114.211.138', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:57:06'),
(123, '055dd9d8-17ba-4e91-9f82-30835fadbfa3', 6, 1, NULL, 0.0094, 0.0094, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Mobile Safari/537.36', '', 'IND', 'mobile', 'chrome', 'linux', 'win', '2025-06-23 20:57:06'),
(124, 'req_6859bfad779a7', 6, 1, 1, 0.0094, 0.0094, 'imp_6859bfad779a8', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 20:57:17'),
(125, '5148b9d8e19f2805a9e1026a7b42424a-145855-292586', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'IDN', 'desktop', 'chrome', 'windows', 'bid', '2025-06-23 20:58:05'),
(126, '765f47d26227083172208128fd6ff442-145855-292586', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'IDN', 'desktop', 'chrome', 'windows', 'bid', '2025-06-23 20:58:12'),
(127, '8897bf0cc58473c7413ca98efaba1ee3-145855-292586', 6, 1, NULL, 0.0094, NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'IDN', 'desktop', 'chrome', 'windows', 'bid', '2025-06-23 20:58:25'),
(128, 'req_6859c0500f4ab', 6, 1, 1, 0.0094, 0.0094, 'imp_6859c0500f4ac', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 21:00:00'),
(129, 'req_6859c1f6b519e', 6, 1, 1, 0.0094, 0.0094, 'imp_6859c1f6b519f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 21:07:02'),
(130, 'req_6859c376bdc38', 6, 1, 1, 0.0010, 0.0010, 'imp_6859c376bdc39', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 21:13:26'),
(131, 'req_6859c3841161f', 6, 1, 1, 0.0010, 0.0010, 'imp_6859c38411620', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 21:13:40'),
(132, 'req_6859c393758b7', 6, 1, 1, 0.0010, 0.0010, 'imp_6859c393758b9', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 21:13:55'),
(133, 'req_6859c3ae95339', 6, 1, 1, 0.0010, 0.0010, 'imp_6859c3ae9533b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 21:14:22'),
(134, 'req_6859c47b04995', 6, 1, 1, 0.0010, 0.0010, 'imp_6859c47b04996', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 21:17:47'),
(135, 'req_6859c47fe83be', 6, 1, 1, 0.0010, 0.0010, 'imp_6859c47fe83c0', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', 'Desktop', 'Chrome', 'Windows', 'win', '2025-06-23 21:17:52'),
(136, 'e7a9b31f61978d28674558f6c52d500e-145855-292586', 6, 1, NULL, 0.0010, NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'IDN', 'desktop', 'chrome', 'windows', 'bid', '2025-06-23 21:25:12'),
(137, 'req_6859c9dfc4715', 6, 1, 1, 0.0010, 0.0010, 'imp_6859c9dfc4716', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '110.137.38.70', 'US', '', '', '', 'win', '2025-06-23 21:40:47');

-- --------------------------------------------------------

--
-- Struktur dari tabel `campaigns`
--

CREATE TABLE `campaigns` (
  `id` int(11) NOT NULL,
  `advertiser_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `type` enum('rtb','ron') NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `bid_type` enum('cpm','cpc') DEFAULT 'cpm',
  `daily_budget` decimal(10,2) DEFAULT NULL,
  `total_budget` decimal(10,2) DEFAULT NULL,
  `daily_spent` decimal(10,2) DEFAULT 0.00,
  `total_spent` decimal(10,2) DEFAULT 0.00,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('active','paused','completed','pending') DEFAULT 'active',
  `endpoint_url` varchar(500) DEFAULT NULL,
  `target_countries` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`target_countries`)),
  `target_browsers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`target_browsers`)),
  `target_devices` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`target_devices`)),
  `target_os` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`target_os`)),
  `banner_sizes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`banner_sizes`)),
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data untuk tabel `campaigns`
--

INSERT INTO `campaigns` (`id`, `advertiser_id`, `name`, `type`, `category_id`, `bid_type`, `daily_budget`, `total_budget`, `daily_spent`, `total_spent`, `start_date`, `end_date`, `status`, `endpoint_url`, `target_countries`, `target_browsers`, `target_devices`, `target_os`, `banner_sizes`, `created_at`, `updated_at`) VALUES
(5, 1, 'Banner 1', 'rtb', 1, 'cpm', 1000.00, 20000.00, 0.00, 0.00, '2025-06-23', '3000-07-23', 'active', 'http://rtb.exoclick.com/rtb.php?idzone=5128252&fid=e573a1c2a656509b0112f7213359757be76929c7', NULL, NULL, NULL, NULL, '[\"300x250\",\"728x90\",\"160x600\",\"320x50\",\"300x600\",\"336x280\"]', '2025-06-23 06:19:07', '2025-06-23 06:19:07'),
(6, 1, 'Banner ron', 'ron', 1, 'cpm', 1000.00, 20000.00, 0.00, 0.00, '2025-06-23', '3000-07-23', 'paused', NULL, NULL, NULL, NULL, NULL, '[\"300x250\",\"728x90\",\"160x600\",\"320x50\",\"300x600\",\"336x280\"]', '2025-06-23 06:24:48', '2025-06-23 21:40:58');

-- --------------------------------------------------------

--
-- Struktur dari tabel `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `type` enum('adult','mainstream') DEFAULT 'mainstream',
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data untuk tabel `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`, `type`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Adult', 'Adult content category', 'adult', 'active', '2025-06-23 05:51:05', '2025-06-23 05:51:05'),
(2, 'Mainstream', 'General mainstream content', 'mainstream', 'active', '2025-06-23 05:51:05', '2025-06-23 05:51:05'),
(3, 'Technology', 'Technology and software', 'mainstream', 'active', '2025-06-23 05:51:05', '2025-06-23 05:51:05'),
(4, 'Entertainment', 'Entertainment and media', 'mainstream', 'active', '2025-06-23 05:51:05', '2025-06-23 05:51:05'),
(5, 'Finance', 'Financial services', 'mainstream', 'active', '2025-06-23 05:51:05', '2025-06-23 05:51:05'),
(6, 'Health', 'Health and wellness', 'mainstream', 'active', '2025-06-23 05:51:05', '2025-06-23 05:51:05'),
(7, 'Education', 'Education and learning resources', 'mainstream', 'active', '2025-06-23 05:51:05', '2025-06-23 05:51:05'),
(8, 'E-commerce', 'Online shopping and retail', 'mainstream', 'active', '2025-06-23 05:51:05', '2025-06-23 05:51:05');

-- --------------------------------------------------------

--
-- Struktur dari tabel `creatives`
--

CREATE TABLE `creatives` (
  `id` int(11) NOT NULL,
  `campaign_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `bid_amount` decimal(10,4) NOT NULL,
  `creative_type` enum('html5','image','video','third_party') DEFAULT 'image',
  `image_url` varchar(500) DEFAULT NULL,
  `video_url` varchar(500) DEFAULT NULL,
  `html_content` text DEFAULT NULL,
  `click_url` varchar(500) NOT NULL,
  `status` enum('active','inactive','pending','rejected') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data untuk tabel `creatives`
--

INSERT INTO `creatives` (`id`, `campaign_id`, `name`, `width`, `height`, `bid_amount`, `creative_type`, `image_url`, `video_url`, `html_content`, `click_url`, `status`, `created_at`, `updated_at`) VALUES
(1, 6, '300x250 ', 300, 250, 0.0010, 'html5', '', '', '<iframe src=\"//tanxxx.com/ads/vast.html\" frameborder=\"0\" width=\"100%\" height=\"100%\" scrolling=\"no\"></iframe>\n', 'https://adstart.click/', 'active', '2025-06-23 06:25:15', '2025-06-23 21:17:40'),
(2, 6, '728x90', 728, 90, 0.0010, 'html5', '', '', '<iframe src=\"//tanxxx.com/ads/vast.html\" frameborder=\"0\" width=\"100%\" height=\"100%\" scrolling=\"no\"></iframe>\n', 'https://t.ancdu.link/225680/3788/0?bo=3471,3472,3473,3474,3475&po=6456&aff_sub5=SF_006OG000004lmDN', 'active', '2025-06-23 18:55:32', '2025-06-23 21:17:02'),
(3, 6, '300x100', 300, 100, 0.0010, 'html5', '', '', '<iframe src=\"//tanxxx.com/ads/vast.html\" frameborder=\"0\" width=\"100%\" height=\"100%\" scrolling=\"no\"></iframe>\n', 'https://t.ancdu.link/225680/3788/0?bo=3471,3472,3473,3474,3475&po=6456&aff_sub5=SF_006OG000004lmDN', 'active', '2025-06-23 18:56:30', '2025-06-23 21:17:09'),
(4, 6, '300x50', 300, 50, 0.0010, 'html5', '', '', '<iframe src=\"//tanxxx.com/ads/vast.html\" frameborder=\"0\" width=\"100%\" height=\"100%\" scrolling=\"no\"></iframe>\n', 'https://t.ancdu.link/225680/3788/0?bo=3471,3472,3473,3474,3475&po=6456&aff_sub5=SF_006OG000004lmDN', 'active', '2025-06-23 18:57:10', '2025-06-23 21:17:34'),
(5, 6, '300x500', 300, 500, 0.0010, 'html5', '', '', '<iframe src=\"//tanxxx.com/ads/vast.html\" frameborder=\"0\" width=\"100%\" height=\"100%\" scrolling=\"no\"></iframe>\n', 'https://t.ancdu.link/225680/3788/0?bo=3471,3472,3473,3474,3475&po=6456&aff_sub5=SF_006OG000004lmDN', 'active', '2025-06-23 18:57:57', '2025-06-23 21:17:27'),
(6, 6, '900x250', 900, 250, 0.0010, 'html5', '', '', '<iframe src=\"//tanxxx.com/ads/vast.html\" frameborder=\"0\" width=\"100%\" height=\"100%\" scrolling=\"no\"></iframe>\n', 'https://t.ancdu.link/225680/3788/0?bo=3471,3472,3473,3474,3475&po=6456&aff_sub5=SF_006OG000004lmDN', 'active', '2025-06-23 18:58:36', '2025-06-23 21:17:21'),
(7, 6, '160x600', 160, 600, 0.0010, 'html5', '', '', '<iframe src=\"//tanxxx.com/ads/vast.html\" frameborder=\"0\" width=\"100%\" height=\"100%\" scrolling=\"no\"></iframe>\n', 'https://t.ancdu.link/225680/3788/0?bo=3471,3472,3473,3474,3475&po=6456&aff_sub5=SF_006OG000004lmDN', 'active', '2025-06-23 18:59:17', '2025-06-23 21:17:14');

-- --------------------------------------------------------

--
-- Struktur dari tabel `daily_statistics`
--

CREATE TABLE `daily_statistics` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `total_impressions` int(11) DEFAULT 0,
  `total_clicks` int(11) DEFAULT 0,
  `total_revenue` decimal(10,4) DEFAULT 0.0000,
  `publisher_revenue` decimal(10,4) DEFAULT 0.0000,
  `platform_revenue` decimal(10,4) DEFAULT 0.0000,
  `rtb_impressions` int(11) DEFAULT 0,
  `ron_impressions` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data untuk tabel `daily_statistics`
--

INSERT INTO `daily_statistics` (`id`, `date`, `total_impressions`, `total_clicks`, `total_revenue`, `publisher_revenue`, `platform_revenue`, `rtb_impressions`, `ron_impressions`, `created_at`, `updated_at`) VALUES
(9, '2025-06-23', 58, 0, 0.4864, 0.2432, 0.2432, 0, 58, '2025-06-23 19:50:08', '2025-06-23 21:40:48');

-- --------------------------------------------------------

--
-- Struktur dari tabel `publishers`
--

CREATE TABLE `publishers` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `revenue_share` decimal(5,2) DEFAULT 50.00,
  `payment_method` enum('paypal','bank_transfer','wire') DEFAULT 'paypal',
  `payment_details` text DEFAULT NULL,
  `status` enum('active','inactive','pending') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data untuk tabel `publishers`
--

INSERT INTO `publishers` (`id`, `name`, `email`, `website`, `contact_person`, `revenue_share`, `payment_method`, `payment_details`, `status`, `created_at`, `updated_at`, `notes`) VALUES
(1, 'Simon Adsteer', 'webpublhiser@gmail.com', 'https://www.hornylust.com', 'Simon Adsteer', 50.00, 'paypal', 'webpublhiser@gmail.com', 'active', '2025-06-23 05:57:31', '2025-06-23 05:57:31', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `publisher_payments`
--

CREATE TABLE `publisher_payments` (
  `id` int(11) NOT NULL,
  `publisher_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) NOT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `status` enum('pending','processing','completed','failed') DEFAULT 'completed',
  `processed_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `revenue_tracking`
--

CREATE TABLE `revenue_tracking` (
  `id` int(11) NOT NULL,
  `publisher_id` int(11) DEFAULT NULL,
  `campaign_id` int(11) DEFAULT NULL,
  `zone_id` int(11) DEFAULT NULL,
  `impressions` int(11) DEFAULT 0,
  `clicks` int(11) DEFAULT 0,
  `revenue` decimal(10,4) DEFAULT 0.0000,
  `publisher_revenue` decimal(10,4) DEFAULT 0.0000,
  `date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data untuk tabel `revenue_tracking`
--

INSERT INTO `revenue_tracking` (`id`, `publisher_id`, `campaign_id`, `zone_id`, `impressions`, `clicks`, `revenue`, `publisher_revenue`, `date`, `created_at`, `updated_at`) VALUES
(1, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 19:38:59', '2025-06-23 19:38:59'),
(2, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 19:41:02', '2025-06-23 19:41:02'),
(3, 1, 6, 1, 58, 0, 0.4864, 0.2432, '2025-06-23', '2025-06-23 19:50:08', '2025-06-23 21:40:48'),
(51, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:55', '2025-06-23 20:56:55'),
(52, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:55', '2025-06-23 20:56:55'),
(53, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:55', '2025-06-23 20:56:55'),
(54, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:55', '2025-06-23 20:56:55'),
(55, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:56', '2025-06-23 20:56:56'),
(56, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:56', '2025-06-23 20:56:56'),
(57, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:56', '2025-06-23 20:56:56'),
(58, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:56', '2025-06-23 20:56:56'),
(59, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:57', '2025-06-23 20:56:57'),
(60, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:57', '2025-06-23 20:56:57'),
(61, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:57', '2025-06-23 20:56:57'),
(62, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:57', '2025-06-23 20:56:57'),
(63, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:57', '2025-06-23 20:56:57'),
(64, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:58', '2025-06-23 20:56:58'),
(65, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:58', '2025-06-23 20:56:58'),
(66, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(67, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(68, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(69, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(70, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(71, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(72, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(73, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(74, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(75, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(76, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(77, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(78, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(79, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(80, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(81, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:56:59', '2025-06-23 20:56:59'),
(82, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:00', '2025-06-23 20:57:00'),
(83, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:00', '2025-06-23 20:57:00'),
(84, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:00', '2025-06-23 20:57:00'),
(85, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:00', '2025-06-23 20:57:00'),
(86, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:01', '2025-06-23 20:57:01'),
(87, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:01', '2025-06-23 20:57:01'),
(88, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:01', '2025-06-23 20:57:01'),
(89, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:01', '2025-06-23 20:57:01'),
(90, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:01', '2025-06-23 20:57:01'),
(91, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:02', '2025-06-23 20:57:02'),
(92, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:03', '2025-06-23 20:57:03'),
(93, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:03', '2025-06-23 20:57:03'),
(94, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:03', '2025-06-23 20:57:03'),
(95, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:03', '2025-06-23 20:57:03'),
(96, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:05', '2025-06-23 20:57:05'),
(97, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:05', '2025-06-23 20:57:05'),
(98, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:05', '2025-06-23 20:57:05'),
(99, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:06', '2025-06-23 20:57:06'),
(100, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:06', '2025-06-23 20:57:06'),
(101, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:06', '2025-06-23 20:57:06'),
(102, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:06', '2025-06-23 20:57:06'),
(103, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:06', '2025-06-23 20:57:06'),
(104, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 20:57:07', '2025-06-23 20:57:07');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `role` enum('admin','manager','operator') DEFAULT 'admin',
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `full_name`, `role`, `status`, `created_at`, `updated_at`) VALUES
(1, 'admin', '$2y$10$X/37NEJw4CSNZwILZIisyu73foqUSWWs.p/eXFU2qZZ3pqBYBrOHa', 'admin@adstart.click', 'System Administrator', 'admin', 'active', '2025-06-23 05:51:05', '2025-06-23 05:51:50'),
(2, 'simoncode12', '$2y$10$l7/UrTltNTAJBDWE0Uh99u7FJZ.59kuYD9DSkikCi6Pr1DNXvk.8u', 'simon@adstart.click', 'Simon Developer', 'admin', 'active', '2025-06-23 05:51:05', '2025-06-23 05:56:08');

-- --------------------------------------------------------

--
-- Struktur dari tabel `user_activity`
--

CREATE TABLE `user_activity` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` varchar(50) NOT NULL,
  `entity_type` varchar(50) NOT NULL,
  `entity_id` varchar(50) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data untuk tabel `user_activity`
--

INSERT INTO `user_activity` (`id`, `user_id`, `action`, `entity_type`, `entity_id`, `ip_address`, `details`, `created_at`) VALUES
(1, 2, 'view', 'dashboard', '0', '127.0.0.1', 'User viewed dashboard', '2025-06-23 05:48:52'),
(2, 2, 'login', 'session', 'rt014q3toh0t2ps72i2rqgt1p0', '110.137.38.70', 'User logged in successfully', '2025-06-23 05:55:05'),
(3, 2, 'view', 'profile', '2', '110.137.38.70', NULL, '2025-06-23 05:55:21'),
(4, 2, 'view', 'profile', '2', '110.137.38.70', NULL, '2025-06-23 05:56:08'),
(5, 2, 'logout', 'session', 'rt014q3toh0t2ps72i2rqgt1p0', '110.137.38.70', 'User logged out successfully', '2025-06-23 05:56:16'),
(6, 2, 'login', 'session', '6tui154roeba0u4ncrp7nud7bl', '110.137.38.70', 'User logged in successfully', '2025-06-23 05:56:19'),
(7, 2, 'create', 'campaign', '1', '110.137.38.70', 'Created RTB campaign: Banner ', '2025-06-23 06:03:23'),
(8, 2, 'create', 'campaign', '2', '110.137.38.70', 'Created RTB campaign: Banner 1', '2025-06-23 06:11:02'),
(9, 2, 'create', 'campaign', '3', '110.137.38.70', 'Created RTB campaign: Banner 1', '2025-06-23 06:14:07'),
(10, 2, 'create', 'campaign', '4', '110.137.38.70', 'Created RTB campaign: Banner 1', '2025-06-23 06:17:44'),
(11, 2, 'create', 'campaign', '5', '110.137.38.70', 'Created RTB campaign: Banner 1', '2025-06-23 06:19:07'),
(12, 2, 'create', 'campaign', '6', '110.137.38.70', 'Created RON campaign: Banner ron', '2025-06-23 06:24:48'),
(13, 2, 'login', 'session', 'i5fackgh169emgds2u7e17kgf2', '114.79.3.233', 'User logged in successfully', '2025-06-23 11:02:00'),
(14, 2, 'update', 'zone', '1', '110.137.38.70', 'Updated zone status to inactive: Banner ', '2025-06-23 19:25:18'),
(15, 2, 'update', 'zone', '1', '110.137.38.70', 'Updated zone status to active: Banner ', '2025-06-23 19:25:20'),
(16, 2, 'update', 'zone', '1', '110.137.38.70', 'Updated zone status to inactive: Banner ', '2025-06-23 19:25:58'),
(17, 2, 'update', 'zone', '1', '110.137.38.70', 'Updated zone status to active: Banner ', '2025-06-23 19:30:32'),
(18, 2, 'update', 'zone', '1', '110.137.38.70', 'Updated zone status to inactive: Banner ', '2025-06-23 19:30:36'),
(19, 2, 'update', 'zone', '1', '110.137.38.70', 'Updated zone status to active: Banner ', '2025-06-23 19:30:39'),
(20, 2, 'update', 'zone', '1', '110.137.38.70', 'Updated zone status to inactive: Banner ', '2025-06-23 19:30:41');

-- --------------------------------------------------------

--
-- Struktur dari tabel `user_logins`
--

CREATE TABLE `user_logins` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `action` enum('login','logout','failed') NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `status` enum('success','failed') NOT NULL DEFAULT 'success',
  `login_time` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data untuk tabel `user_logins`
--

INSERT INTO `user_logins` (`id`, `user_id`, `username`, `action`, `ip_address`, `user_agent`, `status`, `login_time`) VALUES
(1, 2, 'simoncode12', 'login', '127.0.0.1', NULL, 'success', '2025-06-23 05:48:52'),
(11, 2, 'simoncode12', 'login', '110.137.38.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'success', '2025-06-23 05:55:05'),
(12, 2, 'simoncode12', 'logout', '110.137.38.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'success', '2025-06-23 05:56:16'),
(13, 2, 'simoncode12', 'login', '110.137.38.70', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'success', '2025-06-23 05:56:19'),
(14, 2, 'simoncode12', 'login', '114.79.3.233', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'success', '2025-06-23 11:02:00');

-- --------------------------------------------------------

--
-- Struktur dari tabel `websites`
--

CREATE TABLE `websites` (
  `id` int(11) NOT NULL,
  `publisher_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` enum('active','inactive','pending') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data untuk tabel `websites`
--

INSERT INTO `websites` (`id`, `publisher_id`, `name`, `domain`, `category_id`, `description`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 'xthube', 'xthube.com', 1, '', 'active', '2025-06-23 05:58:06', '2025-06-23 05:58:10');

-- --------------------------------------------------------

--
-- Struktur dari tabel `zones`
--

CREATE TABLE `zones` (
  `id` int(11) NOT NULL,
  `website_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `size` varchar(20) NOT NULL,
  `zone_type` enum('banner','video','native') DEFAULT 'banner',
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data untuk tabel `zones`
--

INSERT INTO `zones` (`id`, `website_id`, `name`, `size`, `zone_type`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 'Banner ', '300x250', 'banner', 'active', '2025-06-23 06:22:13', '2025-06-23 19:30:51');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `advertisers`
--
ALTER TABLE `advertisers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `status` (`status`);

--
-- Indeks untuk tabel `bid_logs`
--
ALTER TABLE `bid_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `creative_id` (`creative_id`),
  ADD KEY `idx_request_id` (`request_id`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_campaign_creative` (`campaign_id`,`creative_id`),
  ADD KEY `idx_zone` (`zone_id`);

--
-- Indeks untuk tabel `campaigns`
--
ALTER TABLE `campaigns`
  ADD PRIMARY KEY (`id`),
  ADD KEY `advertiser_id` (`advertiser_id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `type` (`type`),
  ADD KEY `status` (`status`),
  ADD KEY `start_date` (`start_date`),
  ADD KEY `end_date` (`end_date`),
  ADD KEY `idx_daily_budget_spent` (`daily_budget`,`daily_spent`),
  ADD KEY `idx_total_budget_spent` (`total_budget`,`total_spent`);

--
-- Indeks untuk tabel `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `type` (`type`),
  ADD KEY `status` (`status`);

--
-- Indeks untuk tabel `creatives`
--
ALTER TABLE `creatives`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campaign_id` (`campaign_id`),
  ADD KEY `width` (`width`,`height`),
  ADD KEY `status` (`status`);

--
-- Indeks untuk tabel `daily_statistics`
--
ALTER TABLE `daily_statistics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_date` (`date`),
  ADD KEY `idx_date` (`date`);

--
-- Indeks untuk tabel `publishers`
--
ALTER TABLE `publishers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `status` (`status`);

--
-- Indeks untuk tabel `publisher_payments`
--
ALTER TABLE `publisher_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `publisher_id` (`publisher_id`),
  ADD KEY `status` (`status`),
  ADD KEY `period_dates` (`period_start`,`period_end`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_publisher_period` (`publisher_id`,`period_start`,`period_end`);

--
-- Indeks untuk tabel `revenue_tracking`
--
ALTER TABLE `revenue_tracking`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_daily_revenue` (`publisher_id`,`campaign_id`,`zone_id`,`date`),
  ADD KEY `zone_id` (`zone_id`),
  ADD KEY `idx_date` (`date`),
  ADD KEY `idx_publisher_date` (`publisher_id`,`date`),
  ADD KEY `idx_campaign_date` (`campaign_id`,`date`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indeks untuk tabel `user_activity`
--
ALTER TABLE `user_activity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `created_at` (`created_at`);

--
-- Indeks untuk tabel `user_logins`
--
ALTER TABLE `user_logins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `login_time` (`login_time`);

--
-- Indeks untuk tabel `websites`
--
ALTER TABLE `websites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `publisher_id` (`publisher_id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `status` (`status`),
  ADD KEY `domain` (`domain`);

--
-- Indeks untuk tabel `zones`
--
ALTER TABLE `zones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `website_id` (`website_id`),
  ADD KEY `size` (`size`),
  ADD KEY `status` (`status`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `advertisers`
--
ALTER TABLE `advertisers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `bid_logs`
--
ALTER TABLE `bid_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=138;

--
-- AUTO_INCREMENT untuk tabel `campaigns`
--
ALTER TABLE `campaigns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `creatives`
--
ALTER TABLE `creatives`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `daily_statistics`
--
ALTER TABLE `daily_statistics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT untuk tabel `publishers`
--
ALTER TABLE `publishers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `publisher_payments`
--
ALTER TABLE `publisher_payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `revenue_tracking`
--
ALTER TABLE `revenue_tracking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=115;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `user_activity`
--
ALTER TABLE `user_activity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `user_logins`
--
ALTER TABLE `user_logins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT untuk tabel `websites`
--
ALTER TABLE `websites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `zones`
--
ALTER TABLE `zones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `bid_logs`
--
ALTER TABLE `bid_logs`
  ADD CONSTRAINT `bid_logs_ibfk_1` FOREIGN KEY (`campaign_id`) REFERENCES `campaigns` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `bid_logs_ibfk_2` FOREIGN KEY (`creative_id`) REFERENCES `creatives` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `bid_logs_ibfk_3` FOREIGN KEY (`zone_id`) REFERENCES `zones` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `campaigns`
--
ALTER TABLE `campaigns`
  ADD CONSTRAINT `campaigns_ibfk_1` FOREIGN KEY (`advertiser_id`) REFERENCES `advertisers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `campaigns_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `creatives`
--
ALTER TABLE `creatives`
  ADD CONSTRAINT `creatives_ibfk_1` FOREIGN KEY (`campaign_id`) REFERENCES `campaigns` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `publisher_payments`
--
ALTER TABLE `publisher_payments`
  ADD CONSTRAINT `publisher_payments_ibfk_1` FOREIGN KEY (`publisher_id`) REFERENCES `publishers` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `revenue_tracking`
--
ALTER TABLE `revenue_tracking`
  ADD CONSTRAINT `revenue_tracking_ibfk_1` FOREIGN KEY (`publisher_id`) REFERENCES `publishers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `revenue_tracking_ibfk_2` FOREIGN KEY (`campaign_id`) REFERENCES `campaigns` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `revenue_tracking_ibfk_3` FOREIGN KEY (`zone_id`) REFERENCES `zones` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `user_activity`
--
ALTER TABLE `user_activity`
  ADD CONSTRAINT `user_activity_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `user_logins`
--
ALTER TABLE `user_logins`
  ADD CONSTRAINT `user_logins_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `websites`
--
ALTER TABLE `websites`
  ADD CONSTRAINT `websites_ibfk_1` FOREIGN KEY (`publisher_id`) REFERENCES `publishers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `websites_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `zones`
--
ALTER TABLE `zones`
  ADD CONSTRAINT `zones_ibfk_1` FOREIGN KEY (`website_id`) REFERENCES `websites` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
