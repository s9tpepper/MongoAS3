package as3.mongo.wire.messages.client
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.IMessage;
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.OpCodes;
	import flash.utils.ByteArray;
	import org.bson.BSONEncoder;

	public class OpDelete implements IMessage
	{
		protected var _fullCollectionName:String;
		protected var _selector:Document;
		protected var _flags:int;
		protected var _msgHeader:MsgHeader;
		protected var _bsonEncoder:BSONEncoder;

		public function OpDelete(aFullCollectionName:String, aSelector:Document)
		{
			_initializeOpDelete(aFullCollectionName, aSelector);
		}

		public function get bsonEncoder():BSONEncoder
		{
			return _bsonEncoder;
		}

		public function set bsonEncoder(value:BSONEncoder):void
		{
			_bsonEncoder = value;
		}

		public function get msgHeader():MsgHeader
		{
			return _msgHeader;
		}

		public function get flags():int
		{
			return _flags;
		}

		private function _initializeOpDelete(aFullCollectionName:String, aSelector:Document):void
		{
			_initializeMessageHeader();
			_fullCollectionName = aFullCollectionName;
			_selector = aSelector;
			_bsonEncoder = new BSONEncoder();
		}

		private function _initializeMessageHeader():void
		{
			_msgHeader = new MsgHeader();
			_msgHeader.opCode = OpCodes.OP_DELETE;
		}

		public function get selector():Document
		{
			return _selector;
		}

		public function get fullCollectionName():String
		{
			return _fullCollectionName;
		}

		public function toByteArray():ByteArray
		{
			const byteArray:ByteArray = _msgHeader.toByteArray();
			byteArray.writeInt(0);
			byteArray.writeUTFBytes(fullCollectionName);
			byteArray.writeByte(0);
			byteArray.writeInt(flags);
			byteArray.writeBytes(bsonEncoder.encode(selector));

			msgHeader.updateMessageLength(byteArray);

			byteArray.position = 0;
			return byteArray;
		}
	}
}
