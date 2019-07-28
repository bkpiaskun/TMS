<?php
error_reporting(1);
ini_set('display_errors', 'On');
ini_set('display_startup_errors', 'On');

require 'creds.php';

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
//	echo $username;
//	echo $password;
	die("INTERNAL ERROR");
}
$pass = $_POST['Password'];
$sensor_ID = 0;
$result = $conn->query("SELECT Sensor_Id,Sensor_Name,Mac_Address,Password FROM TemperatureMeasureSite.Sensors");
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()){
	if($row["Mac_Address"] == $_POST['MAC'] && $row["Password"] == $pass)
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
}

if( $_GET["action"] == "DISP" )
{
	if(!empty($_GET['from']))
	{
		$timestamp2 = date($_GET['from']);
		$result = $conn->query("select ID,Sensors.Sensor_Name,Timestamp_Of_Reading,AVG_Humidity,Max_Humidity,Min_Humidity, AVG_Temperature, Max_Temperature, Min_Temperature 
	from Sensor_Readings
	inner join Sensors
	on Sensor_Readings.Sensor_ID = Sensors.Sensor_Id
	where Sensor_Readings.Timestamp_Of_Reading >= "."'".$timestamp2."';");
		$resultArray = array();
		if ($result->num_rows > 0) {
		    while($row = $result->fetch_assoc()) {
			$resultArray[] = $row;
		   }
		}
		echo json_encode($resultArray);
	}
	else
	{
		$result = $conn->query("select * from (
			select ID,Sensors.Sensor_Name,Timestamp_Of_Reading,AVG_Humidity,Max_Humidity,Min_Humidity, AVG_Temperature, Max_Temperature,Min_Temperature
			from Sensor_Readings
			inner join Sensors
			on Sensor_Readings.Sensor_ID = Sensors.Sensor_Id
			order by ID desc limit 500) sub
			order by ID asc");
		$resultArray = array();
		if ($result->num_rows > 0) {
		    while($row = $result->fetch_assoc()) {
			$resultArray[] = $row;
		   }
		}
		echo json_encode($resultArray);
	}
}

if($_GET['action'] == 'LAST')
{
	$result = $conn->query("Select * from LAST_Measurements");
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

