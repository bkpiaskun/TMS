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

-- Zrzut struktury widok TMS_DEV.LAST_Measurements
-- Usuwanie tabeli tymczasowej i tworzenie ostatecznej struktury WIDOKU
DROP TABLE IF EXISTS `LAST_Measurements`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `LAST_Measurements` AS select `sr`.`ID` AS `ID`,`ss`.`Sensor_Name` AS `Sensor_Name`,`sr`.`Timestamp_Of_Reading` AS `Timestamp_Of_Reading`,`sr`.`AVG_Humidity` AS `AVG_Humidity`,`sr`.`Max_Humidity` AS `Max_Humidity`,`sr`.`Min_Humidity` AS `Min_Humidity`,`sr`.`AVG_Temperature` AS `AVG_Temperature`,`sr`.`Max_Temperature` AS `Max_Temperature`,`sr`.`Min_Temperature` AS `Min_Temperature` from ((`TMS_DEV`.`Sensor_Readings` `sr` join (select max(`TMS_DEV`.`Sensor_Readings`.`ID`) AS `ID` from `TMS_DEV`.`Sensor_Readings` group by `TMS_DEV`.`Sensor_Readings`.`Sensor_ID`) `s` on((`sr`.`ID` = `s`.`ID`))) join `TMS_DEV`.`Sensors` `ss` on((`sr`.`Sensor_ID` = `ss`.`Sensor_ID`)));

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
