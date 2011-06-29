package as3.mongo.wire.messages.client
{
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;
	import as3.mongo.wire.messages.IMessage;
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.OpCodes;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import org.bson.BSONEncoder;

	public class OpInsert implements IMessage
	{
		protected var _flags:int = 0;
		protected var _collectionName:String;
		protected var _documents:Vector.<Document>;
		protected var _msgHeader:MsgHeader;
		protected var _bsonEncoder:BSONEncoder;

		public function OpInsert(fullCollectionName:String)
		{
			_initializeOpInsert(fullCollectionName);
		}

		public function get bsonEncoder():BSONEncoder
		{
			return _bsonEncoder;
		}

		public function get totalDocuments():uint
		{
			return _documents.length;
		}

		private function _initializeOpInsert(fullCollectionName:String):void
		{
			_bsonEncoder = new BSONEncoder();

			_documents = new Vector.<Document>();
			_collectionName = fullCollectionName;

			_msgHeader = new MsgHeader();
			_msgHeader.opCode = OpCodes.OP_INSERT;
		}

		public function get msgHeader():MsgHeader
		{
			return _msgHeader;
		}

		public function get collectionName():String
		{
			return _collectionName;
		}

		public function get flags():int
		{
			return _flags;
		}

		public function addDocument(document:Document):void
		{
			if (null == document)
				throw new MongoError(MongoError.DOCUMENT_MUST_NOT_BE_NULL);

			_documents.push(document);
		}

		public function containsDocument(document:Document):Boolean
		{
			return _documents.lastIndexOf(document) > -1;
		}

		public function toByteArray():ByteArray
		{
			const byteArray:ByteArray = _msgHeader.toByteArray();

			_writeOpInsertBody(byteArray);

			msgHeader.updateMessageLength(byteArray);

			byteArray.position = 0;
			byteArray.endian = Endian.LITTLE_ENDIAN;
			return byteArray;
		}

		private function _writeOpInsertBody(byteArray:ByteArray):void
		{
			_writeInsertFlags(byteArray);
			_writeFullCollectionCString(byteArray);
			_writeDocuments(byteArray);
		}

		private function _writeInsertFlags(byteArray:ByteArray):void
		{
			byteArray.writeInt(_flags);
		}

		private function _writeFullCollectionCString(byteArray:ByteArray):void
		{
			byteArray.writeUTFBytes(_collectionName);
			byteArray.writeInt(0);
		}

		private function _writeDocuments(byteArray:ByteArray):void
		{
			for (var i:Number = 0; i < totalDocuments; i++)
			{
				byteArray.writeBytes(_bsonEncoder.encode(_documents[i]));
			}
		}
	}
}
