package as3.mongo.wire.cursor
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.database.OpReply;

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
		protected var _documents:Vector.<Document>;
		protected var _currentReplyLength:int;
		protected var _currentReplyLengthLoaded:int;
		protected var _loadingReply:Boolean;
		protected var _currentReply:OpReply;
		protected var _decoder:BSONDecoder;

		public function Cursor(cursorSocket:Socket)
		{
			_initializeCursor(cursorSocket);
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

		private function _initializeCursor(cursorSocket:Socket):void
		{
			_socket = cursorSocket;

			_isComplete = false;
			_documents = new Vector.<Document>();
			_currentReplyLength = -1;
			_currentReplyLengthLoaded = -1;
			_decoder = new BSONDecoder();

			_socket.addEventListener(ProgressEvent.SOCKET_DATA, _handleSocketData, false, 0, true);
		}

		private function _handleSocketData(event:ProgressEvent):void
		{
			trace("Cursor._handleSocketData()");
			_initializeReplyLoading();

			_currentReplyLengthLoaded = event.bytesLoaded;

			PROGRESS.dispatch();

			_checkIfReplyIsComplete();
		}

		private function _checkIfReplyIsComplete():void
		{
			if (_currentReplyLengthLoaded == _currentReplyLength)
			{
				_loadingReply = false;

				createOpReply();
				REPLY_COMPLETE.dispatch(_currentReply);
			}
		}

		protected function createOpReply():void
		{
			_currentReply = new OpReply(_currentReplyLength, _socket);
		}

		private function _initializeReplyLoading():void
		{
			if (!_loadingReply && _socket.bytesAvailable)
			{
				trace("_socket.bytesAvailable = " + _socket.bytesAvailable);
				_socket.endian = Endian.LITTLE_ENDIAN;
				_loadingReply = true;
				_currentReplyLength = _socket.readInt();
			}
		}

	}
}
