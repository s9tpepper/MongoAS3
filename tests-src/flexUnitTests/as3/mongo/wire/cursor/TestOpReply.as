package flexUnitTests.as3.mongo.wire.cursor
{
	import as3.mongo.wire.messages.database.OpReply;

	import flash.net.Socket;

	import org.bson.BSONDecoder;
	import org.osflash.signals.Signal;
	import org.serialization.bson.Int64;

	public class TestOpReply extends OpReply
	{
		public function TestOpReply(replyMessageLength:int, buffer:Socket, decoder:BSONDecoder=null)
		{
			super(replyMessageLength, buffer, decoder);
		}

		public function set numberReturned(value:int):void
		{
			_numberReturned = value;
		}

		public function set cursorID(value:Int64):void
		{
			_cursorID = value;
		}

		public function set documents(value:Array):void
		{
			_documents = value;
		}

		public function set startingFrom(value:int):void
		{
			_startingFrom = value;
		}
	}
}
