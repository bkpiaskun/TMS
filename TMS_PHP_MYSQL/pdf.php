<?php
namespace Dompdf;


header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: *");
error_reporting(1);
ini_set('display_errors', 'On');
ini_set('display_startup_errors', 'On');

require 'logging_functions.php';

require 'creds.php';

require_once 'dompdf/autoload.inc.php';

$sql = "SELECT *
FROM (
SELECT `temptable1`.`Sensor_Name` AS `Sensor_Name`, 
`temptable1`.`Timestamp_Of_Reading` AS `Timestamp_Of_Reading`,
`temptable1`.`AVG_Humidity` AS `AVG_Humidity`,
`temptable1`.`AVG_Temperature` AS `AVG_Temperature`,
FROM (
SELECT `ttable`.`Sensor_Name` AS `Sensor_Name`,
`ttable`.`Timestamp_Of_Reading` AS `Timestamp_Of_Reading`,
`ttable`.`AVG_Humidity` AS `AVG_Humidity`,
`ttable`.`AVG_Temperature` AS `AVG_Temperature`,
SEC_TO_TIME((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(`ttable`.`Timestamp_Of_Reading`))) AS `diffTime`
FROM (
SELECT *
FROM RAW_Last_Measurements rlm
JOIN Users us ON rlm.Sensor_Owner = us.User_ID
WHERE us.UserName = 'xxxxxxxxxxxxxxx' AND us.API_KEY = 'sssssssssssssssss') `ttable`
            ) `temptable1`
WHERE ((MINUTE(`temptable1`.`diffTime`) < 5) AND (HOUR(`temptable1`.`diffTime`) = 0))
ORDER BY `temptable1`.`diffTime`) ttj;";

$result = $conn->query($sql);
$resultArray = array();
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $resultArray[] = $row;
    }
}
var_dump($resultArray);
$tablecontent = "<tr><td>asd</td></tr>";

$dompdf = new Dompdf(); 
$dompdf->loadHtml('
<table border=1 align=center width=400>
'.$tablecontent.'
</table>
');
$dompdf->setPaper('A4', 'landscape');
$dompdf->render();
$dompdf->stream("",array("Attachment" => false));

exit(0);
?>