/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DELIMITER //
CREATE PROCEDURE `GetEEPROM`( mac VARCHAR(50), pass VARCHAR(50) )
BEGIN

SELECT "WIFI" AS "Type",wifi_n.wifi_ssid AS "First",wifi_n.WIFI_Pass AS "Second"
FROM Wifi_Networks wifi_n
JOIN Wifi_Assigned wifi_in ON wifi_n.WIFI_ID = wifi_in.WIFI_ID
JOIN Devices dv ON dv.Device_ID = wifi_in.Device_ID
WHERE dv.Mac_Address = mac AND dv.Password = pass and wifi_in.active = TRUE
UNION
SELECT "URLS" AS "Type",dv.Webserver_URL,dv.Update_URL
from Devices dv
WHERE dv.Mac_Address = mac AND dv.Password = pass
UNION
SELECT "PINS" AS "Type",srs.PIN, st.name
FROM Sensors srs
JOIN Devices dv ON srs.Device_ID = dv.Device_ID
JOIN Sensor_Types st ON srs.Sensor_Type = st.Type_ID
WHERE dv.Mac_Address = mac AND dv.Password = pass;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
