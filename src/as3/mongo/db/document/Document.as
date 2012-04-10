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
			return _keys.length;
		}

		public function getKeyAt(index:uint):*
		{
			return _keys[index];
		}

		public function getValueAt(index:uint):*
		{
			return _values[index];
		}
		
		/**
		 * ERICSOCO ADDED
		 */
		public function getValueByKey(key:String):*
		{
			var index:int = _keys.indexOf(key);
			if (index == -1) { return null; }
			else { return _values[index]; }
		}

		public function put(key:String, value:*):void
		{
			/**
			 * ERICSOCO ADDED
			 */
			var existingIndex:int = _keys.indexOf(key);
			if (existingIndex != -1) {
				_values[existingIndex] = value;
				return;
			}
			
			const nextIndex:Number = _keys.length;
			_keys[nextIndex] = key;
			_values[nextIndex] = value;
		}
		
		/**
		 * ERICSOCO ADDED
		 */
		public function remove (key:String) :void {
			var existingIndex:int = _keys.indexOf(key);
			if (existingIndex != -1) {
				_keys.splice(existingIndex, 1);
				_values.splice(existingIndex, 1);
			}
		}
		
		/**
		 * ERICSOCO ADDED
		 */
		public function toString (tabLevel:int=0) :String {
			function addTabs () :String {
				var tabStr:String = "";
				for (var t:int=0; t<tabLevel; t++) {
					tabStr += "\t";
				}
				return tabStr;
			}
			
			var output:String = addTabs() + "{\n";
			var len:int = _keys.length;
			var value:*;
			
			tabLevel++;
			for (var i:int=0; i<len; i++) {
				output += addTabs();
				output += (_keys[i] + " : ");
				
				value = _values[i];
				if (value is Document) {
					output += Document(value).toString(tabLevel);
				} else if (value is Array) {
					var arr:Array = value as Array;
					output += "[\n";
					tabLevel++;
					for (var j:int=0; j<arr.length; j++) {
						output += (arr[j].toString(tabLevel) + ",\n");
					}
					tabLevel--;
					output += (addTabs() + "]");
				} else {
					output += String(value);
				}
				output += "\n";
			}
			tabLevel--;
			
			output += (addTabs() + "}")
			return output;
		}
	}
}
