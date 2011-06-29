package flexUnitTests.as3.mongo.wire
{
	import as3.mongo.wire.Messenger;
	import as3.mongo.wire.Wire;
	import as3.mongo.wire.messages.IMessage;

	import flash.net.Socket;
	import flash.utils.ByteArray;

	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;

	public class MessengerTests
	{
		[Rule]
		public var mocks:MockolateRule       = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockWire:Wire;

		[Mock(inject = "true", type = "nice")]
		public var mockMessage:IMessage;

		[Mock(inject = "true", type = "nice")]
		public var mockSocket:Socket;

		private var _testByteArray:ByteArray = new ByteArray();
		private var _messenger:Messenger;

		[Before]
		public function setUp():void
		{
			mock(mockMessage).method("toByteArray").returns(_testByteArray);
			mock(mockWire).getter("socket").returns(mockSocket);
			_messenger = new Messenger(mockWire);
		}

		[After]
		public function tearDown():void
		{
			_messenger = null;
		}

		[Test]
		public function Messenger_onInstantiation_wireIsStored():void
		{
			assertEquals(mockWire, _messenger.wire);
		}

		[Test]
		public function sendMessage_instanceOfIMessagePassedIn_writeBytesInvokedOnSocket():void
		{
			_messenger.sendMessage(mockMessage);

			assertThat(mockSocket, received().method("writeBytes").arg(_testByteArray).once());
		}

		[Test]
		public function sendMessage_instanceOfIMessagePassedIn_flushInvokedOnSocket():void
		{
			_messenger.sendMessage(mockMessage);
			assertThat(mockSocket, received().method("flush").noArgs().once());
		}
	}
}
