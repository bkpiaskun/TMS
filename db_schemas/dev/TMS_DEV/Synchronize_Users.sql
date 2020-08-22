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

-- Zrzut struktury procedura TMS_DEV.Synchronize_Users
DELIMITER //
CREATE PROCEDURE `Synchronize_Users`()
BEGIN
	REPLACE INTO TMS_DEV.Users
	SELECT rsr.*
	FROM  TMS_DEV.remote_Users rsr
	LEFT JOIN TMS_DEV.Users sr
	ON sr.User_ID = rsr.User_ID
	WHERE sr.User_ID IS NULL
	or sr.UserName != rsr.UserName
	or sr.Name != rsr.Name
	or sr.Surname != rsr.Surname
	or sr.API_KEY != rsr.API_KEY;

	IF FOUND_ROWS() > 0 THEN
	INSERT INTO TMS_DEV.MultiLog (VALUE,Source)
	SELECT CONCAT(FOUND_ROWS(),' rekordów zsynchronizowane'),'SynchroUSR';
	END IF;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
