/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE TABLE IF NOT EXISTS `Devices` (
  `Device_ID` int(11) NOT NULL AUTO_INCREMENT,
  `User_ID` int(11) DEFAULT NULL,
  `Mac_Address` varchar(30) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `Password` varchar(30) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `Current_FW` int(11) DEFAULT NULL,
  `Device_Type` int(11) DEFAULT NULL,
  `Updates_Disabled_Date` timestamp NULL DEFAULT NULL,
  `Firmware_AutoUpdate` bit(1) DEFAULT b'0',
  `Webserver_URL` varchar(150) CHARACTER SET latin1 DEFAULT 'tms.server.org',
  `Update_URL` varchar(150) CHARACTER SET latin1 DEFAULT 'tms.server.org',
  PRIMARY KEY (`Device_ID`),
  KEY `User_ID` (`User_ID`),
  KEY `FK_Devices_Device_Types` (`Device_Type`),
  KEY `FK_Devices_Firmware_Instances` (`Current_FW`),
  CONSTRAINT `FK_Devices_Device_Types` FOREIGN KEY (`Device_Type`) REFERENCES `Device_Types` (`Type_ID`),
  CONSTRAINT `FK_Devices_Firmware_Instances` FOREIGN KEY (`Current_FW`) REFERENCES `Firmware_Instances` (`FW_IN_ID`),
  CONSTRAINT `FK_Devices_Users` FOREIGN KEY (`User_ID`) REFERENCES `Users` (`User_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
