<form>
	<p>MAC: <input type="text" name="MAC" /></p>
	<p>pass: <input type="text" name="Password" /></p>
	<p>AVG_Humidity: <input type="text" name="AVG_H" /></p>
	<p>Max_Humidity: <input type="text" name="MAX_H" /></p>
	<p>Min_Humidity: <input type="text" name="MIN_H" /></p>
	<p>AVG_Temperature: <input type="text" name="AVG_T" /></p>
	<p>Max_Temperature: <input type="text" name="MAX_T" /></p>
	<p>Min_Temperature: <input type="text" name="MIN_T" /></p>
	<input type="submit" name="submit" value="Save">
</form>
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
    die("Connection failed: " . $conn->connect_error);
}

//ID  Sensor_ID Timestamp_Of_Reading  AVG_Humidity  Max_Humidity  Min_Humidity  AVG_Temperature Max_Temperature Min_Temperature

$macadress = $_GET['MAC'];
$pass = $_GET['Password'];

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
	$AVG_Humidity = $_GET['AVG_H'];
	$Max_Humidity = $_GET['MAX_H'];
	$Min_Humidity = $_GET['MIN_H'];
	$AVG_Temperature = $_GET['AVG_T'];
	$Max_Temperature = $_GET['MAX_T'];
	$Min_Temperature = $_GET['MIN_T'];

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

	echo "<p>".$sql."</p>";

	if ($conn->query($sql) === TRUE) {
	    echo "New record created successfully";
	} else {
	    echo "Error: " . $sql . "<br>" . $conn->error;
	}
}
$conn->close();
?>