package as3.mongo.wire
{
	import as3.mongo.db.DB;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.IMessage;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;

	public class Messenger
	{
		private var _wire:Wire;
		private var _cursorFactory:CursorFactory;

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
			_cursorFactory = new CursorFactory();
		}

		private function _sendMessage(message:IMessage):void
		{
			_wire.socket.writeBytes(message.toByteArray());
			_wire.socket.flush();
		}

		private function _setReadAllDocumentsCallback(readAllDocumentsCallback:Function):void
		{
			if (readAllDocumentsCallback is Function)
				Cursor.REPLY_COMPLETE.addOnce(readAllDocumentsCallback);
		}

		public function sendMessage(message:IMessage, readAllDocsCallback:Function):Cursor
		{
			_setReadAllDocumentsCallback(readAllDocsCallback);
			const cursor:Cursor = new Cursor(_wire.socket);
			_sendMessage(message);
			return cursor;
		}
	}
}
