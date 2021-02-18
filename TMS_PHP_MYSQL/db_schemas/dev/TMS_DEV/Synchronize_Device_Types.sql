-- --------------------------------------------------------
-- Host:                         192.168.0.181
-- Wersja serwera:               5.7.33-0ubuntu0.18.04.1 - (Ubuntu)
-- Serwer OS:                    Linux
-- HeidiSQL Wersja:              11.1.0.6116
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Zrzut struktury procedura TMS_DEV.Synchronize_Device_Types
DELIMITER //
CREATE PROCEDURE `Synchronize_Device_Types`()
BEGIN
	DELETE sr.*
	FROM TMS_DEV.Device_Types sr
	LEFT JOIN TMS_DEV.remote_Device_Types rsr
	ON sr.Type_ID = rsr.Type_ID
	WHERE sr.Type_ID IS NOT NULL
	AND sr.Name != rsr.Name;

	INSERT INTO TMS_DEV.Device_Types
	SELECT rsr.*
	FROM  TMS_DEV.remote_Device_Types rsr
	LEFT JOIN TMS_DEV.Device_Types sr
	ON sr.Type_ID = rsr.Type_ID
	WHERE sr.Type_ID IS NULL;

	IF FOUND_ROWS() > 0 THEN
	INSERT INTO TMS_DEV.MultiLog (VALUE,Source)
	SELECT CONCAT(FOUND_ROWS(),' rekordów zsynchronizowane'),'SynchroDVCTYPES';
	END IF;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
