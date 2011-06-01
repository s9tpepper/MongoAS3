package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.DB;
	
	import flash.net.Socket;
	
	import org.osflash.signals.Signal;
	
	public class TestDB extends DB
	{
		public function TestDB(databaseName:String, host:String, port:uint)
		{
			super(databaseName, host, port);
		}
		
		public function set mockSocket(mockedSocket:Socket):void
		{
			socket = mockedSocket;
		}
	}
}