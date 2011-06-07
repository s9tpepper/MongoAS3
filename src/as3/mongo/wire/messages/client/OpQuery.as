package as3.mongo.wire.messages.client
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.OpCodes;
	
	import flash.utils.ByteArray;
	
	import org.bson.BSONEncoder;
	
	public class OpQuery
	{
		protected var _msgHeader:MsgHeader;
		protected var _bsonEncoder:BSONEncoder;
		
		private var _flags:int;
		private var _fullCollectionName:String;
		private var _numberToSkip:int;
		private var _numberToReturn:int;
		private var _query:Document;
		private var _returnFieldSelector:Document;
		static public const CSTRING_END_MARKER:int = 0;
		
		public function OpQuery(queryFlags:int, 
								queryFullCollectionName:String, 
								queryNumberToSkip:int, 
								queryNumberToReturn:int, 
								queryQuery:Document, 
								queryReturnFieldSelector:Document=null)
		{
			super();
			
			_initialize(queryFlags, queryFullCollectionName, queryNumberToSkip, queryNumberToReturn, queryQuery, queryReturnFieldSelector);
		}

		public function get bsonEncoder():BSONEncoder
		{
			return _bsonEncoder;
		}

		public function get returnFieldSelector():Document
		{
			return _returnFieldSelector;
		}

		public function get query():Document
		{
			return _query;
		}

		public function get numberToReturn():int
		{
			return _numberToReturn;
		}

		public function get numberToSkip():int
		{
			return _numberToSkip;
		}

		public function get fullCollectionName():String
		{
			return _fullCollectionName;
		}

		public function get flags():int
		{
			return _flags;
		}

		private function _initialize(queryFlags:int, 
									 queryFullCollectionName:String, 
									 queryNumberToSkip:int, 
									 queryNumberToReturn:int, 
									 queryQuery:Document, 
									 queryReturnFieldSelector:Document):void
		{
			createMsgHeader();
			
			_bsonEncoder = new BSONEncoder();
			
			_flags = queryFlags;
			_fullCollectionName = queryFullCollectionName;
			_numberToSkip = queryNumberToSkip;
			_numberToReturn = queryNumberToReturn;
			_query = queryQuery;
			_returnFieldSelector = queryReturnFieldSelector;
		}

		protected function createMsgHeader():void
		{
			_msgHeader = new MsgHeader();
			_msgHeader.opCode = OpCodes.OP_QUERY;
		}
		
		
		public function get msgHeader():MsgHeader
		{
			return _msgHeader;
		}

		public function toByteArray():ByteArray
		{
			const byteArray:ByteArray = _msgHeader.toByteArray();
			
			byteArray.position = 16; // FIXME: The MsgHeader.toByteArray() is moving the position to zero, without setting back to end the header is overwritten
			writeOpQueryBody(byteArray);
			
			_msgHeader.updateMessageLength(byteArray); // TODO: Write unit test to make sure message length is updated.
			
			byteArray.position = 0;
			return byteArray;
		}

		protected function writeOpQueryBody(byteArray:ByteArray):void
		{
			byteArray.writeInt(flags);
			byteArray.writeUTFBytes(fullCollectionName);
			byteArray.writeByte(CSTRING_END_MARKER);
			byteArray.writeInt(numberToSkip);
			byteArray.writeInt(numberToReturn);
			
			const encodedQueryDocument:ByteArray = _bsonEncoder.encode(_query);
			byteArray.writeBytes(encodedQueryDocument);
			
			// TODO: Write test for this null return field selector case
			if (returnFieldSelector)
			{
				const encodedReturnFieldSelectorDocument:ByteArray = _bsonEncoder.encode(returnFieldSelector);
				byteArray.writeBytes(encodedReturnFieldSelectorDocument);
			}
		}


	}
}