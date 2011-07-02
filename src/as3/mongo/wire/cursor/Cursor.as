package as3.mongo.wire.cursor
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.database.OpReply;
	import as3.mongo.wire.messages.database.OpReplyLoader;

	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.Endian;

	import org.bson.BSONDecoder;
	import org.osflash.signals.Signal;

	public class Cursor
	{
		public const PROGRESS:Signal                    = new Signal();
		public const REPLY_COMPLETE:Signal              = new Signal(OpReply);

		// After reading the size of a reply, 4 bytes of the message size have been exhausted. This value is added to the bytesAvailable to update the message size.
		private static const _RESPONSE_READ_LENGTH:uint = 4;

		protected var _socket:Socket;
		protected var _isComplete:Boolean;
		protected var _documents:Vector.<Document>      = new Vector.<Document>();
		protected var _currentReplyLength:int           = -1;
		protected var _currentReplyLengthLoaded:int     = -1;
		protected var _loadingReply:Boolean;
		protected var _currentReply:OpReply;
		protected var _decoder:BSONDecoder;

		public function Cursor(opReplyLoader:OpReplyLoader)
		{
			_initializeCursor(opReplyLoader);
		}

		public function get decoder():BSONDecoder
		{
			return _decoder;
		}

		public function get loadingReply():Boolean
		{
			return _loadingReply;
		}

		public function get currentReplyLengthLoaded():int
		{
			return _currentReplyLengthLoaded;
		}

		public function get currentReplyLength():int
		{
			return _currentReplyLength;
		}

		public function get documents():Vector.<Document>
		{
			return _documents;
		}

		public function get isComplete():Boolean
		{
			return _isComplete;
		}

		public function get socket():Socket
		{
			return _socket;
		}

		private function _initializeCursor(opReplyLoader:OpReplyLoader):void
		{
//			_socket = cursorSocket;
//
//			_isComplete = false;
//			_documents = new Vector.<Document>();
//			_currentReplyLength = -1;
//			_currentReplyLengthLoaded = -1;
//			_decoder = new BSONDecoder();
		}
	}
}
