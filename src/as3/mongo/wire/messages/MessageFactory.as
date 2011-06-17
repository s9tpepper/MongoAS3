package as3.mongo.wire.messages
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.client.OpQuery;

	public class MessageFactory
	{
		public function MessageFactory()
		{
		}

		public function makeFindOneOpQueryMessage(dbName:String,
												  collectionName:String,
												  query:Document,
												  returnFieldSelector:Document):OpQuery
		{
			const fullCollectionName:String = dbName + "." + collectionName;

			return new OpQuery(0, fullCollectionName, 0, 1, query, returnFieldSelector);
		}
	}
}
