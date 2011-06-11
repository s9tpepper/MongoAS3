package as3.mongo.wire.cursor
{
	import flash.net.Socket;
	
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