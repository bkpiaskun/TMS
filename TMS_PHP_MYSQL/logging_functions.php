<?php

function log( $message, $error_log_filename)
{
    $fp = fopen($error_log_filename, 'a');
    if($fp != false)
    {
        fwrite($fp, $message.PHP_EOL);
        fclose($fp);
    }
}

?>