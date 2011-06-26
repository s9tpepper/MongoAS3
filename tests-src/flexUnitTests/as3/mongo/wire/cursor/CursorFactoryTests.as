package flexUnitTests.as3.mongo.wire.cursor
{
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.CursorFactory;
	import as3.mongo.wire.messages.database.OpReply;

	import flash.net.Socket;

	import mockolate.mock;
	import mockolate.runner.MockolateRule;

	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;

	public class CursorFactoryTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockedSocket:Socket;

		private var _cursorFactory:CursorFactory;

		[Before]
		public function setUp():void
		{
			_cursorFactory = new CursorFactory();
		}

		[After]
		public function tearDown():void
		{
			_cursorFactory = null;
		}

		[Test]
		public function getCursor_connectedSocket_returnsCursorInstance():void
		{
			mock(mockedSocket).getter("connected").returns(true);

			const cursor:Cursor = _cursorFactory.getCursor(mockedSocket);

			assertTrue("The getCursor method did not return a cursor object", cursor is Cursor);
		}

		[Test]
		public function getCursor_socketIsNotConnected_returnsNull():void
		{
			mock(mockedSocket).getter("connected").returns(false);

			const cursor:Cursor = _cursorFactory.getCursor(mockedSocket);

			assertNull(cursor);
		}

		[Test]
		public function getCursor_socketReferenceIsNull_returnsNull():void
		{
			const cursor:Cursor = _cursorFactory.getCursor(null);

			assertNull(cursor);
		}
	}
}
