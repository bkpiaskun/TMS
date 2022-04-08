/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DROP TABLE IF EXISTS `RAW_Last_Measurements`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `RAW_Last_Measurements` AS select `sr`.`ID` AS `ID`,`sr`.`Sensor_ID` AS `Sensor_ID`,`dv`.`User_ID` AS `Sensor_Owner`,`ss`.`Sensor_Name` AS `Sensor_Name`,`sr`.`Timestamp_Of_Reading` AS `Timestamp_Of_Reading`,`sr`.`AVG_Humidity` AS `AVG_Humidity`,`sr`.`Max_Humidity` AS `Max_Humidity`,`sr`.`Min_Humidity` AS `Min_Humidity`,`sr`.`AVG_Temperature` AS `AVG_Temperature`,`sr`.`Max_Temperature` AS `Max_Temperature`,`sr`.`Min_Temperature` AS `Min_Temperature` from (((`TMS`.`Sensor_Readings` `sr` join (select max(`TMS`.`Sensor_Readings`.`ID`) AS `ID` from `TMS`.`Sensor_Readings` group by `TMS`.`Sensor_Readings`.`Sensor_ID`) `s` on((`sr`.`ID` = `s`.`ID`))) join `TMS`.`Sensors` `ss` on((`sr`.`Sensor_ID` = `ss`.`Sensor_ID`))) join `TMS`.`Devices` `dv` on((`ss`.`Device_ID` = `dv`.`Device_ID`)));

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
