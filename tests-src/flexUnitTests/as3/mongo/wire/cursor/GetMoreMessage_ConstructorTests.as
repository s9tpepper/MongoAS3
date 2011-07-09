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
	import mockolate.runner.MockolateRule;

	import org.flexunit.asserts.assertTrue;
	import org.osflash.signals.Signal;

	public class GetMoreMessage_ConstructorTests
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


		[Before]
		public function setUp():void
		{
			mockOpReplyLoader = nice(OpReplyLoader, null, [mockSocket]);
			mock(mockOpReplyLoader).getter("LOADED").returns(new Signal(OpReply));
			mockCursor = nice(Cursor, null, [mockOpReplyLoader]);

			_getMoreMessage = new GetMoreMessage(_testDBName, _testCollectionName, _testOptions, mockWire, mockCursor);
		}

		[After]
		public function tearDown():void
		{
			_getMoreMessage = null;
		}

		[Test]
		public function GetMoreMessage_onInstantiation_instanceReturned():void
		{
			assertTrue(_getMoreMessage is GetMoreMessage);
		}
	}
}
