<?php

session_start();


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

$UserName = $_GET['UserName'];
$ApiKey = $_GET['ApiKey'];
$startDate = $_GET['StartDate'];
$endDate = $_GET['EndDate'];
$Sensor_ID = $_GET['Sensor_ID'];


$UserName_P = $_POST['UserName'];
$Name_P = $_POST['Name'];
$Surname_P = $_POST['Surname'];
$Email_P = $_POST['Email'];
$Pass_P = $_POST['Password'];


$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
	die('[{"status": "Error"}]');
}

if($action == null){
	$Sensor_ID = -1;
	
	if($ApiVersion_P == null)
	{
		if(!$stmt = $conn->prepare("SELECT Sensor_ID FROM Devices dv Join Sensors sen on dv.Device_ID = sen.Device_ID where Mac_Address = ? and Password = ?"))
		{
			die('[{"status": "Error"}]');
		}
		$stmt->bind_param("ss", $mac, $pass);
	} else {
		if(!$stmt = $conn->prepare("SELECT Sensor_ID FROM Devices dv Join Sensors sen on dv.Device_ID = sen.Device_ID where Mac_Address = ? and Password = ? and PIN = ?"))
		{
			die('[{"status": "Error"}]');
		}
		$stmt->bind_param("sss", $mac, $pass, $Sensor_PIN);
	}
	$stmt->execute();
	$result = $stmt->get_result();
	if ($result->num_rows > 0) {
		while ($row = $result->fetch_assoc()) {
			$Sensor_ID = $row["Sensor_ID"];
		}
	}
	if($Sensor_ID != -1)
	{
		if ($AVG_Humidity == null) {
			$AVG_Humidity = -1;
			$Max_Humidity = -1;
			$Min_Humidity = -1;
		}

		$stmt = $conn->prepare("INSERT INTO Sensor_Readings 
		( Sensor_ID, AVG_Humidity, Max_Humidity, Min_Humidity, AVG_Temperature, Max_Temperature, Min_Temperature )
		VALUES 
		( ?,?,?,?,?,?,? )");
		if(!$stmt)
			die('[{"status": "Error"}]');

		$stmt->bind_param("idddddd", $Sensor_ID, $AVG_Humidity, $Max_Humidity, $Min_Humidity, $AVG_Temperature, $Max_Temperature, $Min_Temperature);
		if ($stmt->execute()) {
			echo "<p>New record created successfully</p>";
		} else {
			echo "<p>Error: " . $sql . "<br>" . $conn->error . "</p>";
		}
	} else {
		$stmt = $conn->prepare("INSERT INTO Sensor_Log
			( Sensor_ID, AVG_Humidity, Max_Humidity, Min_Humidity, AVG_Temperature, Max_Temperature, Min_Temperature, Mac_Address, Password, PIN )
			VALUES 
			( ?,?,?,?,?,?,?,?,?,? )");
		if(!$stmt)
			die('[{"status": "Error"}]');

		$stmt->bind_param("iddddddssi", $Sensor_ID, $AVG_Humidity, $Max_Humidity, $Min_Humidity, $AVG_Temperature, $Max_Temperature, $Min_Temperature, $mac, $pass, $Sensor_PIN);
		if ($stmt->execute()) {
			echo "<p>New record created successfully</p>";
		} else {
			echo "<p>Error: " . $sql . "<br>" . $conn->error . "</p>";
		}
	}
}
if ($action == 'LAST') {
	$result = $conn->query("Select * from Measurements_With_Differences");
	$resultArray = array();
	if ($result->num_rows > 0) {
		while ($row = $result->fetch_assoc()) {
			$resultArray[] = $row;
		}
	}
	echo json_encode($resultArray);
}
if ($action == 'MyLasts') {
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
			WHERE us.UserName = '" . $UserName . "' AND us.API_KEY = '" . $ApiKey . "') `ttable`
						) `temptable1`
			WHERE ((MINUTE(`temptable1`.`diffTime`) < 5) AND (HOUR(`temptable1`.`diffTime`) = 0))
			ORDER BY `temptable1`.`diffTime`) ttj;";
	switch ($ApiVersion_G) {
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
			WHERE us.UserName = '" . $UserName . "' AND us.API_KEY = '" . $ApiKey . "') `ttable`
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
			WHERE us.UserName = '" . $UserName . "' AND us.API_KEY = '" . $ApiKey . "') `ttable`
						) `temptable1`
			WHERE ((MINUTE(`temptable1`.`diffTime`) < 5) AND (HOUR(`temptable1`.`diffTime`) = 0))
			ORDER BY `temptable1`.`diffTime`) ttj;";
			break;
	}
	$result = $conn->query($sql);
	$resultArray = array();
	if ($result->num_rows > 0) {
		while ($row = $result->fetch_assoc()) {
			$resultArray[] = $row;
		}
	}
	echo json_encode($resultArray);
}
if ($action == 'validate') {
	$UserValidation = "Failure";
	$sql = "Select UserName,API_KEY from Users";
	$result = $conn->query($sql);
	if ($result->num_rows > 0) {
		while ($row = $result->fetch_assoc()) {
			if ($row["UserName"] == $UserName && $row["API_KEY"] == $ApiKey) {
				$UserValidation = "Success";
				break;
			}
		}
	}
	echo json_encode($UserValidation);
}
if ($action == 'showSensors') {
	$sql = "SELECT Sensor_ID,Sensor_Name
	FROM Sensors ss
	JOIN Devices dv
	on dv.Device_ID = ss.Device_ID
	JOIN Users us
	ON dv.User_ID = us.User_ID
	WHERE us.UserName = '" . $UserName . "'
	AND us.API_KEY = '" . $ApiKey . "'";
	$result = $conn->query($sql);
	$resultArray = array();
	if ($result->num_rows > 0) {
		while ($row = $result->fetch_assoc()) {
			$resultArray[] = $row;
		}
	}
	echo json_encode($resultArray);
}
if ($action == 'showSensorAveraged') {

	$sql = "SELECT 
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
			sr.Timestamp_Of_Reading >= '" . $startDate . "' AND
			sr.Timestamp_Of_Reading <= '" . $endDate . "' and
			sr.Sensor_ID = '" . $Sensor_ID . "'
		) xd
	group by date(Timestamp_Of_Reading),(hour(Timestamp_Of_Reading))
	ORDER BY dateDay ASC,dateHour ASC
	) ttj";
	$result = $conn->query($sql);
	$resultArray = array();
	if ($result->num_rows > 0) {
		while ($row = $result->fetch_assoc()) {
			$resultArray[] = $row;
		}
	}
	echo json_encode($resultArray);
}
if ($action == 'showAveragedData') {

	$sql = "SELECT
          ttj.dateDay,
          ttj.dateHour,
          ttj.AVG_Temperature,
          ttj.AVG_Humidity,
          ttj.Sensor_Name
	from (
	select
        date(Timestamp_Of_Reading) dateDay,
        (hour(Timestamp_Of_Reading)) dateHour,
   avg(AVG_Temperature) AVG_Temperature,
        avg(AVG_Humidity) AVG_Humidity,
        Sensor_Name
	FROM (
        SELECT Timestamp_Of_Reading,AVG_Temperature,AVG_Humidity,Sensor_Name
        FROM Sensor_Readings sr
        JOIN Sensors snrs
        ON sr.Sensor_ID = snrs.Sensor_ID
		JOIN Devices dv
		ON dv.Device_ID = snrs.Device_ID
        JOIN Users usr
        ON usr.User_ID = dv.User_ID
        WHERE
                sr.Timestamp_Of_Reading >= '" . $startDate . "' AND
                sr.Timestamp_Of_Reading <= '" . $endDate . "' AND
                usr.UserName like '" . $UserName . "' AND
                usr.API_KEY like '" . $ApiKey . "'
        ) xd
	group BY Sensor_Name,date(Timestamp_Of_Reading),(hour(Timestamp_Of_Reading))
	ORDER BY Sensor_Name,dateDay ASC,dateHour ASC
	) ttj";
	$result = $conn->query($sql);
	$resultArray = array();
	if ($result->num_rows > 0) {
		while ($row = $result->fetch_assoc()) {
			$resultArray[] = $row;
		}
	}
	echo json_encode($resultArray);
}
if ($action == 'status') {
	echo '[{"status": "Working"}]';
}

if ($action == 'register' && $Name_P != null && $Surname_P != null && $UserName_P != null && $Email_P != null && $Pass_P != null) {
	$stmt = $conn->prepare("SELECT User_ID FROM Users WHERE UserName = ?");
	if(!$stmt)
    {   
		log_Error("validate username prepare failed");
		log_Error($UserName_P);
		die('[{"error": "Internal Error"}]');
    }

    $stmt->bind_param("s", $UserName_P);
    if ($stmt->execute()) {
        $result = $stmt->get_result();

        $resultArray = array();
        if ($result->num_rows > 0) {
			die('[{"error": "Username_Already_Exists"}]');
        }
    } else {
        log_Error("register statement execute failed");
		die('[{"error": "Internal Error"}]');
    }
	
	$stmt = $conn->prepare("insert into Users ( UserName, Name, Surname, Email, Password, API_KEY, Session_ID, Last_action_date ) values (?, ?, ?, ?, ?, create_apikey(), ?, now())");
	if(!$stmt)
    {
	    log_Error("register prepare failed");
		log_Error($UserName_P,',', $Name_P,',', $Surname_P,',', $Email_P,',', $Pass_P);
		die('[{"status": "Internal Error"}]');
    }

    $stmt->bind_param("ssssss", $UserName_P, $Name_P, $Surname_P, $Email_P, $Pass_P, session_id());
    if (!$stmt->execute()) {
        log_Error("register statement execute failed");
		die('[{"error": "Internal Error"}]');
    }

	$stmt = $conn->prepare("SELECT User_ID,API_KEY FROM Users WHERE UserName = ?");
	if(!$stmt)
    {
		log_Error("get user_ID from new created user PREPARE FAILED");
		log_Error($UserName_P);
		die('[{"error": "Internal Error"}]');
    }

    $stmt->bind_param("s", $UserName_P);
    if ($stmt->execute()) {
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
			$row = $result->fetch_assoc();
			session_regenerate_id();
			$_SESSION['User_ID'] = $row['User_ID'];
			$_SESSION['API_KEY'] = $row['API_KEY'];
			$arr = array();
			$arr['Session_ID'] = session_id();
			$arr['API_KEY'] = $row['API_KEY'];
			update_last_action_date($conn);
			die('['.json_encode($arr).']');
		}
		else 
		{
			log_Error("register statement execute failed");
			die('[{"error": "Internal Error"}]');
		}
    } else {
        log_Error("register statement execute failed");
		die('[{"error": "Internal Error"}]');
    }
}

if ($action == 'login' && $UserName_P != null && $Pass_P != null) {
	
	$stmt = $conn->prepare("SELECT User_ID,API_KEY FROM Users WHERE UserName = ? and Password = ?");
	if(!$stmt)
    {
		log_Error("get user data to login PREPARE FAILED");
		log_Error($UserName_P);
		die('[{"error": "Internal Error"}]');
    }

    $stmt->bind_param("ss", $UserName_P, $Pass_P);
    if ($stmt->execute()) {
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
			session_regenerate_id();
			$_SESSION['User_ID'] = $row['User_ID'];
			$_SESSION['API_KEY'] = $row['API_KEY'];
			$arr = array();
			$arr['Session_ID'] = session_id();
			$arr['API_KEY'] = $row['API_KEY'];
			update_last_action_date($conn);
			die('['.json_encode($arr).']');
		}
		else 
		{
			log_Error("login statement execute failed");
			die('[{"error": "Internal Error"}]');
		}
    } else {
        log_Error("login statement execute failed");
		die('[{"error": "Internal Error"}]');
    }
}

if ($action == 'logout' && session_id() != null && $_SESSION['User_ID'] != null && $_SESSION['API_KEY'] != null) {
	$stmt = $conn->prepare("update Users set Session_ID = null, Last_action_date = now() WHERE User_ID = ? and API_KEY = ?");
	if(!$stmt)
    {
		log_Error("logout update PREPARE FAILED");
		log_Error($_SESSION['User_ID'], $_SESSION['API_KEY']);
		die('[{"error": "Internal Error"}]');
    }

    $stmt->bind_param("ss", $_SESSION['User_ID'], $_SESSION['API_KEY']);
    if ($stmt->execute()) {
        session_destroy();
		die('[{"status": "Logout Successful"}]');
    } else {
        log_Error("logout update execute failed");
		die('[{"error": "Internal Error"}]');
    }
}



function update_last_action_date( $conn )
{
    $stmt = $conn->prepare("UPDATE Users SET Last_Action_Date = NOW(), Session_ID = ? WHERE User_ID = ?");
	if(!$stmt)
    {
	    log_Error("update_last_action_date prepare failed");
		die('[{"status": "Internal Error"}]');
    }
    $stmt->bind_param("ss", session_id(), $_SESSION['User_ID']);
    if (!$stmt->execute()) {
        log_Error("update_last_action_date execute failed");
		die('[{"error": "Internal Error"}]');
    }
}

$conn->close();
