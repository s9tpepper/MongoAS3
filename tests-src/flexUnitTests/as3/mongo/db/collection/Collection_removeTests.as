package flexUnitTests.as3.mongo.db.collection
{
	import as3.mongo.db.DB;
	import as3.mongo.db.collection.Collection;
	import as3.mongo.db.document.Document;

	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;

	public class Collection_removeTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockDB:DB;

		private var _collection:Collection;

		[Before]
		public function setUp():void
		{
			_collection = new Collection("aCollection", mockDB);
		}

		[After]
		public function tearDown():void
		{
			_collection = null;
		}

		[Test]
		public function remove_aDocumentInstanceIsPassedIn_removeInvokedOnDB():void
		{
			const testDoc:Document = new Document();
			_collection.remove(testDoc);

			assertThat(mockDB, received().method("remove").args("aCollection", testDoc).once());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function remove_aNullObjectIsPassedIn_throwsMongoError():void
		{
			_collection.remove(null);
		}
	}
}
