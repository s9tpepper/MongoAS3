package as3.mongo.wire.messages.database
{
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.OpCodes;
	
	import flash.net.Socket;

	public class OpReply
	{
		private var _msgHeader:MsgHeader;
		private var _messageLength:int;
		private var _socket:Socket;
		
		public function OpReply(replyMessageLength:int, buffer:Socket)
		{
			_initializeReply(replyMessageLength, buffer);
		}
		
		public function get socket():Socket
		{
			return _socket;
		}

		public function get messageLength():int
		{
			return _messageLength;
		}

		private function _initializeReply(replyMessageLength:int, buffer:Socket):void
		{
			_msgHeader = new MsgHeader();
			_msgHeader.opCode = OpCodes.OP_REPLY;
			
			_messageLength = replyMessageLength;
			_socket = buffer;
		}
		
		public function get msgHeader():MsgHeader
		{
			return _msgHeader;
		}

	}
}