/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE TABLE IF NOT EXISTS `Wifi_Assigned` (
  `Assignation_ID` int(11) NOT NULL AUTO_INCREMENT,
  `WIFI_ID` int(11) NOT NULL DEFAULT '0',
  `Device_ID` int(11) NOT NULL DEFAULT '0',
  `Active` bit(1) DEFAULT b'1',
  PRIMARY KEY (`Assignation_ID`),
  KEY `FK__Wifi_Networks` (`WIFI_ID`),
  KEY `FK__Devices` (`Device_ID`),
  CONSTRAINT `FK__Devices` FOREIGN KEY (`Device_ID`) REFERENCES `Devices` (`Device_ID`),
  CONSTRAINT `FK__Wifi_Networks` FOREIGN KEY (`WIFI_ID`) REFERENCES `Wifi_Networks` (`WIFI_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;