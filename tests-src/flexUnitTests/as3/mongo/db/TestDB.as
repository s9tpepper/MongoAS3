package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.DB;
	import as3.mongo.wire.Wire;
	
	import flash.net.Socket;
	
	import org.osflash.signals.Signal;
	
	public class TestDB extends DB
	{
		public function TestDB(databaseName:String, host:String, port:uint)
		{
			super(databaseName, host, port);
		}
		
		public function set mockWire(mockedWire:Wire):void
		{
			_wire = mockedWire;
		}
		public function get mockWire():Wire
		{
			return _wire;
		}
		
	}
}