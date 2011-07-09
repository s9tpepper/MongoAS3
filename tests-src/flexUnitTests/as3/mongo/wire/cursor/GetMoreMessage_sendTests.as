package flexUnitTests.as3.mongo.wire.cursor
{
	import as3.mongo.wire.Wire;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.cursor.GetMoreMessage;
	import as3.mongo.wire.messages.client.FindOptions;
	import as3.mongo.wire.messages.database.OpReply;
	import as3.mongo.wire.messages.database.OpReplyLoader;

	import flash.net.Socket;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.osflash.signals.Signal;
	import org.serialization.bson.Int64;

	public class GetMoreMessage_sendTests
	{
		[Rule]
		public var mocks:MockolateRule         = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockWire:Wire;

		[Mock(inject = "false", type = "nice")]
		public var mockCursor:Cursor;

		[Mock(inject = "false", type = "nice")]
		public var mockOpReplyLoader:OpReplyLoader;

		[Mock(inject = "true", type = "nice")]
		public var mockSocket:Socket;

		private var _testOptions:FindOptions   = new FindOptions();
		private var _testCollectionName:String = "aCollectionName";
		private var _testDBName:String         = "aDBName";
		private var _getMoreMessage:GetMoreMessage;
		private var _testCursorID:Int64;


		[Before]
		public function setUp():void
		{
			_testCursorID = Int64.ONE;

			mockOpReplyLoader = nice(OpReplyLoader, null, [mockSocket]);
			mock(mockOpReplyLoader).getter("LOADED").returns(new Signal(OpReply));
			mockCursor = nice(Cursor, null, [mockOpReplyLoader]);
			mock(mockCursor).getter("cursorID").returns(_testCursorID);

			_getMoreMessage = new GetMoreMessage(_testDBName, _testCollectionName, _testOptions, mockWire, mockCursor);
		}

		[After]
		public function tearDown():void
		{
			_getMoreMessage = null;
		}

		[Test]
		public function send_allScenarios_getMoreInvokedOnWire():void
		{
			mock(mockWire).method("getMore").anyArgs().returns(new Signal(OpReply));

			_getMoreMessage.send();

			assertThat(mockWire, received().method("getMore").args(_testDBName, _testCollectionName, _testOptions, _testCursorID).once());
		}
	}
}
