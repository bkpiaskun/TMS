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

-- Zrzut struktury procedura TMS_DEV.Synchronize_SensorReadings
DELIMITER //
CREATE PROCEDURE `Synchronize_SensorReadings`()
BEGIN
	SET @Last_ID = ifnull((SELECT MAX(ID) FROM TMS_DEV.Sensor_Readings),0);
	
	Insert INTO TMS_DEV.Sensor_Readings
	SELECT rsr.*
	FROM  TMS_DEV.remote_Sensor_Readings rsr
	LEFT JOIN TMS_DEV.Sensor_Readings sr
	ON sr.ID = rsr.ID
	WHERE sr.ID IS NULL
	and rsr.ID >= @Last_ID
	AND rsr.ID < @Last_ID + 10000;
	
	IF FOUND_ROWS() > 0 THEN
	INSERT INTO TMS_DEV.MultiLog (VALUE,Source)
	SELECT CONCAT(FOUND_ROWS(),' rekordów zsynchronizowane'),'SynchroSR';
	END IF;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
