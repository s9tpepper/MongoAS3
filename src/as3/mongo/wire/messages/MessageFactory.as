package as3.mongo.wire.messages
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.client.OpDelete;
	import as3.mongo.wire.messages.client.OpInsert;
	import as3.mongo.wire.messages.client.OpQuery;
	import as3.mongo.wire.messages.client.OpUpdate;
	import as3.mongo.wire.messages.client.OpUpdateFlags;

	public class MessageFactory
	{
		public function MessageFactory()
		{
		}

		private function _getFullCollectionName(dbName:String, collectionName:String):String
		{
			return dbName + "." + collectionName;
		}

		public function makeFindOneOpQueryMessage(dbName:String,
												  collectionName:String,
												  query:Document,
												  returnFieldSelector:Document):OpQuery
		{
			return new OpQuery(0, _getFullCollectionName(dbName, collectionName), 0, 1, query, returnFieldSelector);
		}

		public function makeRunCommandOpQueryMessage(dbName:String, collectionName:String, command:Document):OpQuery
		{
			return new OpQuery(0, _getFullCollectionName(dbName, collectionName), 0, -1, command, null);
		}

		public function makeSaveOpInsertMessage(dbName:String, collectionName:String, document:Document):OpInsert
		{
			const opInsert:OpInsert = new OpInsert(_getFullCollectionName(dbName, collectionName));
			opInsert.addDocument(document);
			return opInsert;
		}

		public function makeRemoveOpDeleteMessage(dbName:String, collectionName:String, selector:Document):OpDelete
		{
			return new OpDelete(_getFullCollectionName(dbName, collectionName), selector);
		}

		public function makeUpdateFirstOpUpdateMessage(dbName:String,
													   collectionName:String,
													   selector:Document,
													   update:Document):OpUpdate
		{
			return new OpUpdate(_getFullCollectionName(dbName, collectionName), OpUpdateFlags.NO_FLAGS, selector, update);
		}

		public function makeUpdateOpUpdateMessage(dbName:String,
												  collectionName:String,
												  selector:Document,
												  modifier:Document):OpUpdate
		{
			return new OpUpdate(_getFullCollectionName(dbName, collectionName), OpUpdateFlags.MULTI, selector, modifier);
		}
	}
}
