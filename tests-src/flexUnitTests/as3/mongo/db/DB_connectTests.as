package flexUnitTests.as3.mongo.db
{
	import ab.flex.utils.flexunit.signals.AsyncSignalHandler;
	import ab.flex.utils.flexunit.signals.AsyncSignalHandlerEvent;
	
	import as3.mongo.db.DB;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	
	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	public class DB_connectTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock(inject="true", type="nice")]
		public var socket:Socket;
		
		private var _testDBName:String = "testDBName";
		private var _testHost:String = "host";
		private var _testPort:Number = 2;
		private var _db:TestDB;
		
		[Before]
		public function setUp():void
		{
			_db = new TestDB(_testDBName, _testHost, _testPort);
		}
		
		[After]
		public function tearDown():void
		{
			_db = null;
		}
		
		
		[Test]
		public function connect_allScenarios_socketConnectIsInvoked():void
		{
			mock(socket).method("connect").args(_testHost, _testPort);
			_db.mockSocket = socket;
			
			_db.connect();
			
			assertThat(socket, received().method("connect").args(_testHost, _testPort));
		}
		
		[Test(async)]
		public function connect_socketConnects_connectedSignalDispatched():void
		{
			mock(socket).method("connect").args(_testHost, _testPort).dispatches(new Event(Event.CONNECT));
			_db.mockSocket = socket;
			
			new AsyncSignalHandler(this, _db.CONNECTED, _handleMongoConnected);
			
			_db.connect();
		}
		private function _handleMongoConnected(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertEquals(_db, event.getSignalArgument(0));
		}
		
		[Test(async)]
		public function connect_socketConnects_isConnectedReturnsTrue():void
		{
			mock(socket).method("connect").args(_testHost, _testPort).dispatches(new Event(Event.CONNECT));
			_db.mockSocket = socket;
			
			new AsyncSignalHandler(this, _db.CONNECTED, _handleMongoConnectedCheckIsConnected);
			
			_db.connect();
		}
		private function _handleMongoConnectedCheckIsConnected(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertTrue(_db.isConnected);
		}
		
		[Test(async)]
		public function connect_socketThrowsIOError_connectionFailedSignalDispatched():void
		{
			const ioErrorEvent:Event = new Event(IOErrorEvent.IO_ERROR);
			mock(socket).method("connect").args(_testHost, _testPort).dispatches(ioErrorEvent);
			_db.mockSocket = socket;
			
			new AsyncSignalHandler(this, _db.CONNECTION_FAILED, _handleMongoConnectionFailed);
			
			_db.connect();
		}
		private function _handleMongoConnectionFailed(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertEquals(_db, event.getSignalArgument(0));
		}
		
		[Test(async)]
		public function connect_securityError_socketPolicyFileErrorSignalDispatched():void
		{
			const securityError:Event = new Event(SecurityErrorEvent.SECURITY_ERROR);
			mock(socket).method("connect").args(_testHost, _testPort).dispatches(securityError);
			_db.mockSocket = socket;
			
			new AsyncSignalHandler(this, _db.SOCKET_POLICY_FILE_ERROR, _handleSocketPolicyFileError);
			
			_db.connect();
		}
		private function _handleSocketPolicyFileError(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertEquals(_db, event.getSignalArgument(0));
		}
	}
}