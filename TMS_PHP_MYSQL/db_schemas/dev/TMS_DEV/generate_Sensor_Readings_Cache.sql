/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DELIMITER //
CREATE PROCEDURE `generate_Sensor_Readings_Cache`(
	IN `startDate` TIMESTAMP,
	IN `endDate` TIMESTAMP,
	IN `Sensor_ID` INT


)
BEGIN


insert ignore into Sensor_Readings_Cache (dateDay,dateHour,AVG_Temperature,AVG_Humidity)
SELECT
	  ttj.dateDay,
	  ttj.dateHour,
	  ttj.AVG_Temperature,
	  ttj.AVG_Humidity
from (
select
	date(Timestamp_Of_Reading) dateDay,
 	(hour(Timestamp_Of_Reading)) dateHour,
   avg(AVG_Temperature) AVG_Temperature,
	avg(AVG_Humidity) AVG_Humidity
FROM (
	SELECT Timestamp_Of_Reading,AVG_Temperature,AVG_Humidity
	FROM Sensor_Readings sr
	WHERE
		sr.Timestamp_Of_Reading >= startDate AND
		sr.Timestamp_Of_Reading <= endDate and
		sr.Sensor_ID = Sensor_ID
	) xd
group by date(Timestamp_Of_Reading),(hour(Timestamp_Of_Reading))
ORDER BY dateDay,dateHour DESC
) ttj;

IF FOUND_ROWS() > 0 THEN
INSERT INTO TMS_DEV.MultiLog (VALUE,Source)
SELECT CONCAT(FOUND_ROWS(),' rekordów wygenerowano'),'GenCache';
END IF;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
