package flexUnitTests.as3.mongo.wire.cursor
{
	import as3.mongo.wire.cursor.Cursor;

	import flash.net.Socket;

	import org.bson.BSONDecoder;
	import as3.mongo.wire.messages.database.OpReply;

	public class TestCursor extends Cursor
	{
		private var _mockOpReply:OpReply;

		public function TestCursor(cursorSocket:Socket)
		{
			super(cursorSocket);
		}

		public function get mockOpReply():OpReply
		{
			return _mockOpReply;
		}

		public function set mockOpReply(value:OpReply):void
		{
			_mockOpReply = value;
		}

		public function set mockDecoder(value:BSONDecoder):void
		{
			_decoder = value;
		}

		override protected function createOpReply():void
		{
			_currentReply = _mockOpReply;
		}

	}
}