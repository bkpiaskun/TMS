/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DELIMITER //
CREATE PROCEDURE `Synchronize_Devices`()
BEGIN

	SET @Last_ID = ifnull((SELECT MAX(Sensor_ID) FROM TMS_DEV.Sensors),0);
	
	DELETE sr.*
	FROM TMS_DEV.Sensors sr
	LEFT JOIN TMS_DEV.remote_Sensors rsr
	ON sr.Sensor_ID = rsr.Sensor_ID
	WHERE sr.Sensor_ID IS NOT NULL
	AND (	sr.Sensor_Name != rsr.Sensor_Name
	or sr.PIN != rsr.PIN
	OR sr.Device_ID != rsr.Device_ID )
	and rsr.Sensor_ID >= @Last_ID
	AND rsr.Sensor_ID < @Last_ID + 10000;


	INSERT INTO TMS_DEV.Sensors
	SELECT rsr.*
	FROM  TMS_DEV.remote_Sensors rsr
	LEFT JOIN TMS_DEV.Sensors sr
	ON sr.Sensor_ID = rsr.Sensor_ID
	WHERE sr.Sensor_ID IS NULL
	and rsr.Sensor_ID >= @Last_ID
	AND rsr.Sensor_ID < @Last_ID + 10000;

	IF FOUND_ROWS() > 0 THEN
	INSERT INTO TMS_DEV.MultiLog (VALUE,Source)
	SELECT CONCAT(FOUND_ROWS(),' rekordów zsynchronizowane'),'SynchroSNRS';
	END IF;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
