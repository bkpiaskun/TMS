<?php

$action = $_GET['action'];

$ApiVersion_G = $_GET['ApiVersion'];
$ApiVersion_P = $_POST['ApiVersion'];

$AVG_Humidity = $_POST['AVG_Humidity'];
$Max_Humidity = $_POST['Max_Humidity'];
$Min_Humidity = $_POST['Min_Humidity'];
$AVG_Temperature = $_POST['AVG_Temperature'];
$Max_Temperature = $_POST['Max_Temperature'];
$Min_Temperature = $_POST['Min_Temperature'];
$Sensor_PIN = $_POST['Sensor_PIN'];
$pass = $_POST['Password'];
$mac = $_POST['MAC'];

$log_result = $_POST['Log_Result'];
$log_error = $_POST['Log_Error'];

$UserName = $_GET['UserName'];
$ApiKey = $_GET['ApiKey'];
$startDate = $_GET['StartDate'];
$endDate = $_GET['EndDate'];
$Sensor_ID = $_GET['Sensor_ID'];

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    log_Error("mysql failed");
	die('[{"status": "Error"}]');
}

if ($action == 'GetNextFW' && $mac != null && $pass != null) {
	
	$stmt = $conn->prepare("SELECT fw.FW_Link as 'Link',fw.IS_EEPROM_Updater as 'Is_EEPROM_updater',fwv.FW_VER_NAME as 'Version_Name'
    FROM Devices dv
    JOIN Device_Types dvt ON dv.Device_Type = dvt.Type_ID
    JOIN Firmware_Instances fwi ON fwi.FW_IN_ID = dv.Current_FW
    JOIN Firmware_Instances fwN ON fwN.FW_IN_ID = fwi.FW_Next
    JOIN Firmwares fw ON fw.FW_ID = fwN.FW_ID
    JOIN Firmware_Versions fwv ON fw.FW_VER = fwv.FW_VER_ID
    WHERE Mac_Address = '?' AND PASSWORD = '?'
    AND NOT (Updates_Disabled_Date IS not NULL AND Updates_Disabled_Date > NOW());");
	if(!$stmt)
        log_Error("GetNextFW prepare failed");
		die('[{"status": "Error"}]');
    
    $stmt->bind_param("ss", $mac, $pass);
    
    if ($stmt->execute()) {
        $result = $stmt->get_result();

        $resultArray = array();
        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                $resultArray[] = $row;
            }
        }
        else
        {
            die('[{"status": "No Updates Available"}]');
        }
    } else {
        log_Error("GetNextFW statement execute failed");
		die('[{"status": "Error"}]');
    }
	echo json_encode($resultArray);
}
if ($action == 'FWU_Log' && $log_result != null && $log_error != null && $mac != null && $pass != null) {
    $stmt = $conn->prepare("call Handle_Device_Log(?,?,?,?);");
		if(!$stmt)
        {
            log_Error("FWU_Log statement prepare failed");
			die('[{"status": "Error"}]');
        }

		$stmt->bind_param("ssss", $log_result, $log_error, $mac, $pass);
		if ($stmt->execute()) {
			echo "<p>New record created successfully</p>";
		} else {
            log_Error("FWU_Log statement ezecute failed");
            log_Error("Error: " . $sql . "<br>" . $conn->error);
			die('[{"status": "Error"}]');
		}
}
if ($action == 'getWIFINETWORKS' && $mac != null && $pass != null) {
    
    $stmt = $conn->prepare("SELECT wifi_n.wifi_ssid,wifi_n.WIFI_Pass
    FROM Wifi_Networks wifi_n
    JOIN Wifi_Assigned wifi_in ON wifi_n.WIFI_ID = wifi_in.WIFI_ID
    JOIN Devices dv ON dv.Device_ID = wifi_in.Device_ID
    WHERE dv.Mac_Address = ? AND dv.Password = ? and wifi_in.active = TRUE");
    if(!$stmt)
    {
        log_Error("getWIFINETWORKS statement prepare failed");
        die('[{"status": "Error"}]');
    }

    $stmt->bind_param("ss", $mac, $pass);
    if ($stmt->execute()) {
        $result = $stmt->get_result();

        $resultArray = array();
        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                $resultArray[] = $row;
            }
        }
        else
        {
            die('[{"status": "No wifi\'s registered"}]');
        }
    } else {
        log_Error("getWIFINETWORKS statement execute failed");
        log_Error("Error: " . $sql . "<br>" . $conn->error);
        die('[{"status": "Error"}]');
    }

    echo json_encode($resultArray);
}




function log_Error( $message )
{
    $fp = fopen($OTA_Error_LOG, 'a');
    if($fp != false)
    {
        fwrite($fp, $message.PHP_EOL);
        fclose($fp);
    }
}
?>