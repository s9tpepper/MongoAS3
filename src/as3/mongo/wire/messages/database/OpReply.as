package as3.mongo.wire.messages.database
{
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.OpCodes;

	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import org.bson.BSONDecoder;
	import org.serialization.bson.BSON;
	import org.serialization.bson.Int64;

	public class OpReply
	{
		protected var _msgHeader:MsgHeader;
		protected var _messageLength:int;
		protected var _socket:Socket;
		protected var _responseFlags:int;
		protected var _cursorID:Int64;
		protected var _startingFrom:int;
		protected var _numberReturned:int;
		protected var _documents:Array;
		protected var _bsonDecoder:BSONDecoder;

		public function OpReply(replyMessageLength:int, buffer:Socket, decoder:BSONDecoder=null)
		{
			_initializeReply(replyMessageLength, buffer, decoder);
		}

		public function get bsonDecoder():BSONDecoder
		{
			return _bsonDecoder;
		}

		public function set bsonDecoder(value:BSONDecoder):void
		{
			_bsonDecoder = value;
		}

		private function _initializeReply(replyMessageLength:int, buffer:Socket, decoder:BSONDecoder=null):void
		{
			_bsonDecoder = (null == decoder) ? new BSONDecoder() : decoder;
			_socket = buffer;

			_setUpReplyMsgHeader(replyMessageLength);
			_readResponseFlags();
			_readCursorID();
			_readStartingFrom();
			_readNumberReturned();
			_readDocuments();

			// TODO: Implement OpGetMore once the object is created.

		/* Example implementation from ActionMongo */
//			// if there are more results, fetch them
//			if (0 != Int64.cmp(currentReply.cursorID, Int64.ZERO)) 
//			{
//				socket.addEventListener( ProgressEvent.SOCKET_DATA, parseReply );
//				socket.writeBytes( new OpGetMore( queryID, dbName+"."+collName, 0, currentReply.cursorID ).toBinaryMsg() );
//				socket.flush();
//				trace("getting more...");
//			}
//			else
//			{
//				//socket.close();
//				socket.removeEventListener( ProgressEvent.SOCKET_DATA, parseReply );
//				
//				// run a user-defined callback
//				trace( "callback" );
//				if (null != readAll)
//				{
//					readAll();
//				}
//			}
		}



		private function _setUpReplyMsgHeader(replyMessageLength:int):void
		{
			_messageLength = replyMessageLength;

			createMsgHeader();
			_readRequestID();
			_readResponseTo();
			_readOpCode();
		}

		protected function createMsgHeader():void
		{
			_msgHeader = new MsgHeader();
		}

		private function _readRequestID():void
		{
			_readSocketInteger(_msgHeader, "requestID");
		}

		private function _readResponseTo():void
		{
			_readSocketInteger(_msgHeader, "responseTo");
		}

		private function _readStartingFrom():void
		{
			_readSocketInteger(this, "_startingFrom");
		}

		private function _readOpCode():void
		{
			_readSocketInteger(_msgHeader, "opCode");
		}

		private function _readResponseFlags():void
		{
			_readSocketInteger(this, "_responseFlags");
		}

		private function _readNumberReturned():void
		{
			_readSocketInteger(this, "_numberReturned");
		}

		private function _readSocketInteger(host:Object, key:String):void
		{
			if (_socketContainsIntBytes())
				host[key] = _socket.readInt();
		}

		private function _socketContainsIntBytes():Boolean
		{
			return _socket.bytesAvailable >= 4;
		}


		private function _readDocuments():void
		{
			_documents = [];
			var docByteArray:ByteArray;
			var docSize:int  = 0;
			var docsRead:int = 0;
			var doc:Object;
			while (docsRead < _numberReturned)
			{
				docByteArray = _writeDocumentToItsOwnByteArray(docSize, new ByteArray());

				_documents.push(_readDocument(docByteArray));

				++docsRead;
			}
		}

		private function _readDocument(docByteArray:ByteArray):Object
		{
			var doc:Object;
			docByteArray.position = 0;
			doc = bsonDecoder.decode(docByteArray);
			return doc;
		}

		private function _writeDocumentToItsOwnByteArray(docSize:int, docByteArray:ByteArray):ByteArray
		{
			docByteArray.endian = Endian.LITTLE_ENDIAN;
			_socket.endian = Endian.LITTLE_ENDIAN;

			docSize = _socket.readInt();
			docByteArray.writeInt(docSize);
			_socket.readBytes(docByteArray, 4, docSize - 4);
			return docByteArray;
		}

		private function _readCursorID():void
		{
			const int64:ByteArray = _getInt64ByteArray();
			_socket.endian = Endian.LITTLE_ENDIAN;
			_socket.readBytes(int64, 0, 8);
			_cursorID = new Int64(int64);
		}

		private function _getInt64ByteArray():ByteArray
		{
			const int64:ByteArray = new ByteArray();
			int64.writeByte(0);
			int64.writeByte(0);
			int64.writeByte(0);
			int64.writeByte(0);
			int64.writeByte(0);
			int64.writeByte(0);
			int64.writeByte(0);
			int64.writeByte(0);
			int64.position = 0;
			return int64;
		}

		public function get socket():Socket
		{
			return _socket;
		}

		public function get messageLength():int
		{
			return _messageLength;
		}

		public function get msgHeader():MsgHeader
		{
			return _msgHeader;
		}

		public function get responseFlags():int
		{
			return _responseFlags;
		}

		public function get cursorID():Int64
		{
			return _cursorID;
		}

		public function get startingFrom():int
		{
			return _startingFrom;
		}

		public function get numberReturned():int
		{
			return _numberReturned;
		}

		public function get documents():Array
		{
			return _documents;
		}
	}
}
