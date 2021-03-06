/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DELIMITER //
CREATE FUNCTION `Create_apikey`() RETURNS varchar(50) CHARSET latin1
    DETERMINISTIC
BEGIN
  DECLARE apikey_exists TINYINT(1);
  DECLARE apikey VARCHAR(15);
  SET apikey_exists = TRUE;
  SET apikey = concat(LEFT(UUID(), 8),LEFT(UUID(), 7));
  
  WHILE ( apikey_exists IS true )  DO
  SET apikey = concat(LEFT(UUID(), 8),LEFT(UUID(), 7));
  
  	SET apikey_exists = FALSE;
	SELECT true
	INTO apikey_exists
	FROM Users
	WHERE api_key = apikey;
  
END WHILE;

RETURN apikey;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
