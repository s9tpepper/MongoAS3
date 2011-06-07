package as3.mongo.wire.cursor
{
	import as3.mongo.db.document.Document;
	
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.Endian;
	
	import org.osflash.signals.Signal;

	public class Cursor
	{
		public static const PROGRESS:Signal = new Signal();
		public static const REPLY_COMPLETE:Signal = new Signal();
		
		// After reading the size of a reply, 4 bytes of the message size have been exhausted. This value is added to the bytesAvailable to update the message size.
		private static const _READ_RESPONSE_LENGTH:uint = 4; 
		
		private var _socket:Socket;
		private var _isComplete:Boolean;
		private var _documents:Vector.<Document>;
		private var _currentReplyLength:int;
		private var _currentReplyLengthLoaded:int;
		private var _loadingReply:Boolean;
		
		public function Cursor(cursorSocket:Socket)
		{
			_initializeCursor(cursorSocket);
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
			
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, _handleSocketData, false, 0, true);
		}
		
		private function _handleSocketData(event:ProgressEvent):void
		{
			if (!_loadingReply)
			{
				_socket.endian = Endian.LITTLE_ENDIAN;
				_loadingReply = true;
				_currentReplyLength = _socket.readInt();
			}
			
			_currentReplyLengthLoaded = _socket.bytesAvailable + _READ_RESPONSE_LENGTH;
			
			PROGRESS.dispatch();
			
			if (_currentReplyLengthLoaded == _currentReplyLength)
			{
				REPLY_COMPLETE.dispatch();
				trace("reply complete.");
			}
		}
		
	}
}