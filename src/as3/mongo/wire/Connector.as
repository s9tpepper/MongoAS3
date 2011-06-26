package as3.mongo.wire
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	public class Connector
	{
		private var _wire:Wire;

		public function Connector(aWire:Wire)
		{
			_initializeConnector(aWire);
		}

		public function get wire():Wire
		{
			return _wire;
		}

		private function _initializeConnector(aWire:Wire):void
		{
			_wire = aWire;
			_wire.socket.addEventListener(IOErrorEvent.IO_ERROR, _handleSocketError, false, 0, true);
			_wire.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _handleSecurityError, false, 0, true);
			_wire.socket.addEventListener(Event.CONNECT, _handleSocketConnect, false, 0, true);
		}

		public function connect():void
		{
			_wire.socket.connect(_wire.db.host, _wire.db.port);
		}

		private function _handleSecurityError(event:Event):void
		{
			_wire.db.SOCKET_POLICY_FILE_ERROR.dispatch(_wire.db);
		}

		private function _handleSocketError(event:Event):void
		{
			_wire.db.CONNECTION_FAILED.dispatch(_wire.db);
		}

		private function _handleSocketConnect(event:Event):void
		{
			_wire.setConnected(true);
			_wire.db.CONNECTED.dispatch(_wire.db);
		}
	}
}
