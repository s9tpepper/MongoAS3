<?php
class Logger
{
	private static $instance;
	
	public static function getInstance()
	{
		if(!isset($instance))
			$instance = new Logger();
			
		return $instance;
	}
	
	function __construct()
	{
		
	}
	
	function log($message)
	{
		echo "[".date('Y-m-d')."] ".$message."\n";
	}
}
?>