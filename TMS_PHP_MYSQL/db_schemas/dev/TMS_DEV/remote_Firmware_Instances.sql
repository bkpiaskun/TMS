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

-- Zrzut struktury tabela TMS_DEV.remote_Firmware_Instances
CREATE TABLE IF NOT EXISTS `remote_Firmware_Instances` (
  `FW_IN_ID` int(11) NOT NULL AUTO_INCREMENT,
  `FW_Next` int(11) DEFAULT NULL,
  `FW_ID` int(11) NOT NULL,
  PRIMARY KEY (`FW_IN_ID`) USING BTREE
) ENGINE=FEDERATED DEFAULT CHARSET=utf8 CONNECTION='linked/Firmware_Instances';

-- Table data not exported because this is FEDERATED table which holds its data in separate tables.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
