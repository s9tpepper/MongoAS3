package as3.mongo.wire
{
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.cursor.GetMoreMessage;
	import as3.mongo.wire.messages.client.FindOptions;
	import as3.mongo.wire.messages.database.OpReplyLoader;

	public class CursorFactory
	{
		public function CursorFactory()
		{
		}

		public function getCursor(opReplyLoader:OpReplyLoader):Cursor
		{
			if (null == opReplyLoader)
				return null;

			return new Cursor(opReplyLoader);
		}
	}
}
