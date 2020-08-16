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

-- Zrzut struktury wyzwalacz TMS_DEV.Sensor_Readings_after_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `Sensor_Readings_after_insert` AFTER INSERT ON `Sensor_Readings` FOR EACH ROW BEGIN
/*
SELECT HOUR(ttj.Timestamp_Of_Reading)
INTO @max
FROM (
	SELECT Timestamp_Of_Reading
	FROM Sensor_Readings
	WHERE Sensor_ID = NEW.Sensor_ID
	ORDER BY ID desc
	LIMIT 1 OFFSET 1) ttj;

SELECT concat(dateDay, ' ', dateHour)
INTO @lastDate
FROM Sensor_Readings_Cache
WHERE Sensor_ID = NEW.Sensor_ID
ORDER BY ID DESC
LIMIT 1;

if @MAX = time(NEW.Timestamp_Of_Reading) then
	CALL generate_Sensor_Readings_Cache(@lastDate,@MAX);
end if;	

*/
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
