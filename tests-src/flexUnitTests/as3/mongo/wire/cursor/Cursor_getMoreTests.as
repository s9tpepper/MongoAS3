package flexUnitTests.as3.mongo.wire.cursor
{
	import as3.mongo.wire.Wire;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.cursor.GetMoreMessage;
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

	public class Cursor_getMoreTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject = "false", type = "nice")]
		public var opReplyLoader:OpReplyLoader;

		[Mock(inject = "true", type = "nice")]
		public var mockWire:Wire;

		[Mock(inject = "true", type = "nice")]
		public var mockGetMoreMessage:GetMoreMessage;

		private var _cursor:TestCursor;

		[Before]
		public function setUp():void
		{
			opReplyLoader = nice(OpReplyLoader, null, [new Socket()]);
			mock(opReplyLoader).getter("LOADED").returns(new Signal(OpReply));
			_cursor = new TestCursor(opReplyLoader);
			_cursor.getMoreMessage = mockGetMoreMessage;
		}

		[After]
		public function tearDown():void
		{
			_cursor = null;
		}

		[Test]
		public function getMore_cursorHasMoreIsTrue_sendInvokedOnGetMoreMessage():void
		{
			_cursor.getMore();

			assertThat(mockGetMoreMessage, received().method("send").noArgs().once());
		}

		[Test]
		public function getMore_cursorHasMoreIsTrue_returnsSignal():void
		{
			const signal:Signal = _cursor.getMore();

			assertTrue(signal is Signal);
		}
	}
}
