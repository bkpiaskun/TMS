<?php
error_reporting(1);
ini_set('display_errors', 'On');
ini_set('display_startup_errors', 'On');


$servername = "localhost";
$username = "SensorSite";
$password = "SensorSite";
$dbname = "TemperatureMeasureSite";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
	echo $username;
	echo $password;
	die("Connection failed: " . $conn->connect_error);
}

//ID  Sensor_ID Timestamp_Of_Reading  AVG_Humidity  Max_Humidity  Min_Humidity  AVG_Temperature Max_Temperature Min_Temperature

$macadress = $_POST['MAC'];
$pass = $_POST['Password'];

$sensor_ID = 0;

$result = $conn->query("SELECT Sensor_Id,Sensor_Name,Mac_Address,Password FROM TemperatureMeasureSite.Sensors");
if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
		if($row["Mac_Address"] == $macadress && $row["Password"] == $pass)
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

	//echo "<p>".$sql."</p>";

	if ($conn->query($sql) === TRUE) {
	    echo "New record created successfully";
	} else {
	    echo "Error: " . $sql . "<br>" . $conn->error;
	}
}
$conn->close();

/*foreach ($_POST as $key => $value) {
  echo '<p>'.$key.'</p>';
  echo '<p>'.$value.'</p>';
}*/

/*foreach ($_GET as $key => $value) {
  echo '<p>'.$key.'</p>';
  echo '<p>'.$value.'</p>';
}*/
/*foreach (getallheaders()  as $key => $value) {
  echo '<p>'.$key.' -> ';
  echo $value.'</p>';
  }
*/
?>