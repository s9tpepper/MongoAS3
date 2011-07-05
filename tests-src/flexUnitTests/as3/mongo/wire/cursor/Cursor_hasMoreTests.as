package flexUnitTests.as3.mongo.wire.cursor
{
	import ab.flex.utils.flexunit.signals.AsyncSignalHandler;
	import ab.flex.utils.flexunit.signals.AsyncSignalHandlerEvent;

	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.database.OpReply;
	import as3.mongo.wire.messages.database.OpReplyLoader;

	import flash.net.Socket;
	import flash.utils.ByteArray;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;

	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.osflash.signals.Signal;
	import org.serialization.bson.Int64;

	public class Cursor_hasMoreTests
	{
		[Rule]
		public var mocks:MockolateRule       = new MockolateRule();

		[Mock(inject = "false", type = "nice")]
		public var mockOpReplyLoader:OpReplyLoader;

		[Mock(inject = "true", type = "nice")]
		public var mockSocket:Socket;

		private var _cursor:Cursor;
		private var _testLoadedSignal:Signal = new Signal(OpReply);

		[Before]
		public function setUp():void
		{
			mockOpReplyLoader = nice(OpReplyLoader, null, [mockSocket]);
			mock(mockOpReplyLoader).getter("LOADED").returns(_testLoadedSignal);
			_cursor = new Cursor(mockOpReplyLoader);
		}

		[After]
		public function tearDown():void
		{
			_cursor = null;
		}

		[Test(async)]
		public function hasMore_onFirstLoadedSignalDispatchedAndCursorIDIsNotNull_returnsTrue():void
		{
			var testOpReply:TestOpReply = new TestOpReply(100, mockSocket);
			testOpReply.numberReturned = 5;
			const byteArray:ByteArray   = new ByteArray()
			byteArray.writeInt(0);
			byteArray.writeInt(1);
			byteArray.position = 0;
			testOpReply.cursorID = new Int64(byteArray);

			new AsyncSignalHandler(this, _testLoadedSignal, _checkHasMoreIsTrue, 5000, testOpReply);

			_testLoadedSignal.dispatch(testOpReply);
		}

		private function _checkHasMoreIsTrue(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertTrue(_cursor.hasMore());
		}

		[Test(async)]
		public function hasMore_onFirstLoadedSignalDispatchedAndCursorIDIsNull_returnsFalse():void
		{
			var testOpReply:TestOpReply = new TestOpReply(100, mockSocket);
			testOpReply.numberReturned = 5;
			testOpReply.cursorID = null;

			new AsyncSignalHandler(this, _testLoadedSignal, _checkHasMoreIsFalse, 5000, testOpReply);

			_testLoadedSignal.dispatch(testOpReply);
		}

		private function _checkHasMoreIsFalse(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertFalse(_cursor.hasMore());
		}

		[Test(async)]
		public function hasMore_onFirstLoadedSignalDispatchedAndCursorIDIsZero_returnsFalse():void
		{
			var testOpReply:TestOpReply = new TestOpReply(100, mockSocket);
			testOpReply.numberReturned = 5;
			const byteArray:ByteArray   = new ByteArray()
			byteArray.writeInt(0);
			byteArray.writeInt(0);
			byteArray.position = 0;
			testOpReply.cursorID = new Int64(byteArray);

			new AsyncSignalHandler(this, _testLoadedSignal, _checkHasMoreIsFalse, 5000, testOpReply);

			_testLoadedSignal.dispatch(testOpReply);
		}
	}
}
