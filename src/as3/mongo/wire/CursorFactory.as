package as3.mongo.wire
{
	import flash.net.Socket;
	import as3.mongo.wire.cursor.Cursor;
	
	public class CursorFactory
	{
		public function CursorFactory()
		{
		}
		
		public function getCursor(socket:Socket):Cursor
		{
			var cursor:Cursor;

			if (socket && socket.connected)
				cursor = new Cursor(socket);

			return cursor;
		}
	}
}