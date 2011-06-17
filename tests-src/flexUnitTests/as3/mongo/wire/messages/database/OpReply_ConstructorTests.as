package flexUnitTests.as3.mongo.wire.messages.database
{
	import as3.mongo.wire.messages.OpCodes;
	import as3.mongo.wire.messages.database.OpReply;

	import flash.net.Socket;
	import flash.utils.ByteArray;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.bson.BSONDecoder;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.hamcrest.object.instanceOf;

	public class OpReply_ConstructorTests
	{
		[Rule]
		public var mocks:MockolateRule    = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockSocket:Socket;

		[Mock(inject = "true", type = "nice")]
		public var mockBsonDecoder:BSONDecoder;

		private var _opReply:OpReply;
		private var testMessageLength:int = 81;

		[Before]
		public function setUp():void
		{
			mock(mockSocket).method("readInt").returns(1);
			mock(mockSocket).getter("bytesAvailable").returns(4);
			_opReply = new OpReply(testMessageLength, mockSocket, mockBsonDecoder);
		}

		[After]
		public function tearDown():void
		{
			_opReply = null;
		}


		[Test]
		public function OpReply_onInstantiation_msgHeaderIsNotNull():void
		{
			assertNotNull(_opReply.msgHeader);
		}

		[Test]
		public function OpReply_onInstantiation_msgHeaderOpCodeIsOpReplyCode():void
		{
			assertEquals(OpCodes.OP_REPLY, _opReply.msgHeader.opCode);
		}

		[Test]
		public function OpReply_onInstantiation_messageLengthIsSet():void
		{
			assertEquals(testMessageLength, _opReply.messageLength);
		}

		[Test]
		public function OpReply_onInstantiation_bufferSocketIsSet():void
		{
			assertNotNull(_opReply.socket);
		}

		[Test]
		public function OpReply_onInstantiation_responseFlagsReturnedFromSocket():void
		{
			mockSocket = nice(Socket);
			mock(mockSocket).getter("bytesAvailable").returns(4);
			mock(mockSocket).method("readInt").returns(1);

			_opReply = new OpReply(testMessageLength, mockSocket, mockBsonDecoder);

			assertResponseFlagsReadFromSocket();
		}

		private function assertResponseFlagsReadFromSocket():void
		{
			assertThat(mockSocket, received().method("readInt"));
			assertEquals(1, _opReply.responseFlags);
		}


		[Test]
		public function OpReply_onInstantiation_cursorIDReturnedFromSocket():void
		{
			const int64:ByteArray = new ByteArray();
			mockSocket = nice(Socket);
			mock(mockSocket).method("readBytes").args(instanceOf(ByteArray), 0, 8);

			_opReply = new OpReply(testMessageLength, mockSocket);

			assertCursorIDReadFromSocket();
		}

		private function assertCursorIDReadFromSocket():void
		{
			assertThat(mockSocket, received().method("readBytes").args(instanceOf(ByteArray), 0, 8).once());
			assertNotNull(_opReply.cursorID);
		}


		[Test]
		public function OpReply_onInstantiation_startingFromReturnedFromSocket():void
		{
			mockSocket = nice(Socket);
			mock(mockSocket).getter("bytesAvailable").returns(4);
			mock(mockSocket).method("readInt").returns(1);

			_opReply = new OpReply(testMessageLength, mockSocket, mockBsonDecoder);

			assertThat(mockSocket, received().method("readInt"));
			assertEquals(1, _opReply.startingFrom);
		}
	}
}
