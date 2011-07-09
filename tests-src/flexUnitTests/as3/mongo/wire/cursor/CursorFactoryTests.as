package flexUnitTests.as3.mongo.wire.cursor
{
	import as3.mongo.db.DB;
	import as3.mongo.wire.CursorFactory;
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

	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.osflash.signals.Signal;

	public class CursorFactoryTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject = "false", type = "nice")]
		public var mockedOpReplyLoader:OpReplyLoader;

		[Mock(inject = "false", type = "nice")]
		public var mockWire:Wire;

		[Mock(inject = "true", type = "nice")]
		public var mockSocket:Socket;

		[Mock(inject = "true", type = "nice")]
		public var mockDB:DB;

		private var _cursorFactory:CursorFactory;

		[Before]
		public function setUp():void
		{
			mockedOpReplyLoader = nice(OpReplyLoader, null, [mockSocket]);
			mock(mockedOpReplyLoader).getter("LOADED").returns(new Signal(OpReply));
			mockWire = nice(Wire, null, [mockDB]);

			_cursorFactory = new CursorFactory();
		}

		[After]
		public function tearDown():void
		{
			_cursorFactory = null;
		}

		[Test]
		public function getCursor_allScenarios_returnsCursorInstance():void
		{
			const cursor:Cursor                 = _cursorFactory.getCursor(mockedOpReplyLoader);
			const getMoreMessage:GetMoreMessage = new GetMoreMessage("aDBName", "aCollectionName", new FindOptions(), mockWire, cursor);

			assertTrue("The getCursor method did not return a cursor object", cursor is Cursor);
		}

		[Test]
		public function getCursor_socketReferenceIsNull_returnsNull():void
		{
			const cursor:Cursor                 = _cursorFactory.getCursor(null);
			const getMoreMessage:GetMoreMessage = new GetMoreMessage("aDBName", "aCollectionName", new FindOptions(), mockWire, cursor);

			assertNull(cursor);
		}
	}
}
