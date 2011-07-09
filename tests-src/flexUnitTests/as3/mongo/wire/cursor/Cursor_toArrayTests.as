package flexUnitTests.as3.mongo.wire.cursor
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.database.OpReply;
	import as3.mongo.wire.messages.database.OpReplyLoader;

	import flash.net.Socket;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.osflash.signals.Signal;

	public class Cursor_toArrayTests
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
		public function toArray_allScenarios_returnsArrayInstance():void
		{
			const arr:Array = _cursor.toArray();

			assertTrue(arr is Array);
		}

		[Test]
		public function toArray_allScenarios_arrayReturnedWithTwoItems():void
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

			_testLoadedSignal.dispatch(testOpReply);

			const array:Array           = _cursor.toArray();

			assertEquals(2, array.length);
		}
	}
}
