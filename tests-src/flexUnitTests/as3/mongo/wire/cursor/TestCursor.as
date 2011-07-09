package flexUnitTests.as3.mongo.wire.cursor
{
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.cursor.GetMoreMessage;
	import as3.mongo.wire.messages.database.OpReply;
	import as3.mongo.wire.messages.database.OpReplyLoader;

	import org.bson.BSONDecoder;

	public class TestCursor extends Cursor
	{
		private var _mockOpReply:OpReply;

		public function TestCursor(opReplyLoader:OpReplyLoader)
		{
			super(opReplyLoader);
		}

		public function get mockOpReply():OpReply
		{
			return _mockOpReply;
		}

		public function set mockOpReply(value:OpReply):void
		{
			_mockOpReply = value;
		}

		public function set mockGetMoreMessage(value:GetMoreMessage):void
		{
			_getMoreMessage = value;
		}

//		public function set mockDecoder(value:BSONDecoder):void
//		{
//			_decoder = value;
//		}
	}
}
