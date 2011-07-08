package as3.mongo.wire.cursor
{
	import as3.mongo.wire.messages.database.OpReply;
	import as3.mongo.wire.messages.database.OpReplyLoader;

	import flash.utils.Dictionary;

	import org.osflash.signals.Signal;
	import org.serialization.bson.Int64;

	public class Cursor
	{
		protected var _opReplyLoader:OpReplyLoader;
		protected var _ready:Boolean;
		protected var _totalDocumentsLoaded:uint;
		protected var _cursorID:Int64;
		protected var _documents:Dictionary = new Dictionary();
		protected var _currentIndex:int     = -1;
		protected var _lastIndexCached:int  = -1;
		protected var _activeIndices:Array  = [];
		protected var _cursorReady:Signal   = new Signal(Cursor);

		public function Cursor(opReplyLoader:OpReplyLoader)
		{
			_initializeCursor(opReplyLoader);
		}

		public function get cursorReady():Signal
		{
			return _cursorReady;
		}

		public function toString():String
		{
			return "Cursor{_opReplyLoader:" + _opReplyLoader + ", _ready:" + _ready + ", _totalDocumentsLoaded:" + _totalDocumentsLoaded + ", _cursorID:" + _cursorID + ", _documents:" + _documents + ", _currentIndex:" + _currentIndex + ", _lastIndexCached:" + _lastIndexCached + ", _activeIndices:[" + _activeIndices + "]}";
		}

		public function get cursorID():Int64
		{
			return _cursorID;
		}

		public function get totalDocumentsLoaded():uint
		{
			return _totalDocumentsLoaded;
		}

		public function get ready():Boolean
		{
			return _ready;
		}

		private function _initializeCursor(opReplyLoader:OpReplyLoader):void
		{
			_opReplyLoader = opReplyLoader;
			_opReplyLoader.LOADED.addOnce(_onLoaded);
		}

		private function _onLoaded(opReply:OpReply):void
		{
			_totalDocumentsLoaded += opReply.numberReturned;
			_cursorID = opReply.cursorID;
			_cacheDocuments(opReply);

			if (!_ready)
			{
				_ready = true;
				_cursorReady.dispatch(this);
			}
		}

		private function _cacheDocuments(opReply:OpReply):void
		{
			var returnIndex:uint;
			for (var i:int = opReply.startingFrom; i < (opReply.startingFrom + opReply.numberReturned); i++)
			{
				_documents[i] = opReply.documents[returnIndex];
				_activeIndices.push(i);
				_lastIndexCached = i;
				returnIndex++;
			}
		}

		public function hasMore():Boolean
		{
			return (null != _cursorID && "0 0 0 0 0 0 0 0 " != _cursorID.toString());
		}

		public function getNextDocument():Object
		{
			const nextIndex:uint    = getNextDocumentIndex();

			var nextDocument:Object = null;
			if (nextIndex != _currentIndex)
			{
				nextDocument = _documents[nextIndex];
				_currentIndex = nextIndex;
			}

			return nextDocument;
		}

		public function getNextDocumentIndex():int
		{
			var nextDocumentIndex:int = -1;

			if (_activeIndices.length)
				nextDocumentIndex = _getNextValidIndex(nextDocumentIndex);

			return nextDocumentIndex;
		}

		private function _getNextValidIndex(nextDocumentIndex:int):int
		{
			nextDocumentIndex = _currentIndex + 1;

			if (null == _documents[nextDocumentIndex])
				nextDocumentIndex = _calculateNextDocumentIndex(nextDocumentIndex);

			if (_lastIndexSearchedIsEmpty(nextDocumentIndex))
				nextDocumentIndex = _currentIndex;

			return nextDocumentIndex;
		}

		private function _lastIndexSearchedIsEmpty(nextCurrentIndex:int):Boolean
		{
			return null == _documents[nextCurrentIndex];
		}

		private function _calculateNextDocumentIndex(nextCurrentIndex:int):int
		{
			for (var i:uint = nextCurrentIndex; i < _lastIndexCached; i++)
			{
				if (null != _documents[i])
				{
					nextCurrentIndex = i;
					break;
				}
			}

			return nextCurrentIndex;
		}
	}
}
