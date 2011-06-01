package as3.mongo.db.collection
{
	import as3.mongo.db.DB;
	import as3.mongo.db.document.Document;

	public class Collection
	{
		private var _name:String;
		private var _db:DB;
		
		public function Collection(collectionName:String, db:DB)
		{
			_initializeCollection(collectionName, db);
		}
		
		public function get db():DB
		{
			return _db;
		}

		public function get name():String
		{
			return _name;
		}

		private function _initializeCollection(collectionName:String, collectionDB:DB):void
		{
			_name = collectionName;
			_db = collectionDB;
		}
		
		public function findOne(query:Document, returnFields:Document=null, readAllDocumentsCallback:Function=null):void
		{
			_db.findOne(_name, query, returnFields, readAllDocumentsCallback);
		}
	}
}