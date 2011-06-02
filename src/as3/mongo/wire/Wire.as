package as3.mongo.wire
{
	import as3.mongo.db.DB;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	
	import org.osflash.signals.Signal;

	public class Wire
	{
		protected var _socket:Socket;
		private var _db:DB;
		
		private var _isConnected:Boolean;

		public function get socket():Socket
		{
			return _socket;
		}

		public function get isConnected():Boolean
		{
			return _isConnected;
		}

		public function Wire(db:DB)
		{
			_initializeWire(db);
		}
		
		private function _initializeWire(db:DB):void
		{
			_db = db;
			_socket = new Socket(_db.host, _db.port);
		}
		
		public function connect():void
		{
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _handleSecurityError, false, 0, true);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, _handleSocketError, false, 0, true);
			_socket.addEventListener(Event.CONNECT, _handleSocketConnect, false, 0, true);
			_socket.connect(_db.host, _db.port);
		}
		
		private function _handleSecurityError(event:Event):void
		{
			_db.SOCKET_POLICY_FILE_ERROR.dispatch(_db);
		}
		
		private function _handleSocketError(event:Event):void
		{
			_db.CONNECTION_FAILED.dispatch(_db);
		}
		
		private function _handleSocketConnect(event:Event):void
		{
			_isConnected = true;
			_db.CONNECTED.dispatch(_db);
		}
	}
}