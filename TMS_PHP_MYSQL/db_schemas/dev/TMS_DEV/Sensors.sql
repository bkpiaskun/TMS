-- --------------------------------------------------------
-- Host:                         192.168.0.194
-- Wersja serwera:               5.7.31-0ubuntu0.18.04.1 - (Ubuntu)
-- Serwer OS:                    Linux
-- HeidiSQL Wersja:              11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Zrzut struktury tabela TMS_DEV.Sensors
CREATE TABLE IF NOT EXISTS `Sensors` (
  `Sensor_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Device_ID` int(11) NOT NULL DEFAULT '0',
  `Sensor_Name` varchar(30) NOT NULL,
  `PIN` int(11) DEFAULT NULL,
  PRIMARY KEY (`Sensor_ID`) USING BTREE,
  KEY `Device_ID` (`Device_ID`),
  CONSTRAINT `FK_Sensors_Devices` FOREIGN KEY (`Device_ID`) REFERENCES `Devices` (`Device_ID`) ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Eksport danych został odznaczony.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
