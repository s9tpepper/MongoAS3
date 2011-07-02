package as3.mongo.wire.messages.database
{

	public class FindOneResult
	{
		private var _success:Boolean;
		private var _document:Object;

		public function FindOneResult(aSuccess:Boolean, aDocument:Object=null)
		{
			_success = aSuccess;
			_document = aDocument;
		}

		public function get document():Object
		{
			return _document;
		}

		public function get success():Boolean
		{
			return _success;
		}
	}
}
