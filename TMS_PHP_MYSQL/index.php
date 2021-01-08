<?php
header('Access-Control-Allow-Origin: *');

error_reporting(1);
ini_set('display_errors', 'On');
ini_set('display_startup_errors', 'On');
require 'creds.php';


$AVG_Humidity = $_POST['AVG_Humidity'];
$Max_Humidity = $_POST['Max_Humidity'];
$Min_Humidity = $_POST['Min_Humidity'];
$AVG_Temperature = $_POST['AVG_Temperature'];
$Max_Temperature = $_POST['Max_Temperature'];
$Min_Temperature = $_POST['Min_Temperature'];
$ApiVersion = $_GET['ApiVersion'];
$ApiVersion = $_POST['ApiVersion'];
$Sensor_PIN = $_POST['Sensor_PIN'];
$pass = $_POST['Password'];
$mac = $_POST['MAC'];
$UserName = $_GET['UserName'];
$ApiKey = $_GET['ApiKey'];

$startDate = $_GET['StartDate'];
$endDate = $_GET['EndDate'];
$sensor_ID = $_GET['Sensor_ID'];

echo "ApiVersion: " . $ApiVersion; 
echo "Sensor_PIN: " . $Sensor_PIN;


require 'routes.php';

?>