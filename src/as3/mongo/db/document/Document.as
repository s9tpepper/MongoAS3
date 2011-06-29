package as3.mongo.db.document
{
	import as3.mongo.error.MongoError;

	import org.serialization.bson.ObjectID;

	public class Document
	{
		private var _totalFields:uint;
		private var _keys:Array;
		private var _values:Array;

		public function Document(... rest)
		{
			_initializeDocument(rest);
		}

		private function _initializeDocument(rest:Array):void
		{
			_keys = [];
			_values = [];

			_parseDocumentFields(rest);
		}

		private function _parseDocumentFields(rest:Array):void
		{
			var argument:Object;
			for each (argument in rest)
			{
				_validateKeyValuePair(argument);

				_parseKeyValuePair(argument);

				_totalFields++;
			}
		}

		private function _parseKeyValuePair(argument:Object):void
		{
			var keyValuePair:String = argument as String;
			var pair:Array          = keyValuePair.split(":");
			_keys.push(pair[0]);
			_values.push(pair[1]);
		}

		private function _validateKeyValuePair(argument:Object):void
		{
			if (false == argument is String)
				throw new MongoError(MongoError.DOCUMENT_CONSTRUCTOR_ARGS_MUST_BE_COLON_SEPARATED_KEY_VALUE_STRING_PAIRS);

			if (_argumentHasColonSeparator(argument))
				throw new MongoError(MongoError.DOCUMENT_CONSTRUCTOR_STRING_ARG_MUST_BE_COLON_SEPARATED);
		}

		private function _argumentHasColonSeparator(argument:Object):Boolean
		{
			return -1 == (argument as String).lastIndexOf(":");
		}


		public function get totalFields():uint
		{
			return _totalFields;
		}

		public function getKeyAt(index:uint):*
		{
			return _keys[index];
		}

		public function getValueAt(index:uint):*
		{
			return _values[index];
		}

		public function put(key:String, value:*):void
		{
			const nextIndex:Number = _keys.length;
			_keys[nextIndex] = key;
			_values[nextIndex] = value;
		}
	}
}
