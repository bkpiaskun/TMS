-- --------------------------------------------------------
-- Host:                         intern.kluchens.eu
-- Wersja serwera:               5.7.26-0ubuntu0.16.04.1 - (Ubuntu)
-- Serwer OS:                    Linux
-- HeidiSQL Wersja:              10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Zrzut struktury bazy danych TemperatureMeasureSite
CREATE DATABASE IF NOT EXISTS `TemperatureMeasureSite` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `TemperatureMeasureSite`;

-- Zrzut struktury widok TemperatureMeasureSite.LAST_Measurements
-- Tworzenie tymczasowej tabeli aby przezwyciężyć błędy z zależnościami w WIDOKU
CREATE TABLE `LAST_Measurements` (
	`ID` INT(11) NOT NULL,
	`Sensor_Name` VARCHAR(30) NOT NULL COLLATE 'utf8_general_ci',
	`Timestamp_Of_Reading` TIMESTAMP NOT NULL,
	`AVG_Humidity` FLOAT NULL,
	`Max_Humidity` FLOAT NULL,
	`Min_Humidity` FLOAT NULL,
	`AVG_Temperature` FLOAT NULL,
	`Max_Temperature` FLOAT NULL,
	`Min_Temperature` FLOAT NULL
) ENGINE=MyISAM;

-- Zrzut struktury widok TemperatureMeasureSite.Measurements_With_Differences
-- Tworzenie tymczasowej tabeli aby przezwyciężyć błędy z zależnościami w WIDOKU
CREATE TABLE `Measurements_With_Differences` (
	`ID` INT(11) NOT NULL,
	`Sensor_Name` VARCHAR(30) NOT NULL COLLATE 'utf8_general_ci',
	`Timestamp_Of_Reading` VARCHAR(33) NULL COLLATE 'utf8mb4_general_ci',
	`AVG_Humidity` FLOAT NULL,
	`Max_Humidity` FLOAT NULL,
	`Min_Humidity` FLOAT NULL,
	`AVG_Temperature` FLOAT NULL,
	`Max_Temperature` FLOAT NULL,
	`Min_Temperature` FLOAT NULL
) ENGINE=MyISAM;

-- Zrzut struktury tabela TemperatureMeasureSite.Sensors
CREATE TABLE IF NOT EXISTS `Sensors` (
  `Sensor_Id` int(11) NOT NULL AUTO_INCREMENT,
  `Sensor_Name` varchar(30) NOT NULL,
  `Mac_Address` varchar(30) NOT NULL,
  `Password` varchar(30) NOT NULL,
  PRIMARY KEY (`Sensor_Id`),
  UNIQUE KEY `Mac_Address` (`Mac_Address`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- Eksport danych został odznaczony.

-- Zrzut struktury tabela TemperatureMeasureSite.Sensor_Readings
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
  KEY `Sensor_ID` (`Sensor_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=314935 DEFAULT CHARSET=utf8;

-- Eksport danych został odznaczony.

-- Zrzut struktury widok TemperatureMeasureSite.LAST_Measurements
-- Usuwanie tabeli tymczasowej i tworzenie ostatecznej struktury WIDOKU
DROP TABLE IF EXISTS `LAST_Measurements`;
CREATE ALGORITHM=UNDEFINED DEFINER=`sashimi`@`%` SQL SECURITY DEFINER VIEW `LAST_Measurements` AS select `sr`.`ID` AS `ID`,`ss`.`Sensor_Name` AS `Sensor_Name`,`sr`.`Timestamp_Of_Reading` AS `Timestamp_Of_Reading`,`sr`.`AVG_Humidity` AS `AVG_Humidity`,`sr`.`Max_Humidity` AS `Max_Humidity`,`sr`.`Min_Humidity` AS `Min_Humidity`,`sr`.`AVG_Temperature` AS `AVG_Temperature`,`sr`.`Max_Temperature` AS `Max_Temperature`,`sr`.`Min_Temperature` AS `Min_Temperature` from ((`TemperatureMeasureSite`.`Sensor_Readings` `sr` join (select max(`TemperatureMeasureSite`.`Sensor_Readings`.`ID`) AS `ID` from `TemperatureMeasureSite`.`Sensor_Readings` group by `TemperatureMeasureSite`.`Sensor_Readings`.`Sensor_ID`) `s` on((`sr`.`ID` = `s`.`ID`))) join `TemperatureMeasureSite`.`Sensors` `ss` on((`sr`.`Sensor_ID` = `ss`.`Sensor_Id`)));

-- Zrzut struktury widok TemperatureMeasureSite.Measurements_With_Differences
-- Usuwanie tabeli tymczasowej i tworzenie ostatecznej struktury WIDOKU
DROP TABLE IF EXISTS `Measurements_With_Differences`;
CREATE ALGORITHM=UNDEFINED DEFINER=`sensorsite`@`%` SQL SECURITY DEFINER VIEW `Measurements_With_Differences` AS select `temptable1`.`ID` AS `ID`,`temptable1`.`Sensor_Name` AS `Sensor_Name`,concat(if((hour(`temptable1`.`diffTime`) > 0),concat(hour(`temptable1`.`diffTime`),' godzin '),''),if((minute(`temptable1`.`diffTime`) > 0),concat(minute(`temptable1`.`diffTime`),' minut '),''),second(`temptable1`.`diffTime`),' sekund temu') AS `Timestamp_Of_Reading`,`temptable1`.`AVG_Humidity` AS `AVG_Humidity`,`temptable1`.`Max_Humidity` AS `Max_Humidity`,`temptable1`.`Min_Humidity` AS `Min_Humidity`,`temptable1`.`AVG_Temperature` AS `AVG_Temperature`,`temptable1`.`Max_Temperature` AS `Max_Temperature`,`temptable1`.`Min_Temperature` AS `Min_Temperature` from (select `ttable`.`ID` AS `ID`,`ttable`.`Sensor_Name` AS `Sensor_Name`,`ttable`.`Timestamp_Of_Reading` AS `Timestamp_Of_Reading`,`ttable`.`AVG_Humidity` AS `AVG_Humidity`,`ttable`.`Max_Humidity` AS `Max_Humidity`,`ttable`.`Min_Humidity` AS `Min_Humidity`,`ttable`.`AVG_Temperature` AS `AVG_Temperature`,`ttable`.`Max_Temperature` AS `Max_Temperature`,`ttable`.`Min_Temperature` AS `Min_Temperature`,sec_to_time((unix_timestamp(now()) - unix_timestamp(`ttable`.`Timestamp_Of_Reading`))) AS `diffTime` from `TemperatureMeasureSite`.`LAST_Measurements` `ttable`) `temptable1` where ((minute(`temptable1`.`diffTime`) < 5) and (hour(`temptable1`.`diffTime`) = 0)) order by `temptable1`.`diffTime`;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;


