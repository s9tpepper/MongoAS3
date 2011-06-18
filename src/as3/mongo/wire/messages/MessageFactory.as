package as3.mongo.wire.messages
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.client.OpQuery;

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

	}
}
