-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 04, 2025 at 03:31 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `food_menu`
--

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`id`, `name`, `price`) VALUES
(1, 'Cheeseburger', 5.99),
(2, 'Margherita Pizza', 8.49),
(3, 'Caesar Salad', 4.99),
(4, 'Grilled Chicken Wrap', 6.49);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `order_details` text DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `order_details`, `total_price`) VALUES
(2, 1, 'Margherita Pizza with BBQ Sauce', 0.00),
(3, 1, 'Margherita Pizza with Tomato Sauce', 0.00),
(4, 1, 'Grilled Chicken Wrap with Spicy Chili', 0.00),
(5, 1, 'Margherita Pizza with Tomato Sauce', 0.00),
(6, 1, 'Margherita Pizza with Garlic Mayo', 0.00),
(7, 1, 'Caesar Salad with BBQ Sauce', 0.00),
(8, 1, 'Margherita Pizza with Tomato Sauce', 0.00),
(9, 1, 'Caesar Salad with Tomato Sauce', 0.00),
(10, 1, 'Caesar Salad with Tomato Sauce', 0.00),
(11, 1, 'Grilled Chicken Wrap with BBQ Sauce', 0.00),
(12, 1, 'Margherita Pizza with Tomato Sauce', 0.00),
(13, 1, 'Caesar Salad with Tomato Sauce', 0.00),
(14, 1, 'Margherita Pizza with BBQ Sauce', 0.00),
(15, 1, 'Margherita Pizza with Tomato Sauce', 0.00),
(16, 1, 'Burger with Ketchup', 6.49),
(17, 1, 'Burger with Mayonnaise', 6.74),
(18, 1, 'Burger with Ketchup', 6.49),
(19, 1, 'Margherita Pizza with Tomato Sauce', 0.00),
(20, 1, 'Margherita Pizza with Tomato Sauce', 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `sauces`
--

CREATE TABLE `sauces` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sauces`
--

INSERT INTO `sauces` (`id`, `name`, `price`) VALUES
(1, 'Tomato Sauce', 0.50),
(2, 'BBQ Sauce', 0.75),
(3, 'Garlic Mayo', 0.60),
(4, 'Spicy Chili', 0.80);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`) VALUES
(1, 'youssef', '$2y$10$D7Dk/Bx0YXnUplPrY56ObuLv3SeUUhDrDeUNrNr2N2WJPkcpDuh0i');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `sauces`
--
ALTER TABLE `sauces`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `sauces`
--
ALTER TABLE `sauces`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
