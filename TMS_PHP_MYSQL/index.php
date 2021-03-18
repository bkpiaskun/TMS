<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: *");
error_reporting(1);
ini_set('display_errors', 'On');
ini_set('display_startup_errors', 'On');

require 'logging_functions.php';

require 'creds.php';

require 'routes.php';

?>