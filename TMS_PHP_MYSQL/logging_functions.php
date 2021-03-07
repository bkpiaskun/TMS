<?php

function log_Error( $message )
{
    $fp = fopen($Error_LOG_filename, 'a');
    if($fp != false)
    {
        fwrite($fp, $message.PHP_EOL);
        fclose($fp);
    }
}

?>