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

		public function insert(document:Document):void
		{
			_validateDocumentInstance(document);

			_db.insert(_name, document);
		}

		public function remove(selector:Document):void
		{
			_validateDocumentInstance(selector);

			_db.remove(name, selector);
		}

		private function _validateDocumentInstance(document:Document):void
		{
			if (null == document)
				throw new MongoError(MongoError.DOCUMENT_MUST_NOT_BE_NULL);
		}

		public function updateFirst(selector:Document, update:Document):void
		{
			_validateDocumentInstance(selector);
			_validateDocumentInstance(update);
			_db.updateFirst(name, selector, update);
		}

		public function update(selector:Document, modifier:Document):void
		{
			_validateDocumentInstance(selector);
			_validateDocumentInstance(modifier);
			_db.update(name, selector, modifier);
		}
	}
}
