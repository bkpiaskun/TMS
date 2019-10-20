<?php

error_reporting(1);
ini_set('display_errors', 'On');
ini_set('display_startup_errors', 'On');
require 'creds.php';

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
	die("INTERNAL ERROR");
}
$pass = $_POST['Password'];
$mac = $_POST['MAC'];
$sensor_ID = 0;
$result = $conn->query("SELECT Sensor_Id,Sensor_Name,Mac_Address,Password FROM TemperatureMeasureSite.Sensors");
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()){
	if($row["Mac_Address"] == $mac && $row["Password"] == $pass)
        {
        	$sensor_ID = $row["Sensor_Id"];
        	break;
        }
    }
}
else
{
    echo "<p>żadnych sensorów nie ma<p>";
}



if($sensor_ID != 0)
{
	$AVG_Humidity = $_POST['AVG_Humidity'];
	$Max_Humidity = $_POST['Max_Humidity'];
	$Min_Humidity = $_POST['Min_Humidity'];
	$AVG_Temperature = $_POST['AVG_Temperature'];
	$Max_Temperature = $_POST['Max_Temperature'];
	$Min_Temperature = $_POST['Min_Temperature'];

	if($AVG_Humidity == null)
	{
		$AVG_Humidity = -1;
	}
	if($Max_Humidity == null)
	{
		$Max_Humidity = -1;
	}
	if($Min_Humidity == null)
	{
		$Min_Humidity = -1;
	}

	$sql = "INSERT INTO TemperatureMeasureSite.Sensor_Readings (
	Sensor_ID,
	AVG_Humidity,
	Max_Humidity,
	Min_Humidity,
	AVG_Temperature,
	Max_Temperature,
	Min_Temperature
	)
	VALUES (
	$sensor_ID,
	$AVG_Humidity,
	$Max_Humidity,
	$Min_Humidity,
	$AVG_Temperature,
	$Max_Temperature,
	$Min_Temperature
	)";
	if ($conn->query($sql) === TRUE) {
	    echo "New record created successfully";
	} else {
	    echo "Error: " . $sql . "<br>" . $conn->error;
	}
} else {
	if($mac != null && $pass != null)
	{
		$sql = "INSERT INTO TemperatureMeasureSite.Sensor_Log (
			Sensor_ID,
			AVG_Humidity,
			Max_Humidity,
			Min_Humidity,
			AVG_Temperature,
			Max_Temperature,
			Min_Temperature,
			Mac_Address,
			Password
			)
			VALUES (
			$sensor_ID,
			$AVG_Humidity,
			$Max_Humidity,
			$Min_Humidity,
			$AVG_Temperature,
			$Max_Temperature,
			$Min_Temperature,
			$mac,
			$pass
		)";
		if ($conn->query($sql) === TRUE) {
			echo "New record created successfully";
		} else {
			echo "Error: " . $sql . "<br>" . $conn->error;
		}
	}
}




if($_GET['action'] == 'LAST')
{
	$result = $conn->query("Select * from Measurements_With_Differences");
        $resultArray = array();
        if ($result->num_rows > 0) {
		while($row = $result->fetch_assoc()) {
                	$resultArray[] = $row;
                }
	}
        echo json_encode($resultArray);
}

if($_GET['action'] == 'MyLasts')
{
	$UserName = $_GET['UserName'];
	$ApiKey = $_GET['ApiKey'];
//	$queryName = "xd";
	$sql = "SELECT *
			FROM (
			SELECT `temptable1`.`ID` AS `ID`,
			`temptable1`.`Sensor_Name` AS `Sensor_Name`, CONCAT(IF((HOUR(`temptable1`.`diffTime`) > 0), CONCAT(HOUR(`temptable1`.`diffTime`),' godzin '),''), IF((MINUTE(`temptable1`.`diffTime`) > 0), CONCAT(MINUTE(`temptable1`.`diffTime`),' minut '),''), SECOND(`temptable1`.`diffTime`),' sekund temu') AS `Timestamp_Of_Reading`,
			`temptable1`.`AVG_Humidity` AS `AVG_Humidity`,
			`temptable1`.`Max_Humidity` AS `Max_Humidity`,
			`temptable1`.`Min_Humidity` AS `Min_Humidity`,
			`temptable1`.`AVG_Temperature` AS `AVG_Temperature`,
			`temptable1`.`Max_Temperature` AS `Max_Temperature`,
			`temptable1`.`Min_Temperature` AS `Min_Temperature`
			FROM (
			SELECT `ttable`.`ID` AS `ID`,
			`ttable`.`Sensor_Name` AS `Sensor_Name`,
			`ttable`.`Timestamp_Of_Reading` AS `Timestamp_Of_Reading`,
			`ttable`.`AVG_Humidity` AS `AVG_Humidity`,
			`ttable`.`Max_Humidity` AS `Max_Humidity`,
			`ttable`.`Min_Humidity` AS `Min_Humidity`,
			`ttable`.`AVG_Temperature` AS `AVG_Temperature`,
			`ttable`.`Max_Temperature` AS `Max_Temperature`,
			`ttable`.`Min_Temperature` AS `Min_Temperature`, SEC_TO_TIME((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(`ttable`.`Timestamp_Of_Reading`))) AS `diffTime`
			FROM (
			SELECT *
			FROM RAW_Last_Measurements rlm
			JOIN Users us ON rlm.Sensor_Owner = us.User_ID
			WHERE us.UserName = '".$UserName."' AND us.API_KEY = '".$ApiKey."') `ttable`
						) `temptable1`
			WHERE ((MINUTE(`temptable1`.`diffTime`) < 5) AND (HOUR(`temptable1`.`diffTime`) = 0))
			ORDER BY `temptable1`.`diffTime`) ttj;";
	switch ($_GET['ApiVersion']) {
		case '1.1':
			$sql = "SELECT *
			FROM (
			SELECT `temptable1`.`ID` AS `ID`,
			`temptable1`.`Sensor_Name` AS `Sensor_Name`, 
			`temptable1`.`Timestamp_Of_Reading` AS `Timestamp_Of_Reading`,
			`temptable1`.`AVG_Humidity` AS `AVG_Humidity`,
			`temptable1`.`Max_Humidity` AS `Max_Humidity`,
			`temptable1`.`Min_Humidity` AS `Min_Humidity`,
			`temptable1`.`AVG_Temperature` AS `AVG_Temperature`,
			`temptable1`.`Max_Temperature` AS `Max_Temperature`,
			`temptable1`.`Min_Temperature` AS `Min_Temperature`
			FROM (
			SELECT `ttable`.`ID` AS `ID`,
			`ttable`.`Sensor_Name` AS `Sensor_Name`,
			`ttable`.`Timestamp_Of_Reading` AS `Timestamp_Of_Reading`,
			`ttable`.`AVG_Humidity` AS `AVG_Humidity`,
			`ttable`.`Max_Humidity` AS `Max_Humidity`,
			`ttable`.`Min_Humidity` AS `Min_Humidity`,
			`ttable`.`AVG_Temperature` AS `AVG_Temperature`,
			`ttable`.`Max_Temperature` AS `Max_Temperature`,
			`ttable`.`Min_Temperature` AS `Min_Temperature`, SEC_TO_TIME((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(`ttable`.`Timestamp_Of_Reading`))) AS `diffTime`
			FROM (
			SELECT *
			FROM RAW_Last_Measurements rlm
			JOIN Users us ON rlm.Sensor_Owner = us.User_ID
			WHERE us.UserName = '".$UserName."' AND us.API_KEY = '".$ApiKey."') `ttable`
						) `temptable1`
			WHERE ((MINUTE(`temptable1`.`diffTime`) < 5) AND (HOUR(`temptable1`.`diffTime`) = 0))
			ORDER BY `temptable1`.`diffTime`) ttj;";
			break;
		
		default:
			$sql = "SELECT *
			FROM (
			SELECT `temptable1`.`ID` AS `ID`,
			`temptable1`.`Sensor_Name` AS `Sensor_Name`, CONCAT(IF((HOUR(`temptable1`.`diffTime`) > 0), CONCAT(HOUR(`temptable1`.`diffTime`),' godzin '),''), IF((MINUTE(`temptable1`.`diffTime`) > 0), CONCAT(MINUTE(`temptable1`.`diffTime`),' minut '),''), SECOND(`temptable1`.`diffTime`),' sekund temu') AS `Timestamp_Of_Reading`,
			`temptable1`.`AVG_Humidity` AS `AVG_Humidity`,
			`temptable1`.`Max_Humidity` AS `Max_Humidity`,
			`temptable1`.`Min_Humidity` AS `Min_Humidity`,
			`temptable1`.`AVG_Temperature` AS `AVG_Temperature`,
			`temptable1`.`Max_Temperature` AS `Max_Temperature`,
			`temptable1`.`Min_Temperature` AS `Min_Temperature`
			FROM (
			SELECT `ttable`.`ID` AS `ID`,
			`ttable`.`Sensor_Name` AS `Sensor_Name`,
			`ttable`.`Timestamp_Of_Reading` AS `Timestamp_Of_Reading`,
			`ttable`.`AVG_Humidity` AS `AVG_Humidity`,
			`ttable`.`Max_Humidity` AS `Max_Humidity`,
			`ttable`.`Min_Humidity` AS `Min_Humidity`,
			`ttable`.`AVG_Temperature` AS `AVG_Temperature`,
			`ttable`.`Max_Temperature` AS `Max_Temperature`,
			`ttable`.`Min_Temperature` AS `Min_Temperature`, SEC_TO_TIME((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(`ttable`.`Timestamp_Of_Reading`))) AS `diffTime`
			FROM (
			SELECT *
			FROM RAW_Last_Measurements rlm
			JOIN Users us ON rlm.Sensor_Owner = us.User_ID
			WHERE us.UserName = '".$UserName."' AND us.API_KEY = '".$ApiKey."') `ttable`
						) `temptable1`
			WHERE ((MINUTE(`temptable1`.`diffTime`) < 5) AND (HOUR(`temptable1`.`diffTime`) = 0))
			ORDER BY `temptable1`.`diffTime`) ttj;";
			break;
	}
	$result = $conn->query($sql);
	$resultArray = array();
	if ($result->num_rows > 0) {
		while($row = $result->fetch_assoc()) {
			$resultArray[] = $row;
		}
	}
	echo json_encode($resultArray);	
}
if($_GET['action'] == 'validate')
{
	$UserName = $_GET['UserName'];
	$ApiKey = $_GET['ApiKey'];
	$UserValidation = "Failure";
	$sql = "Select UserName,API_KEY from Users";
	$result = $conn->query($sql);
	if ($result->num_rows > 0) {
	    while($row = $result->fetch_assoc()){
	        if($row["UserName"] == $UserName && $row["API_KEY"] == $ApiKey)
	        {
			$UserValidation = "Success";
	                break;
	        }
	    }
	}
	echo json_encode($UserValidation);
}
if($_GET['action'] == 'showSensors')
{
	$UserName = $_GET['UserName'];
	$ApiKey = $_GET['ApiKey'];
	$sql = "SELECT Sensor_Id,Sensor_Name
	FROM Sensors ss
	JOIN Users us
	ON ss.User_ID = us.User_ID
	WHERE us.UserName = '".$UserName."'
	AND us.API_KEY = '".$ApiKey."'";
	$result = $conn->query($sql);
	$resultArray = array();
	if ($result->num_rows > 0) {
		while($row = $result->fetch_assoc()) {
			$resultArray[] = $row;
		}
	}
	echo json_encode($resultArray);
}
if($_GET['action'] == 'showSensorAveraged')
{
	$startDate = $_GET['StartDate'];
	$endDate = $_GET['EndDate'];
	$sensor_ID = $_GET['Sensor_ID'];

	$sql = "SELECT 
	  'dateDay',ttj.dateDay,
	  'dateHour',ttj.dateHour,
	  'AVG_Temperature',ttj.AVG_Temperature,
	  'AVG_Humidity',ttj.AVG_Humidity
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
		sr.Timestamp_Of_Reading >= '".$startDate."' AND
		sr.Timestamp_Of_Reading <= '".$endDate."' and
		sr.Sensor_ID = '".$sensor_ID."'
	) xd
group by date(Timestamp_Of_Reading),(hour(Timestamp_Of_Reading))
ORDER BY dateDay,dateHour DESC
) ttj";
	$result = $conn->query($sql);
	$resultArray = array();
	if ($result->num_rows > 0) {
		while($row = $result->fetch_assoc()) {
			$resultArray[] = $row;
		}
	}
	echo json_encode($resultArray);
}




$conn->close();

?>


