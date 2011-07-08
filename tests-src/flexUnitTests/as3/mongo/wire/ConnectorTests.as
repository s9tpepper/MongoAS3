package flexUnitTests.as3.mongo.wire
{
	import ab.flex.utils.flexunit.signals.AsyncSignalHandler;
	import ab.flex.utils.flexunit.signals.AsyncSignalHandlerEvent;

	import as3.mongo.wire.Connector;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;

	import flexUnitTests.as3.mongo.db.TestDB;

	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.instanceOf;

	public class ConnectorTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockSocket:Socket;

		public var mockWire:TestWire;
		public var mockDB:TestDB;

		private var _connector:Connector;
		private var _testHost:String   = "ahost";
		private var _testPort:Number   = 27017;

		[Before]
		public function setUp():void
		{
			_setUpMocks();
		}

		private function _setUpMocks():void
		{
			mockDB = new TestDB("aDatabaseName", _testHost, _testPort);
			mockWire = new TestWire(mockDB);
			mock(mockSocket).method("toString").returns("[mock Socket]");
			mockDB.mockWire = mockWire;
		}


		[After]
		public function tearDown():void
		{
			_connector = null;
		}

		[Test]
		public function Connector_onInstantiation_socketReferenceStored():void
		{
			_connector = new Connector(mockWire);
			assertEquals(mockWire, _connector.wire);
		}

		[Test]
		public function connect_allScenarios_connectInvokedOnSocket():void
		{
			_connector = new Connector(mockWire);
			mockWire.mockSocket = mockSocket;

			_connector.connect();

			assertThat(mockSocket, received().method("connect").args(instanceOf(String), instanceOf(int)));
		}

		[Test]
		public function connect_allScenarios_socketConnectIsInvoked():void
		{
			const connectedEvent:Event = new Event(Event.CONNECT);
			_setUpConnectorToTestEvent(connectedEvent);

			_connector.connect();

			assertThat(mockSocket, received().method("connect").args(_testHost, _testPort));
		}

		[Test(async)]
		public function connect_socketConnects_connectedSignalDispatched():void
		{
			const connectedEvent:Event = new Event(Event.CONNECT);
			_setUpConnectorToTestEvent(connectedEvent);

			new AsyncSignalHandler(this, mockDB.connected, _handleMongoConnected);

			_connector.connect();
		}

		private function _handleMongoConnected(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertEquals(mockDB, event.getSignalArgument(0));
		}

		[Test(async)]
		public function connect_socketConnects_isConnectedReturnsTrue():void
		{
			const connectedEvent:Event = new Event(Event.CONNECT);
			_setUpConnectorToTestEvent(connectedEvent);

			new AsyncSignalHandler(this, mockDB.connected, _handleMongoConnectedCheckIsConnected);

			_connector.connect();
		}

		private function _handleMongoConnectedCheckIsConnected(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertTrue(mockWire.isConnected);
		}

		[Test(async)]
		public function connect_socketThrowsIOError_connectionFailedSignalDispatched():void
		{
			const ioErrorEvent:Event = new Event(IOErrorEvent.IO_ERROR);
			_setUpConnectorToTestEvent(ioErrorEvent);

			new AsyncSignalHandler(this, mockDB.connectionFailed, _handleMongoConnectionFailed);

			_connector.connect();
		}

		private function _handleMongoConnectionFailed(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertEquals(mockDB, event.getSignalArgument(0));
		}

		[Test(async)]
		public function connect_securityError_socketPolicyFileErrorSignalDispatched():void
		{
			const securityError:Event = new Event(SecurityErrorEvent.SECURITY_ERROR);
			_setUpConnectorToTestEvent(securityError);

			new AsyncSignalHandler(this, mockDB.socketPolicyFileError, _handleSocketPolicyFileError);

			_connector.connect();
		}

		private function _setUpConnectorToTestEvent(event:Event):void
		{
			mock(mockSocket).method("connect").args(_testHost, _testPort).dispatches(event);
			mockWire.mockSocket = mockSocket;
			_connector = new Connector(mockWire);
		}


		private function _handleSocketPolicyFileError(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertEquals(mockDB, event.getSignalArgument(0));
		}
	}
}
