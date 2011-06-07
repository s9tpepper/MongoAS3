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
			return new Cursor(socket);
		}
	}
}