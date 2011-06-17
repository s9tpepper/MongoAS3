package as3.mongo.wire.messages
{
	import as3.mongo.error.MongoError;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class MsgHeader implements IMessage
	{
		public static const MESSAGE_HEADER_LENGTH:uint    = 16;

		private static var _requestID:int                 = 0;
		private static const _VALID_OP_CODES:Vector.<int> = new <int>[1, 1000, 2001, 2002, 2003, 2004, 2005, 2006, 2007];

		private var _opCode:int;
		private var _responseTo:int;


		public function MsgHeader()
		{
			_incrementRequestCount();
		}

		private function _incrementRequestCount():void
		{
			_requestID++;
		}

		public function toByteArray():ByteArray
		{
			const byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;

			writeMessageToByteArray(byteArray);

			updateMessageLength(byteArray);

			byteArray.position = MESSAGE_HEADER_LENGTH;
			return byteArray;
		}

		protected function writeMessageToByteArray(byteArray:ByteArray):void
		{
			byteArray.writeInt(0);
			byteArray.writeInt(requestID);
			byteArray.writeInt(responseTo);
			byteArray.writeInt(opCode);
		}

		public function updateMessageLength(byteArray:ByteArray):void
		{
			byteArray.position = 0;
			byteArray.writeInt(byteArray.length);
		}

		public function get requestID():int
		{
			return _requestID;
		}

		public function get responseTo():int
		{
			return _responseTo;
		}

		public function get opCode():int
		{
			return _opCode;
		}

		public function set opCode(value:int):void
		{
			if (-1 == _VALID_OP_CODES.lastIndexOf(value))
				throw new MongoError(MongoError.INVALID_OP_CODE);

			_opCode = value;
		}

		public function set requestID(value:int):void
		{
			_requestID = value;
		}

		public function set responseTo(value:int):void
		{
			_responseTo = value;
		}
	}
}
