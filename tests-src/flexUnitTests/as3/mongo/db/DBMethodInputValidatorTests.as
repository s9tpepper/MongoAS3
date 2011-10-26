package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.DB;
	import as3.mongo.db.DBMethodInputValidator;
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;

	import flexunit.framework.Assert;

	import mockolate.mock;
	import mockolate.runner.MockolateRule;

	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	public class DBMethodInputValidatorTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockDB:DB;

		[Before]
		public function setUp():void
		{
			var error:MongoError;
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function DBInputValidatorTests_constructor_throwsMongoError():void
		{
			new DBMethodInputValidator();
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function checkForInvalidDocumentInputs_inputIsNull_throwsMongoError():void
		{
			DBMethodInputValidator.checkForInvalidDocumentInputs(null);
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function checkForInvalidCollectionNames_inputIsNull_throwsMongoError():void
		{
			DBMethodInputValidator.checkForInvalidCollectionNames(null);
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function checkForInvalidCollectionNames_inputIsEmptyString_throwsMongoError():void
		{
			DBMethodInputValidator.checkForInvalidCollectionNames("");
		}

		[Deprecated(message = "This test is deprecated as of version 0.3. Periods in collection names are needed to access collections like 'system.indexes'.")]
		[Ignore]
		[Test(expects = "as3.mongo.error.MongoError")]
		public function checkForInvalidCollectionNames_inputHasPeriod_throwsMongoError():void
		{
			DBMethodInputValidator.checkForInvalidCollectionNames("collection.name");
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function checkForInvalidFindOneParameters_collectionNameIsNull_throwsMongoError():void
		{
			DBMethodInputValidator.checkForInvalidFindOneParameters(null, new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function checkForInvalidFindOneParameters_collectionNameIsEmptyString_throwsMongoError():void
		{
			DBMethodInputValidator.checkForInvalidFindOneParameters("", new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function checkForInvalidFindOneParameters_commandDocumentIsNull_throwsMongoError():void
		{
			DBMethodInputValidator.checkForInvalidFindOneParameters("aCollection", null);
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function canAuthenticate_hasCredentialsIsFalse_throwsMongoError():void
		{
			mock(mockDB).getter("hasCredentials").returns(false);
			DBMethodInputValidator.canAuthenticate(mockDB);
		}

		[Test]
		public function canAuthenticate_hasCredentialsIsTrue_returnsTrue():void
		{
			mock(mockDB).getter("hasCredentials").returns(true);
			assertTrue(DBMethodInputValidator.canAuthenticate(mockDB));
		}
	}
}
