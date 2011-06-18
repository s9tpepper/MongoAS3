package as3.mongo.db
{
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;

	public class DBInputValidator
	{
		public function DBInputValidator()
		{
			throw new MongoError(MongoError.NOT_INSTANCE_CLASS);
		}

		static public function checkForInvalidFindOneParameters(collectionName:String, query:Document):void
		{
			if (null == collectionName || "" == collectionName)
				throw new MongoError(MongoError.COLLECTION_NAME_MAY_NOT_BE_NULL_OR_EMPTY);

			if (null == query)
				throw new MongoError(MongoError.QUERY_DOCUMENT_MAY_NOT_BE_NULL);
		}

		static public function checkForInvalidCollectionNames(collectionName:String):void
		{
			if (null == collectionName)
				throw new MongoError(MongoError.COLLECTION_NAME_MAY_NOT_BE_NULL_OR_EMPTY);

			if ("" == collectionName)
				throw new MongoError(MongoError.COLLECTION_NAME_MAY_NOT_BE_NULL_OR_EMPTY);
		}
	}
}
