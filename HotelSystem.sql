-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Дек 23 2024 г., 17:28
-- Версия сервера: 8.0.30
-- Версия PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `HotelSystem`
--

-- --------------------------------------------------------

--
-- Структура таблицы `Categories`
--

CREATE TABLE `Categories` (
  `CategoryID` int NOT NULL,
  `CategoryName` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `Categories`
--

INSERT INTO `Categories` (`CategoryID`, `CategoryName`) VALUES
(1, 'Стандарт'),
(2, 'Люкс'),
(3, 'Апартаменты');

-- --------------------------------------------------------

--
-- Структура таблицы `Citizens`
--

CREATE TABLE `Citizens` (
  `CitizenID` int NOT NULL,
  `FullName` varchar(255) NOT NULL,
  `PassportNumber` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `Citizens`
--

INSERT INTO `Citizens` (`CitizenID`, `FullName`, `PassportNumber`) VALUES
(1, 'Иван Иванов', '1234567890'),
(2, 'Мария Смирнова', '0987654321');

-- --------------------------------------------------------

--
-- Структура таблицы `Placements`
--

CREATE TABLE `Placements` (
  `PlacementID` int NOT NULL,
  `CitizenID` int DEFAULT NULL,
  `RoomID` int DEFAULT NULL,
  `CheckInDate` date DEFAULT NULL,
  `DurationDays` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `Placements`
--

INSERT INTO `Placements` (`PlacementID`, `CitizenID`, `RoomID`, `CheckInDate`, `DurationDays`) VALUES
(1, 1, 1, '2024-12-01', 5),
(2, 2, 3, '2024-12-02', 10);

-- --------------------------------------------------------

--
-- Структура таблицы `Rooms`
--

CREATE TABLE `Rooms` (
  `RoomID` int NOT NULL,
  `CategoryID` int DEFAULT NULL,
  `RoomNumber` varchar(10) DEFAULT NULL,
  `Capacity` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `Rooms`
--

INSERT INTO `Rooms` (`RoomID`, `CategoryID`, `RoomNumber`, `Capacity`) VALUES
(1, 1, '101', 2),
(2, 1, '102', 1),
(3, 2, '201', 2),
(4, 3, '301', 4);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `Categories`
--
ALTER TABLE `Categories`
  ADD PRIMARY KEY (`CategoryID`);

--
-- Индексы таблицы `Citizens`
--
ALTER TABLE `Citizens`
  ADD PRIMARY KEY (`CitizenID`),
  ADD UNIQUE KEY `PassportNumber` (`PassportNumber`);

--
-- Индексы таблицы `Placements`
--
ALTER TABLE `Placements`
  ADD PRIMARY KEY (`PlacementID`),
  ADD KEY `CitizenID` (`CitizenID`),
  ADD KEY `RoomID` (`RoomID`);

--
-- Индексы таблицы `Rooms`
--
ALTER TABLE `Rooms`
  ADD PRIMARY KEY (`RoomID`),
  ADD KEY `CategoryID` (`CategoryID`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `Categories`
--
ALTER TABLE `Categories`
  MODIFY `CategoryID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `Citizens`
--
ALTER TABLE `Citizens`
  MODIFY `CitizenID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `Placements`
--
ALTER TABLE `Placements`
  MODIFY `PlacementID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `Rooms`
--
ALTER TABLE `Rooms`
  MODIFY `RoomID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `Placements`
--
ALTER TABLE `Placements`
  ADD CONSTRAINT `placements_ibfk_1` FOREIGN KEY (`CitizenID`) REFERENCES `Citizens` (`CitizenID`) ON DELETE CASCADE,
  ADD CONSTRAINT `placements_ibfk_2` FOREIGN KEY (`RoomID`) REFERENCES `Rooms` (`RoomID`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `Rooms`
--
ALTER TABLE `Rooms`
  ADD CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`CategoryID`) REFERENCES `Categories` (`CategoryID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
