package as3.mongo.wire.cursor
{
	import as3.mongo.wire.messages.database.OpReply;
	import as3.mongo.wire.messages.database.OpReplyLoader;

	import flash.utils.Dictionary;

	import org.serialization.bson.Int64;

	public class Cursor
	{
		private var _opReplyLoader:OpReplyLoader;
		private var _ready:Boolean;
		private var _documentsLoaded:uint;
		private var _cursorID:Int64;
		private var _documents:Dictionary = new Dictionary();
		private var _currentIndex:int     = -1;
		private var _lastIndexCached:int  = -1;

		public function Cursor(opReplyLoader:OpReplyLoader)
		{
			_initializeCursor(opReplyLoader);
		}

		public function toString():String
		{
			return "Cursor{_opReplyLoader:" + _opReplyLoader + ", _ready:" + _ready + ", _documentsLoaded:" + _documentsLoaded + ", _cursorID:" + _cursorID + ", _documents:" + _documents + ", _currentIndex:" + _currentIndex + ", _lastIndexCached:" + _lastIndexCached + ", _activeIndices:[" + _activeIndices + "]}";
		}

		public function get cursorID():Int64
		{
			return _cursorID;
		}

		public function get documentsLoaded():uint
		{
			return _documentsLoaded;
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
			_documentsLoaded += opReply.numberReturned;
			_cursorID = opReply.cursorID;
			_cacheDocuments(opReply);
		}

		private var _activeIndices:Array  = [];

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
