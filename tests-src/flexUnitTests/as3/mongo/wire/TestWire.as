package flexUnitTests.as3.mongo.wire
{
	import as3.mongo.db.DB;
	import as3.mongo.wire.Wire;
	
	import flash.net.Socket;
	
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
	}
}