package as3.mongo.wire.messages.client
{
	import as3.mongo.wire.messages.IMessage;
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.OpCodes;

	import flash.utils.ByteArray;

	import org.serialization.bson.Int64;

	public class OpGetMore implements IMessage
	{
		protected var _msgHeader:MsgHeader;
		protected var _fullCollectionName:String;
		protected var _numberToReturn:int;
		protected var _cursorID:Int64;

		public function OpGetMore(fullCollectionName:String, numberToReturn:int, cursorID:Int64)
		{
			_initializeOpGetMore(fullCollectionName, numberToReturn, cursorID);
		}

		public function get cursorID():Int64
		{
			return _cursorID;
		}

		public function get numberToReturn():int
		{
			return _numberToReturn;
		}

		public function get fullCollectionName():String
		{
			return _fullCollectionName;
		}

		private function _initializeOpGetMore(fullCollectionName:String, numberToReturn:int, cursorID:Int64):void
		{
			_initializeMsgHeader();

			_initializeOpGetMoreOptions(fullCollectionName, numberToReturn, cursorID);
		}

		private function _initializeOpGetMoreOptions(fullCollectionName:String, numberToReturn:int, cursorID:Int64):void
		{
			_fullCollectionName = fullCollectionName;
			_numberToReturn = numberToReturn;
			_cursorID = cursorID;
		}

		private function _initializeMsgHeader():void
		{
			_msgHeader = new MsgHeader();
			_msgHeader.opCode = OpCodes.OP_GET_MORE;
		}


		public function get msgHeader():MsgHeader
		{
			return _msgHeader;
		}

		public function toByteArray():ByteArray
		{
			const byteArray:ByteArray = _msgHeader.toByteArray();
			byteArray.writeInt(0);
			byteArray.writeUTFBytes(fullCollectionName);
			byteArray.writeByte(0);
			byteArray.writeInt(numberToReturn);
			_writeCursorID(byteArray);

			msgHeader.updateMessageLength(byteArray);

			byteArray.position = 0;
			return byteArray;
		}

		private function _writeCursorID(byteArray:ByteArray):void
		{
			const int64Bytes:ByteArray = cursorID.getAsBytes();
			int64Bytes.position = 0;
			byteArray.writeBytes(int64Bytes);
		}
	}
}
