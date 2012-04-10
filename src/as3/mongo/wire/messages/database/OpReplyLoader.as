package as3.mongo.wire.messages.database
{
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.Endian;

	import org.osflash.signals.Signal;

	public class OpReplyLoader
	{
		protected var _LOADED:Signal;
		protected var _socket:Socket;
		protected var _loading:Boolean;
		protected var _loaded:Boolean;
		protected var _opReply:OpReply;
		protected var _currentReplyLength:int;
		protected var _amountOfBytesLoaded:uint;

		public function OpReplyLoader()
		{
			_LOADED = new Signal(OpReply);
		}

		public function get opReply():OpReply
		{
			return _opReply;
		}

		public function get isLoaded():Boolean
		{
			return _loaded;
		}

		public function get LOADED():Signal
		{
			return _LOADED;
		}

		public function get socket():Socket
		{
			return _socket;
		}

		public function initializeOpReplyLoader(aSocket:Socket):void
		{
			_socket = aSocket;
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, _handleSocketData, false, 0, true);
		}

		private function _handleSocketData(event:ProgressEvent):void
		{
			_initializeReplyLoading();
			_checkIfReplyIsComplete(event);
		}

		private function _checkIfReplyIsComplete(event:ProgressEvent):void
		{
			_amountOfBytesLoaded += event.bytesLoaded;
			
			if (_amountOfBytesLoaded == _currentReplyLength)
			{
				_loading = false;
				_loaded = true;
				_socket.removeEventListener(ProgressEvent.SOCKET_DATA, _handleSocketData);
				_dispatchLoadedSignal();
			}
		}

		protected function _dispatchLoadedSignal():void
		{
			_opReply = new OpReply(_currentReplyLength, _socket);
			LOADED.dispatch(_opReply);
		}

		private function _initializeReplyLoading():void
		{
			if (!_loading && _socket.bytesAvailable >= 4)
			{
				_loading = true;
				_socket.endian = Endian.LITTLE_ENDIAN;
				_currentReplyLength = _socket.readInt();
			}
		}
	}
}
