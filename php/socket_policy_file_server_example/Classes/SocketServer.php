<?php
class SocketServer
{
	var $ip;
	var $port;
	
	var $masterSocket;
	
	var $logger;
	
	private $currentSockets;
	
	function __construct($ip, $port)
	{
		$this->ip = $ip;
		$this->port = $port;
		
		$this->logger = Logger::getInstance();
		
		$this->initSocket();
		$this->currentSockets = array();
		
		$this->currentSockets[] = $this->masterSocket;	
		
		$this->listenToSockets();
	}
	
	private function initSocket()
	{
		//---- Start Socket creation for PHP 5 Socket Server -------------------------------------
	 
		if (($this->masterSocket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP)) < 0) 
		{
			//$this->logger->log("[SocketServer] "."socket_create() failed, reason: " . socket_strerror($this->masterSocket));
		}
		 
		socket_set_option($this->masterSocket, SOL_SOCKET,SO_REUSEADDR, 1);
						 
		if (($ret = socket_bind($this->masterSocket, $this->ip, $this->port)) < 0)
		{
			//$this->logger->log("[SocketServer] "."socket_bind() failed, reason: " . socket_strerror($ret));
		}
		 
		 
		if (($ret = socket_listen($this->masterSocket, 5)) < 0)
		{
			//$this->logger->log("[SocketServer] "."socket_listen() failed, reason: " . socket_strerror($ret));	
		}
	}
	
	private function parseRequest($socket, $data)
	{
		if (preg_match("/policy-file-request/i", $data) or preg_match("/crossdomain/i", $data))
		{
			//$this->logger->log("POLICY FILE REQUEST\n");
			//$crossFile = file("crossdomain.xml");
			$crossFile =
			    '<'.'?xml version="1.0" encoding="UTF-8"?'.'>'.
			    '<cross-domain-policy xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.adobe.com/xml/schemas/PolicyFileSocket.xsd">'.
			        '<allow-access-from domain="*" to-ports="*" secure="false" />'.
			        '<site-control permitted-cross-domain-policies="master-only" />'.
			    '</cross-domain-policy>';
			$this->sendMessage(array($socket),$crossFile);			
			return;
		}
	}
	
	public function sendMessage($sockets, $message)
	{
		if(!is_array($sockets))
			$sockets = array($sockets);
	
		foreach($sockets as $socket)
		{
			if($socket === NULL)
				continue;
				
			socket_write($socket, $message.chr(0));//, strlen($message)); 
			
			//$this->logger->log("[SocketServer] Wrote : ".$message." to ".$socket);
		}
	}
	
	private function listenToSockets()
	{
		//---- Create Persistent Loop to continuously handle incoming socket messages ---------------------
		while (true) {
		
			$changed_sockets = $this->currentSockets;
		 
			$num_changed_sockets = socket_select($changed_sockets, $write = NULL, $except = NULL, NULL);
		 
			foreach($changed_sockets as $socket) 
			{
				if ($socket == $this->masterSocket) {
					if (($client = socket_accept($this->masterSocket)) < 0) {
						//$this->logger->log("[SocketServer] "."socket_accept() failed: reason: " . socket_strerror($socket));
						continue;
					} else {
						
						// NEW CLIENT HAS CONNECTED
						$this->currentSockets[] = $client;
						socket_getpeername($client, $newClientAddress);
						//$this->logger->log("[SocketServer] "."NEW CLIENT ".$client." [IP: ".$newClientAddress."]");						
					}
				} else {
		 			$bytes = socket_recv($socket, $buffer, 4096, 0);
		 
					if ($bytes == 0) {
						
						// CLIENT HAS DISCONNECTED
						//$this->logger->log("[SocketServer] "."REMOVING CLIENT ".$socket);
						$index = array_search($socket, $this->currentSockets);
						
						// Remove Socket from List
						unset($this->currentSockets[$index]);				
											
						socket_close($socket);
					
					}else{
						
						// CLIENT HAS SENT DATA
						$this->parseRequest($socket, $buffer);
					}
				}
			}
		}
	}
}
?>