#!/usr/bin/php -q
<?php
error_reporting(E_ALL);
 
set_time_limit(0);
 
ob_implicit_flush();

function __autoload ($className)
{
    $fileName = "Classes/".str_replace('_', DIRECTORY_SEPARATOR, $className) . '.php';
    $status = (@include_once $fileName);
       
    if ($status === false) {
        eval(sprintf('class %s {func' . 'tion __construct(){throw new Project_Exception_AutoLoad("%s");}}', $className, $className));
    }  
}

$ip = '[YOUR.MONGODBHOSTIP.COM]';
$port = 843;

try{
  $mySocketServer = new SocketServer($ip, $port);
} catch (Project_Exception_AutoLoad $e) {
    echo "FATAL ERROR: CAN'T FIND SOCKET SERVER CLASS.";
}

?>