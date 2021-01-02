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

-- Zrzut struktury widok TemperatureMeasureSite.RAW_Last_Measurements
-- Usuwanie tabeli tymczasowej i tworzenie ostatecznej struktury WIDOKU
DROP TABLE IF EXISTS `RAW_Last_Measurements`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `RAW_Last_Measurements` AS select `sr`.`ID` AS `ID`,`sr`.`Sensor_ID` AS `Sensor_ID`,`ss`.`User_ID` AS `Sensor_Owner`,`ss`.`Sensor_Name` AS `Sensor_Name`,`sr`.`Timestamp_Of_Reading` AS `Timestamp_Of_Reading`,`sr`.`AVG_Humidity` AS `AVG_Humidity`,`sr`.`Max_Humidity` AS `Max_Humidity`,`sr`.`Min_Humidity` AS `Min_Humidity`,`sr`.`AVG_Temperature` AS `AVG_Temperature`,`sr`.`Max_Temperature` AS `Max_Temperature`,`sr`.`Min_Temperature` AS `Min_Temperature` from ((`TemperatureMeasureSite`.`Sensor_Readings` `sr` join (select max(`TemperatureMeasureSite`.`Sensor_Readings`.`ID`) AS `ID` from `TemperatureMeasureSite`.`Sensor_Readings` group by `TemperatureMeasureSite`.`Sensor_Readings`.`Sensor_ID`) `s` on(`sr`.`ID` = `s`.`ID`)) join `TemperatureMeasureSite`.`Sensors` `ss` on(`sr`.`Sensor_ID` = `ss`.`Sensor_Id`));

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
