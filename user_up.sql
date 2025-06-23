-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Waktu pembuatan: 24 Jun 2025 pada 02.39
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

INSERT INTO `campaigns` (`id`, `advertiser_id`, `name`, `type`, `category_id`, `bid_type`, `daily_budget`, `total_budget`, `start_date`, `end_date`, `status`, `endpoint_url`, `target_countries`, `target_browsers`, `target_devices`, `target_os`, `banner_sizes`, `created_at`, `updated_at`) VALUES
(5, 1, 'Banner 1', 'rtb', 1, 'cpm', 1000.00, 20000.00, '2025-06-23', '3000-07-23', 'active', 'http://rtb.exoclick.com/rtb.php?idzone=5128252&fid=e573a1c2a656509b0112f7213359757be76929c7', NULL, NULL, NULL, NULL, '[\"300x250\",\"728x90\",\"160x600\",\"320x50\",\"300x600\",\"336x280\"]', '2025-06-23 06:19:07', '2025-06-23 06:19:07'),
(6, 1, 'Banner ron', 'ron', 1, 'cpm', 1000.00, 20000.00, '2025-06-23', '3000-07-23', 'active', NULL, NULL, NULL, NULL, NULL, '[\"300x250\",\"728x90\",\"160x600\",\"320x50\",\"300x600\",\"336x280\"]', '2025-06-23 06:24:48', '2025-06-23 06:24:48');

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
(1, 6, '300x250 ', 300, 250, 0.0094, 'html5', '', '', '<script async type=\"application/javascript\" src=\"https://a.magsrv.com/ad-provider.js\"></script> \r\n <ins class=\"eas6a97888e2\" data-zoneid=\"5548370\"></ins> \r\n <script>(AdProvider = window.AdProvider || []).push({\"serve\": {}});</script>', 'https://adstart.click/', 'active', '2025-06-23 06:25:15', '2025-06-23 19:13:52'),
(2, 6, '728x90', 728, 90, 0.0094, 'html5', '', '', '<script async type=\"application/javascript\" src=\"https://a.magsrv.com/ad-provider.js\"></script> \r\n <ins class=\"eas6a97888e2\" data-zoneid=\"5548372\"></ins> \r\n <script>(AdProvider = window.AdProvider || []).push({\"serve\": {}});</script>', 'https://t.ancdu.link/225680/3788/0?bo=3471,3472,3473,3474,3475&po=6456&aff_sub5=SF_006OG000004lmDN', 'active', '2025-06-23 18:55:32', '2025-06-23 19:13:58'),
(3, 6, '300x100', 300, 100, 0.0094, 'html5', '', '', '<script async type=\"application/javascript\" src=\"https://a.magsrv.com/ad-provider.js\"></script> \r\n <ins class=\"eas6a97888e10\" data-zoneid=\"5548388\"></ins> \r\n <script>(AdProvider = window.AdProvider || []).push({\"serve\": {}});</script>', 'https://t.ancdu.link/225680/3788/0?bo=3471,3472,3473,3474,3475&po=6456&aff_sub5=SF_006OG000004lmDN', 'active', '2025-06-23 18:56:30', '2025-06-23 19:14:04'),
(4, 6, '300x50', 300, 50, 0.0094, 'html5', '', '', '<script async type=\"application/javascript\" src=\"https://a.magsrv.com/ad-provider.js\"></script> \r\n <ins class=\"eas6a97888e10\" data-zoneid=\"5548390\"></ins> \r\n <script>(AdProvider = window.AdProvider || []).push({\"serve\": {}});</script>', 'https://t.ancdu.link/225680/3788/0?bo=3471,3472,3473,3474,3475&po=6456&aff_sub5=SF_006OG000004lmDN', 'active', '2025-06-23 18:57:10', '2025-06-23 19:14:10'),
(5, 6, '300x500', 300, 500, 0.0094, 'html5', '', '', '<script async type=\"application/javascript\" src=\"https://a.magsrv.com/ad-provider.js\"></script> \r\n <ins class=\"eas6a97888e2\" data-zoneid=\"5548378\"></ins> \r\n <script>(AdProvider = window.AdProvider || []).push({\"serve\": {}});</script>', 'https://t.ancdu.link/225680/3788/0?bo=3471,3472,3473,3474,3475&po=6456&aff_sub5=SF_006OG000004lmDN', 'active', '2025-06-23 18:57:57', '2025-06-23 19:14:15'),
(6, 6, '900x250', 900, 250, 0.0094, 'html5', '', '', '<script async type=\"application/javascript\" src=\"https://a.magsrv.com/ad-provider.js\"></script> \r\n <ins class=\"eas6a97888e2\" data-zoneid=\"5548376\"></ins> \r\n <script>(AdProvider = window.AdProvider || []).push({\"serve\": {}});</script>', 'https://t.ancdu.link/225680/3788/0?bo=3471,3472,3473,3474,3475&po=6456&aff_sub5=SF_006OG000004lmDN', 'active', '2025-06-23 18:58:36', '2025-06-23 19:14:20'),
(7, 6, '160x600', 160, 600, 0.0094, 'html5', '', '', '<script async type=\"application/javascript\" src=\"https://a.magsrv.com/ad-provider.js\"></script> \r\n <ins class=\"eas6a97888e2\" data-zoneid=\"5548374\"></ins> \r\n <script>(AdProvider = window.AdProvider || []).push({\"serve\": {}});</script>', 'https://t.ancdu.link/225680/3788/0?bo=3471,3472,3473,3474,3475&po=6456&aff_sub5=SF_006OG000004lmDN', 'active', '2025-06-23 18:59:17', '2025-06-23 19:14:26');

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
(1, 1, 6, NULL, 1, 0, 0.0094, 0.0047, '2025-06-24', '2025-06-23 19:38:59', '2025-06-23 19:38:59');

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
  ADD KEY `end_date` (`end_date`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `daily_statistics`
--
ALTER TABLE `daily_statistics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `publishers`
--
ALTER TABLE `publishers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `revenue_tracking`
--
ALTER TABLE `revenue_tracking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
