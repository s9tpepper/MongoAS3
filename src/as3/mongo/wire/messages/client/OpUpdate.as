package as3.mongo.wire.messages.client
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.IMessage;
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.OpCodes;

	import flash.utils.ByteArray;

	import org.bson.BSONEncoder;

	public class OpUpdate implements IMessage
	{
		protected var _msgHeader:MsgHeader;
		protected var _fullCollectionName:String;
		protected var _flags:int;
		protected var _selector:Document;
		protected var _update:Document;
		protected var _bsonEncoder:BSONEncoder;

		public function OpUpdate(aFullCollectionName:String, aFlags:int, aSelector:Document, aUpdate:Document)
		{
			_initializeOpUpdate(aFullCollectionName, aFlags, aSelector, aUpdate);
		}

		private function _initializeOpUpdate(aFullCollectionName:String,
											 aFlags:int,
											 aSelector:Document,
											 aUpdate:Document):void
		{
			_initializeMsgHeader();
			_fullCollectionName = aFullCollectionName;
			_flags = aFlags;
			_selector = aSelector;
			_update = aUpdate;
			_bsonEncoder = new BSONEncoder();
		}

		private function _initializeMsgHeader():void
		{
			_msgHeader = new MsgHeader();
			_msgHeader.opCode = OpCodes.OP_UPDATE;
		}

		public function get bsonEncoder():BSONEncoder
		{
			return _bsonEncoder;
		}

		public function set bsonEncoder(value:BSONEncoder):void
		{
			_bsonEncoder = value;
		}

		public function get update():Document
		{
			return _update;
		}

		public function get selector():Document
		{
			return _selector;
		}

		public function get flags():int
		{
			return _flags;
		}

		public function get msgHeader():MsgHeader
		{
			return _msgHeader;
		}

		public function get fullCollectionName():String
		{
			return _fullCollectionName;
		}

		public function toByteArray():ByteArray
		{
			const byteArray:ByteArray = msgHeader.toByteArray();
			byteArray.writeInt(0);
			byteArray.writeUTFBytes(fullCollectionName);
			byteArray.writeByte(0);
			byteArray.writeInt(flags);
			byteArray.writeBytes(bsonEncoder.encode(selector));
			byteArray.writeBytes(bsonEncoder.encode(update));
			msgHeader.updateMessageLength(byteArray);
			byteArray.position = 0;
			return byteArray;
		}


	}
}
