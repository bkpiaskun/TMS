-- --------------------------------------------------------
-- Host:                         192.168.0.181
-- Wersja serwera:               5.7.32-0ubuntu0.18.04.1 - (Ubuntu)
-- Serwer OS:                    Linux
-- HeidiSQL Wersja:              11.1.0.6116
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Zrzut struktury tabela TMS.Sensor_Readings
CREATE TABLE IF NOT EXISTS `Sensor_Readings` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Sensor_ID` int(11) NOT NULL,
  `Timestamp_Of_Reading` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `AVG_Humidity` float DEFAULT NULL,
  `Max_Humidity` float DEFAULT NULL,
  `Min_Humidity` float DEFAULT NULL,
  `AVG_Temperature` float DEFAULT NULL,
  `Max_Temperature` float DEFAULT NULL,
  `Min_Temperature` float DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Sensor_ID` (`Sensor_ID`),
  KEY `Timestamp_Of_Reading` (`Timestamp_Of_Reading`)
) ENGINE=InnoDB AUTO_INCREMENT=5608 DEFAULT CHARSET=utf8;

-- Eksport danych został odznaczony.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
