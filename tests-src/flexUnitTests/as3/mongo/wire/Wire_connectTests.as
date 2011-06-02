package flexUnitTests.as3.mongo.wire
{
	import ab.flex.utils.flexunit.signals.AsyncSignalHandler;
	import ab.flex.utils.flexunit.signals.AsyncSignalHandlerEvent;
	
	import as3.mongo.db.DB;
	import as3.mongo.wire.Wire;
	
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
	
	public class Wire_connectTests
	{		
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock(inject="true", type="nice")]
		public var socket:Socket;
		
		public var testDB:DB;
		
		private var _testDBName:String = "testDBName";
		private var _testHost:String = "host";
		private var _testPort:Number = 2;
		
		private var _wire:TestWire;
		
		[Before]
		public function setUp():void
		{
			testDB = new DB(_testDBName, _testHost, _testPort);
			_wire = new TestWire(testDB);
		}
		
		[After]
		public function tearDown():void
		{
			_wire = null;
		}
		
		
		[Test]
		public function connect_allScenarios_socketConnectIsInvoked():void
		{
			mock(socket).method("connect").args(_testHost, _testPort);
			_wire.mockSocket = socket;
			
			_wire.connect();
			
			assertThat(socket, received().method("connect").args(_testHost, _testPort));
		}
		
		[Test(async)]
		public function connect_socketConnects_connectedSignalDispatched():void
		{
			mock(socket).method("connect").args(_testHost, _testPort).dispatches(new Event(Event.CONNECT));
			_wire.mockSocket = socket;
			
			new AsyncSignalHandler(this, testDB.CONNECTED, _handleMongoConnected);
			
			_wire.connect();
		}
		private function _handleMongoConnected(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertEquals(testDB, event.getSignalArgument(0));
		}
		
		[Test(async)]
		public function connect_socketConnects_isConnectedReturnsTrue():void
		{
			mock(socket).method("connect").args(_testHost, _testPort).dispatches(new Event(Event.CONNECT));
			_wire.mockSocket = socket;
			
			new AsyncSignalHandler(this, testDB.CONNECTED, _handleMongoConnectedCheckIsConnected);
			
			_wire.connect();
		}
		private function _handleMongoConnectedCheckIsConnected(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertTrue(_wire.isConnected);
		}
		
		[Test(async)]
		public function connect_socketThrowsIOError_connectionFailedSignalDispatched():void
		{
			const ioErrorEvent:Event = new Event(IOErrorEvent.IO_ERROR);
			mock(socket).method("connect").args(_testHost, _testPort).dispatches(ioErrorEvent);
			_wire.mockSocket = socket;
			
			new AsyncSignalHandler(this, testDB.CONNECTION_FAILED, _handleMongoConnectionFailed);
			
			_wire.connect();
		}
		private function _handleMongoConnectionFailed(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertEquals(testDB, event.getSignalArgument(0));
		}
		
		[Test(async)]
		public function connect_securityError_socketPolicyFileErrorSignalDispatched():void
		{
			const securityError:Event = new Event(SecurityErrorEvent.SECURITY_ERROR);
			mock(socket).method("connect").args(_testHost, _testPort).dispatches(securityError);
			_wire.mockSocket = socket;
			
			new AsyncSignalHandler(this, testDB.SOCKET_POLICY_FILE_ERROR, _handleSocketPolicyFileError);
			
			_wire.connect();
		}
		private function _handleSocketPolicyFileError(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertEquals(testDB, event.getSignalArgument(0));
		}
		
	}
}