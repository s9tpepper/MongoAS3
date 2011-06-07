package flexUnitTests.as3.mongo.wire.cursor
{
	import as3.mongo.wire.cursor.Cursor;
	
	import flash.net.Socket;
	
	import mockolate.runner.MockolateRule;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;

	public class Cursor_ConstructorTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock(inject="true", type="nice")]
		public var mockSocket:Socket;
		
		private var _cursor:Cursor;
		
		[Before]
		public function setUp():void
		{
			_cursor = new Cursor(mockSocket);
		}
		
		[After]
		public function tearDown():void
		{
			_cursor = null;
		}
		
		[Test]
		public function Cursor_onInstantiation_socketReferenceStored():void
		{
			assertNotNull(_cursor.socket);
		}
		
		[Test]
		public function Cursor_onInstantiation_isCompleteIsFalse():void
		{
			assertFalse(_cursor.isComplete);
		}
		
		[Test]
		public function Cursor_onInstantiation_documentsLengthIsZero():void
		{
			assertEquals(0, _cursor.documents.length);
		}
		
		[Test]
		public function Cursor_onInstantiation_currentReplyLengthIsNegativeOne():void
		{
			assertEquals(-1, _cursor.currentReplyLength);
		}
		
		[Test]
		public function Cursor_onInstantiation_currentReplyLengthLoadedIsNegativeOne():void
		{
			assertEquals(-1, _cursor.currentReplyLengthLoaded);
		}

		[Test]
		public function Cursor_onInstantiation_loadingReplyIsFalse():void
		{
			assertFalse(_cursor.loadingReply);
		}
		
		[Test]
		public function Cursor_onInstantiation_bsonDecoderIsNotNull():void
		{
			assertNotNull(_cursor.decoder);
		}
	}
}