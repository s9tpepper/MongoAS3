package as3.mongo.db.collection
{
	import as3.mongo.db.DB;
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;
	import as3.mongo.wire.cursor.Cursor;

	import org.osflash.signals.Signal;

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

		public function findOne(query:Document, returnFields:Document=null):Signal
		{
			return _db.findOne(_name, query, returnFields);
		}

		public function save(document:Document, readAllDocumentsCallback:Function=null):void
		{
			if (null == document)
				throw new MongoError(MongoError.DOCUMENT_MUST_NOT_BE_NULL);

			_db.save(_name, document, readAllDocumentsCallback);
		}
	}
}
