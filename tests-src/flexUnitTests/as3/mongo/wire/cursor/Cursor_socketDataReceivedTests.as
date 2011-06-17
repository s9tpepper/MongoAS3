package flexUnitTests.as3.mongo.wire.cursor
{
	import ab.flex.utils.flexunit.signals.AsyncSignalHandler;
	import ab.flex.utils.flexunit.signals.AsyncSignalHandlerEvent;

	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.database.OpReply;

	import asx.fn.partial;

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.bson.BSONDecoder;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import org.hamcrest.object.instanceOf;

	public class Cursor_socketDataReceivedTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject = "false", type = "nice")]
		public var mockedBSONDecoder:BSONDecoder;

		[Mock(inject = "true", type = "nice")]
		public var mockedSocket:Socket;

		[Mock(inject = "false", type = "nice")]
		public var mockOpReply:OpReply;

		private var _socket:Socket;
		private var _cursor:TestCursor;
		private var _firstProgressEvent:Event;


		[Before]
		public function setUp():void
		{
			_socket = new Socket();
			mockOpReply = nice(OpReply, null, [81, mockedSocket]);
		}

		[After]
		public function tearDown():void
		{
			_cursor = null;
		}

		private function _mockFirstProgressEvent():void
		{
			_firstProgressEvent = new ProgressEvent(ProgressEvent.SOCKET_DATA, false, false, 100, 200);
			mock(mockedSocket).method("connect").anyArgs().dispatches(_firstProgressEvent);
			mock(mockedSocket).method("readInt").noArgs().returns(200);
			_makeCursor();
		}

		private function _mockFirstProgressEventAndSocket():void
		{
			_firstProgressEvent = new ProgressEvent(ProgressEvent.SOCKET_DATA, false, false, 100, 200);
			mock(mockedSocket).method("connect").anyArgs().dispatches(_firstProgressEvent);
			mock(mockedSocket).method("readInt").noArgs().returns(200);
			mock(mockedSocket).getter("bytesAvailable").returns(96);
			_makeCursor();
		}

		private function _mockTwoProgressEvents():void
		{
			_firstProgressEvent = new ProgressEvent(ProgressEvent.SOCKET_DATA, false, false, 100, 200);
			var secondProgressEvent:ProgressEvent = new ProgressEvent(ProgressEvent.SOCKET_DATA, false, false, 200, 200);
			mock(mockedSocket).method("connect").anyArgs().dispatches(_firstProgressEvent);
			mock(mockedSocket).method("flush").anyArgs().dispatches(secondProgressEvent);
			mock(mockedSocket).method("readInt").noArgs().returns(200);
			mock(mockedSocket).getter("bytesAvailable").returns(196);
			_makeCursor();
		}

		private function _makeCursor():void
		{
			_cursor = new TestCursor(mockedSocket);
			_cursor.mockOpReply = mockOpReply;
		}


		private function _dispatchSecondProgressEvent():void
		{
			mockedSocket.flush();
		}

		[Test(async)]
		public function currentReplyLength_firstProgressEvent_currentReplyLengthSet():void
		{
			_mockFirstProgressEvent();

			new AsyncSignalHandler(this, Cursor.PROGRESS, _handleProgress);

			// Connect method used here only to get the test progress event to dispatch
			mockedSocket.connect("", 1);
		}

		private function _handleProgress(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertEquals(200, _cursor.currentReplyLength);
		}


		[Test(async)]
		public function currentReplyLength_firstProgressEvent_replyCompleteIsFalse():void
		{
			_mockFirstProgressEvent();

			new AsyncSignalHandler(this, Cursor.PROGRESS, _handleProgressCheckIsComplete);

			// Connect method used here only to get the test progress event to dispatch
			mockedSocket.connect("", 1);
		}

		private function _handleProgressCheckIsComplete(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertFalse(_cursor.isComplete);
		}


		[Test(async)]
		public function currentReplyLength_firstProgressEvent_currentReplyLengthLoadedSet():void
		{
			_mockFirstProgressEventAndSocket();

			new AsyncSignalHandler(this, Cursor.PROGRESS, _handleProgressCheckCurrentReplyLengthLoaded);

			// Connect method used here only to get the test progress event to dispatch
			mockedSocket.connect("", 1);
		}

		private function _handleProgressCheckCurrentReplyLengthLoaded(event:AsyncSignalHandlerEvent,
																	  passThrough:Object=null):void
		{
			assertEquals(100, _cursor.currentReplyLengthLoaded);
		}

		[Test(async)]
		public function currentReplyLength_firstProgressEvent_loadingReplyIsTrue():void
		{
			_mockFirstProgressEventAndSocket();

			new AsyncSignalHandler(this, Cursor.PROGRESS, _handleProgressCheckLoadingReplySetToTrue);

			// Connect method used here only to get the test progress event to dispatch
			mockedSocket.connect("", 1);
		}

		private function _handleProgressCheckLoadingReplySetToTrue(event:AsyncSignalHandlerEvent,
																   passThrough:Object=null):void
		{
			assertTrue(_cursor.loadingReply);
		}


		[Test(async, timeout = "5000")]
		public function Cursor_secondProgressEventDispatched_readIntInvokedOnceToGetMessageLength():void
		{
			_mockTwoProgressEvents();

			// dispatch first progress event using mocked connect method.
			mockedSocket.connect("", 1);

			// delay second progress event
			setTimeout(_dispatchSecondProgressEvent, 250);

			new AsyncSignalHandler(this, Cursor.PROGRESS, _handleSecondCursorProgress, 5000); // handle the async second progress event
		}

		private function _handleSecondCursorProgress(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertThat(mockedSocket, received().method("readInt").noArgs().once());
		}

		[Test(async, timeout = "5000")]
		public function onProgressEventDispatched_currentReplyLengthIsEqualToBytesAvailable_replyCompleteSignalDispatched():void
		{
			_firstProgressEvent = new ProgressEvent(ProgressEvent.SOCKET_DATA, false, false, 100, 200);
			var secondProgressEvent:ProgressEvent = new ProgressEvent(ProgressEvent.SOCKET_DATA, false, false, 200, 200);
			mock(mockedSocket).method("connect").anyArgs().dispatches(_firstProgressEvent);
			mock(mockedSocket).method("flush").anyArgs().dispatches(secondProgressEvent);
			mock(mockedSocket).method("readInt").noArgs().returns(200);
			mock(mockedSocket).getter("bytesAvailable").returns(196);
			_makeCursor();

			mockedSocket.connect("", 1); // dispatch first progress event

			new AsyncSignalHandler(this, Cursor.REPLY_COMPLETE, _handleSecondCursorProgressCompareReplyLengthAndAmountLoaded, 5000); // handle the async second progress event
			setTimeout(_dispatchSecondProgressEvent, 250); // delay second progress event
		}

		private function _handleSecondCursorProgressCompareReplyLengthAndAmountLoaded(event:AsyncSignalHandlerEvent,
																					  passThrough:Object=null):void
		{
			assertTrue(true);
		}


		[Test(async, timeout = "5000")]
		public function onProgressEventDispatched_currentReplyLengthIsEqualToBytesAvailable_loadingReplyIsFalse():void
		{
			_mockTwoProgressEvents();

			mockedSocket.connect("", 1); // dispatch first progress event

			setTimeout(_dispatchSecondProgressEvent, 250); // delay second progress event
			new AsyncSignalHandler(this, Cursor.REPLY_COMPLETE, _checkLoadingReply, 5000); // handle the async second progress event
		}

		private function _checkLoadingReply(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertFalse(_cursor.loadingReply);
		}

		[Test(async, timeout = "5000")]
		public function onProgressEventDispatched_currentReplyLengthIsEqualToBytesAvailable_replyCompleteSignalDispatchesOpReply():void
		{
			_mockTwoProgressEvents();

			mockedSocket.connect("", 1); // dispatch first progress event

			new AsyncSignalHandler(this, Cursor.REPLY_COMPLETE, _handleSecondCursorProgressCheckSignalParameters, 5000); // handle the async second progress event
			setTimeout(_dispatchSecondProgressEvent, 250); // delay second progress event
		}

		private function _handleSecondCursorProgressCheckSignalParameters(event:AsyncSignalHandlerEvent,
																		  passThrough:Object=null):void
		{
			assertTrue(event.getSignalArgument(0) is OpReply);
		}
	}
}

