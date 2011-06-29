package as3.mongo.wire
{
	import as3.mongo.db.DB;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.IMessage;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.Endian;

	public class Messenger
	{
		private var _wire:Wire;

		public function Messenger(aWire:Wire)
		{
			_initializeMessenger(aWire);
		}

		public function get wire():Wire
		{
			return _wire;
		}

		private function _initializeMessenger(aWire:Wire):void
		{
			_wire = aWire;
		}

		public function sendMessage(message:IMessage):void
		{
			_wire.socket.writeBytes(message.toByteArray());
			_wire.socket.flush();
		}
	}
}
