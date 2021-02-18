/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE TABLE IF NOT EXISTS `Sensor_Readings_Cache` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Sensor_ID` int(11) NOT NULL DEFAULT '0',
  `dateDay` date NOT NULL,
  `dateHour` time NOT NULL,
  `AVG_Temperature` double NOT NULL DEFAULT '0',
  `AVG_Humidity` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `dateDay` (`dateDay`,`dateHour`),
  KEY `Sensor_ID` (`Sensor_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
