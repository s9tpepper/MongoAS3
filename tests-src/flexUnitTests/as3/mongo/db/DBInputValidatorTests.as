package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.DBInputValidator;
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;

	import flexunit.framework.Assert;

	public class DBInputValidatorTests
	{

		[Before]
		public function setUp():void
		{
			var error:MongoError;
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function checkForInvalidCollectionNames_inputIsNull_throwsMongoError():void
		{
			DBInputValidator.checkForInvalidCollectionNames(null);
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function checkForInvalidCollectionNames_inputIsEmptyString_throwsMongoError():void
		{
			DBInputValidator.checkForInvalidCollectionNames("");
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function checkForInvalidFindOneParameters_collectionNameIsNull_throwsMongoError():void
		{
			DBInputValidator.checkForInvalidFindOneParameters(null, new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function checkForInvalidFindOneParameters_collectionNameIsEmptyString_throwsMongoError():void
		{
			DBInputValidator.checkForInvalidFindOneParameters("", new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function checkForInvalidFindOneParameters_commandDocumentIsNull_throwsMongoError():void
		{
			DBInputValidator.checkForInvalidFindOneParameters("aCollection", null);
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function DBInputValidatorTests_constructor_throwsMongoError():void
		{
			new DBInputValidator();
		}
	}
}
