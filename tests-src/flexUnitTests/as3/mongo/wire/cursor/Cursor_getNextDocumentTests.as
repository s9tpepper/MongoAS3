package flexUnitTests.as3.mongo.wire.cursor
{
	import ab.flex.utils.flexunit.signals.AsyncSignalHandler;
	import ab.flex.utils.flexunit.signals.AsyncSignalHandlerEvent;

	import as3.mongo.db.document.Document;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.database.OpReply;
	import as3.mongo.wire.messages.database.OpReplyLoader;

	import flash.net.Socket;
	import flash.utils.ByteArray;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.osflash.signals.Signal;
	import org.serialization.bson.Int64;

	public class Cursor_getNextDocumentTests
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
		public function loadedSignal_onFirstLoadedSignalDispatched_getNextDocumentReturnsFirstDocument():void
		{
			var testOpReply:TestOpReply = new TestOpReply(100, mockSocket);
			const testDocuments:Array   = new Array();
			var firstDoc:Document       = new Document();
			testDocuments.push(firstDoc);
			var secondDoc:Document      = new Document();
			testDocuments.push(secondDoc);
			testOpReply.documents = testDocuments;
			testOpReply.startingFrom = 0;
			testOpReply.numberReturned = 2;

			new AsyncSignalHandler(this, _testLoadedSignal, _checkGetNextDocumentReturn, 5000, testDocuments);

			_testLoadedSignal.dispatch(testOpReply);
		}

		private function _checkGetNextDocumentReturn(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			const testDocuments:Array = passThrough as Array;
			assertEquals(testDocuments[0], _cursor.getNextDocument());
		}

	}
}
