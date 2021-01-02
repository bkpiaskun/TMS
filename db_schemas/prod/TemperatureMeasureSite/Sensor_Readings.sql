-- --------------------------------------------------------
-- Host:                         intern.bkluska.eu
-- Wersja serwera:               10.3.22-MariaDB-0+deb10u1-log - Raspbian 10
-- Serwer OS:                    debian-linux-gnueabihf
-- HeidiSQL Wersja:              11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Zrzut struktury tabela TemperatureMeasureSite.Sensor_Readings
CREATE TABLE IF NOT EXISTS `Sensor_Readings` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Sensor_ID` int(11) NOT NULL,
  `Timestamp_Of_Reading` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `AVG_Humidity` float DEFAULT NULL,
  `Max_Humidity` float DEFAULT NULL,
  `Min_Humidity` float DEFAULT NULL,
  `AVG_Temperature` float DEFAULT NULL,
  `Max_Temperature` float DEFAULT NULL,
  `Min_Temperature` float DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Sensor_ID` (`Sensor_ID`),
  KEY `Timestamp_Of_Reading` (`Timestamp_Of_Reading`)
) ENGINE=InnoDB AUTO_INCREMENT=4512341 DEFAULT CHARSET=utf8;

-- Eksport danych został odznaczony.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
