package as3.mongo.wire.messages.client
{
	import as3.mongo.db.document.Document;

	public class FindOptions
	{
		private var _numberToSkip:int = 0;
		private var _numberToReturn:int = 0;
		private var _returnFieldSelector:Document = null;
		private var _flags:int;
		
		public function FindOptions(skip:int=0, numToReturn:int=0, fieldSelector:Document=null, findFlags:int=0)
		{
			_initializeOptions(skip, numToReturn, fieldSelector, findFlags);
		}
		
		private function _initializeOptions(skip:int, numToReturn:int, fieldSelector:Document, findFlags:int):void
		{
			_numberToSkip = skip;
			_numberToReturn = numToReturn;
			_returnFieldSelector = fieldSelector;
			_flags = findFlags;
		}
		
		public function get flags():int
		{
			return _flags;
		}

		public function set flags(value:int):void
		{
			_flags = value;
		}

		public function get returnFieldSelector():Document
		{
			return _returnFieldSelector;
		}

		public function set returnFieldSelector(value:Document):void
		{
			_returnFieldSelector = value;
		}

		public function get numberToReturn():int
		{
			return _numberToReturn;
		}

		public function set numberToReturn(value:int):void
		{
			_numberToReturn = value;
		}

		public function get numberToSkip():int
		{
			return _numberToSkip;
		}

		public function set numberToSkip(value:int):void
		{
			_numberToSkip = value;
		}

	}
}