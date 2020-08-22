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

-- Zrzut struktury tabela TemperatureMeasureSite.Sensors
CREATE TABLE IF NOT EXISTS `Sensors` (
  `Sensor_Id` int(11) NOT NULL AUTO_INCREMENT,
  `User_ID` int(11) NOT NULL DEFAULT 0,
  `Sensor_Name` varchar(30) NOT NULL,
  `Mac_Address` varchar(30) NOT NULL,
  `Password` varchar(30) NOT NULL,
  PRIMARY KEY (`Sensor_Id`),
  UNIQUE KEY `Mac_Address` (`Mac_Address`),
  KEY `User_ID` (`User_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- Eksport danych został odznaczony.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
