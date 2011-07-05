package flexUnitTests.as3.mongo.wire.cursor
{
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.database.OpReply;
	import as3.mongo.wire.messages.database.OpReplyLoader;

	import flash.net.Socket;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.osflash.signals.Signal;

	public class Cursor_ConstructorTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject = "false", type = "nice")]
		public var mockOpReplyLoader:OpReplyLoader;

		[Mock(inject = "true", type = "nice")]
		public var mockSocket:Socket;

		private var _cursor:Cursor;

		[Before]
		public function setUp():void
		{
			mockOpReplyLoader = nice(OpReplyLoader, null, [mockSocket]);
			mock(mockOpReplyLoader).getter("LOADED").returns(new Signal(OpReply));

			_cursor = new Cursor(mockOpReplyLoader);
		}

		[After]
		public function tearDown():void
		{
			_cursor = null;
		}

		[Test]
		public function Cursor_onInstantiation_readyIsFalse():void
		{
			assertFalse(_cursor.ready);
		}

		[Test]
		public function Cursor_onInstantiation_hasMoreReturnsZero():void
		{
			assertEquals(0, _cursor.hasMore());
		}
	}
}
