-- phpMyAdmin SQL Dump
-- version 4.6.6deb5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Czas generowania: 18 Lis 2018, 13:49
-- Wersja serwera: 5.7.24-0ubuntu0.18.04.1
-- Wersja PHP: 7.2.10-0ubuntu0.18.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `TemperatureMeasureSite`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `Sensors`
--

CREATE TABLE `Sensors` (
  `Sensor_Id` int(11) NOT NULL,
  `Sensor_Name` varchar(30) NOT NULL,
  `Mac_Address` varchar(30) NOT NULL,
  `Password` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `Sensors`
--

INSERT INTO `Sensors` (`Sensor_Id`, `Sensor_Name`, `Mac_Address`, `Password`) VALUES
(1, 'ESP32', '24-0A-C4-AE-90-EC', 'ESPtrzecie'),
(2, 'ESP32', '24-0A-C4-AE-99-54', 'ESPpierwsze'),
(3, 'ESP32', '24-0A-C4-AE-9E-7C', 'ESPdrugie');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `Sensor_Readings`
--

CREATE TABLE `Sensor_Readings` (
  `ID` int(11) NOT NULL,
  `Sensor_ID` int(11) NOT NULL,
  `Timestamp_Of_Reading` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `AVG_Humidity` float NOT NULL,
  `Max_Humidity` float NOT NULL,
  `Min_Humidity` float NOT NULL,
  `AVG_Temperature` float NOT NULL,
  `Max_Temperature` float NOT NULL,
  `Min_Temperature` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `Sensor_Readings`
--

INSERT INTO `Sensor_Readings` (`ID`, `Sensor_ID`, `Timestamp_Of_Reading`, `AVG_Humidity`, `Max_Humidity`, `Min_Humidity`, `AVG_Temperature`, `Max_Temperature`, `Min_Temperature`) VALUES
(1, 1, '2018-11-17 15:59:55', 30, 40, 25, 22, 24, 20);

--
-- Indeksy dla zrzutów tabel
--

--
-- Indexes for table `Sensors`
--
ALTER TABLE `Sensors`
  ADD PRIMARY KEY (`Sensor_Id`);

--
-- Indexes for table `Sensor_Readings`
--
ALTER TABLE `Sensor_Readings`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `Sensors`
--
ALTER TABLE `Sensors`
  MODIFY `Sensor_Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT dla tabeli `Sensor_Readings`
--
ALTER TABLE `Sensor_Readings`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
