/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DROP TABLE IF EXISTS `Measurements_With_Differences`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `Measurements_With_Differences` AS select `temptable1`.`ID` AS `ID`,`temptable1`.`Sensor_Name` AS `Sensor_Name`,concat(if((hour(`temptable1`.`diffTime`) > 0),concat(hour(`temptable1`.`diffTime`),' godzin '),''),if((minute(`temptable1`.`diffTime`) > 0),concat(minute(`temptable1`.`diffTime`),' minut '),''),second(`temptable1`.`diffTime`),' sekund temu') AS `Timestamp_Of_Reading`,`temptable1`.`AVG_Humidity` AS `AVG_Humidity`,`temptable1`.`Max_Humidity` AS `Max_Humidity`,`temptable1`.`Min_Humidity` AS `Min_Humidity`,`temptable1`.`AVG_Temperature` AS `AVG_Temperature`,`temptable1`.`Max_Temperature` AS `Max_Temperature`,`temptable1`.`Min_Temperature` AS `Min_Temperature` from (select `ttable`.`ID` AS `ID`,`ttable`.`Sensor_Name` AS `Sensor_Name`,`ttable`.`Timestamp_Of_Reading` AS `Timestamp_Of_Reading`,`ttable`.`AVG_Humidity` AS `AVG_Humidity`,`ttable`.`Max_Humidity` AS `Max_Humidity`,`ttable`.`Min_Humidity` AS `Min_Humidity`,`ttable`.`AVG_Temperature` AS `AVG_Temperature`,`ttable`.`Max_Temperature` AS `Max_Temperature`,`ttable`.`Min_Temperature` AS `Min_Temperature`,sec_to_time((unix_timestamp(now()) - unix_timestamp(`ttable`.`Timestamp_Of_Reading`))) AS `diffTime` from `TMS_DEV`.`LAST_Measurements` `ttable`) `temptable1` where ((minute(`temptable1`.`diffTime`) < 5) and (hour(`temptable1`.`diffTime`) = 0)) order by `temptable1`.`diffTime`;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
