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

	public class Cursor_getNextDocumentIndexTests
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

		[Test]
		public function getNextDocumentIndex_beforeLoadedSignalIsDispatched_returnsNegativeOne():void
		{
			assertEquals(-1, _cursor.getNextDocumentIndex());
		}

		[Test(async)]
		public function getNextDocumentIndex_onFirstLoadedSignalDispatched_returnsZero():void
		{
			var testOpReply:TestOpReply = _assembleTwoDocumentOpReply();

			new AsyncSignalHandler(this, _testLoadedSignal, _assertNextDocumentIndexReturnsZero);

			_testLoadedSignal.dispatch(testOpReply);
		}

		private function _getTestOpReply(testDocuments:Array):TestOpReply
		{
			var testOpReply:TestOpReply = new TestOpReply(100, mockSocket);
			testOpReply.documents = testDocuments;
			testOpReply.startingFrom = 0;
			testOpReply.numberReturned = 2;
			return testOpReply;
		}

		private function _getTestDocument(testDocuments:Array):Document
		{
			var firstDoc:Document = new Document();
			testDocuments.push(firstDoc);
			return firstDoc;
		}

		private function _assertNextDocumentIndexReturnsZero(event:AsyncSignalHandlerEvent, passThrough:Object=null):void
		{
			assertEquals(0, _cursor.getNextDocumentIndex());
		}

		[Test(async)]
		public function getNextDocumentIndex_onSecondCallToGetNextDocumentIndexAfterAGetNextDocument_returnsOne():void
		{
			var testOpReply:TestOpReply = _assembleTwoDocumentOpReply();

			new AsyncSignalHandler(this, _testLoadedSignal, _assertFirstCallToGetNextDocumentCallToGetNextDocumentIndexReturnsOne);

			_testLoadedSignal.dispatch(testOpReply);
		}

		private function _assertFirstCallToGetNextDocumentCallToGetNextDocumentIndexReturnsOne(event:AsyncSignalHandlerEvent,
																							   passThrough:Object=null):void
		{
			_cursor.getNextDocument();
			assertEquals(1, _cursor.getNextDocumentIndex());
		}

		[Test(async)]
		public function getNextDocumentIndex_onThirdCallToGetNextDocumentIndexAfterTwoGetNextDocument_returnsOne():void
		{
			var testOpReply:TestOpReply = _assembleTwoDocumentOpReply();

			new AsyncSignalHandler(this, _testLoadedSignal, _assertCallToNextDocumentIndexReturnsOneAfterGettingBothDocuments);

			_testLoadedSignal.dispatch(testOpReply);
		}

		private function _assertCallToNextDocumentIndexReturnsOneAfterGettingBothDocuments(event:AsyncSignalHandlerEvent,
																						   passThrough:Object=null):void
		{
			_cursor.getNextDocument();
			_cursor.getNextDocument();
			assertEquals(1, _cursor.getNextDocumentIndex());
		}

		private function _assembleTwoDocumentOpReply():TestOpReply
		{
			const testDocuments:Array   = new Array();
			_getTestDocument(testDocuments);
			_getTestDocument(testDocuments);
			var testOpReply:TestOpReply = _getTestOpReply(testDocuments);
			return testOpReply;
		}
	}
}
