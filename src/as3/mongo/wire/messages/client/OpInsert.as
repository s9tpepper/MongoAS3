package as3.mongo.wire.messages.client
{
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.OpCodes;

	import flash.utils.ByteArray;

	public class OpInsert
	{
		protected var _flags:int;
		protected var _collectionName:String;
		protected var _documents:Vector.<Document>;
		protected var _msgHeader:MsgHeader;

		public function OpInsert(insertFlags:int, fullCollectionName:String)
		{
			_initializeOpInsert(insertFlags, fullCollectionName);
		}

		private function _initializeOpInsert(insertFlags:int, fullCollectionName:String):void
		{
			_documents = new Vector.<Document>();
			_flags = insertFlags;
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
			// TODO Auto Generated method stub
			return null;
		}
	}
}
