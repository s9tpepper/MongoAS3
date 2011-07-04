package flexUnitTests.as3.mongo.db.collection
{
	import as3.mongo.db.DB;
	import as3.mongo.db.collection.Collection;
	import as3.mongo.db.document.Document;

	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;

	public class Collection_upsertTests
	{

		[Rule]
		public var mocks:MockolateRule         = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockDB:DB;

		private var _testCollectionName:String = "aCollectionName";
		private var _collection:Collection;

		[Before]
		public function setUp():void
		{
			_collection = new Collection(_testCollectionName, mockDB);
		}

		[After]
		public function tearDown():void
		{
			_collection = null;
		}

		[Test]
		public function upsert_validInputs_upsertInvokedOnDB():void
		{
			var document:Document = new Document();
			var selector:Document = new Document();

			_collection.upsert(selector, document);

			assertThat(mockDB, received().method("upsert").args(_testCollectionName, instanceOf(Document), instanceOf(Document)).once());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function upsert_invalidNullSelector_throwsError():void
		{
			_collection.upsert(null, new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function upsert_invalidNullDocument_throwsError():void
		{
			_collection.upsert(new Document(), null);
		}
	}
}
