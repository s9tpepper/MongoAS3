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

		public function OpReplyLoader(aSocket:Socket)
		{
			_initializeOpReplyLoader(aSocket);
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

		protected function _initializeOpReplyLoader(aSocket:Socket):void
		{
			trace("OpReplyLoader._initializeOpReplyLoader()");
			_socket = aSocket;
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, _handleSocketData, false, 0, true);
			_LOADED = new Signal(OpReply);
		}

		private function _handleSocketData(event:ProgressEvent):void
		{
			trace("OpReplyLoader._handleSocketData()");
			_initializeReplyLoading();
			_checkIfReplyIsComplete(event);
		}

		private function _checkIfReplyIsComplete(event:ProgressEvent):void
		{
			trace("_checkIfReplayIsComplete()");
			trace("(event.bytesLoaded == _currentReplyLength) = " + (event.bytesLoaded == _currentReplyLength).toString());
			if (event.bytesLoaded == _currentReplyLength)
			{
				_loading = false;
				_loaded = true;
				_dispatchLoadedSignal();
			}
		}

		protected function _dispatchLoadedSignal():void
		{
			LOADED.dispatch(new OpReply(_currentReplyLength, _socket));
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
