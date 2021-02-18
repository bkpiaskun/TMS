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

-- Zrzut struktury procedura TMS_DEV.Synchronize_Firmwares
DELIMITER //
CREATE PROCEDURE `Synchronize_Firmwares`()
BEGIN
	DELETE sr.*
	FROM TMS_DEV.Firmwares sr
	LEFT JOIN TMS_DEV.remote_Firmwares rsr
	ON sr.FW_ID = rsr.FW_ID
	WHERE sr.FW_ID IS NOT NULL
	AND sr.FW_Link != rsr.FW_Link;

	INSERT INTO TMS_DEV.Firmwares
	SELECT rsr.*
	FROM  TMS_DEV.remote_Firmwares rsr
	LEFT JOIN TMS_DEV.Firmwares sr
	ON sr.FW_ID = rsr.FW_ID
	WHERE sr.FW_ID IS NULL;

	IF FOUND_ROWS() > 0 THEN
	INSERT INTO TMS_DEV.MultiLog (VALUE,Source)
	SELECT CONCAT(FOUND_ROWS(),' rekordów zsynchronizowane'),'SynchroFW';
	END IF;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
