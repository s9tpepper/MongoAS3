package flexUnitTests.as3.mongo.wire.cursor
{
	import as3.mongo.wire.cursor.Cursor;
	
	import flash.net.Socket;
	
	public class TestCursor extends Cursor
	{
		public function TestCursor(cursorSocket:Socket)
		{
			super(cursorSocket);
		}
	}
}