package flexUnitTests.as3.mongo.wire
{
	import as3.mongo.db.DB;
	import as3.mongo.wire.Wire;
	import as3.mongo.wire.cursor.CursorFactory;
	import as3.mongo.wire.messages.MessageFactory;
	
	import flash.net.Socket;
	
	import org.bson.BSONEncoder;
	import org.osflash.signals.Signal;
	
	public class TestWire extends Wire
	{
		private var _connected:Signal = new Signal(DB);
		
		public function TestWire(db:DB)
		{
			super(db);
		}
		
		public function set mockSocket(mockedSocket:Socket):void
		{
			_socket = mockedSocket;
		}
		
		public function set mockMessageFactory(mockedMessageFactor:MessageFactory):void
		{
			_messageFactory = mockedMessageFactor;
		}

		public function set mockCursorFactory(mockedCursorFactory:CursorFactory):void
		{
			_cursorFactory = mockedCursorFactory;
		}
	}
}