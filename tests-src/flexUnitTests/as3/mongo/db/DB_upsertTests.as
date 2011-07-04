package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.Wire;

	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;

	public class DB_upsertTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockWire:Wire;

		private var _db:TestDB;
		private var _testDBName:String = "aDatabaseName";

		[Before]
		public function setUp():void
		{
			_db = new TestDB(_testDBName, "host", 27017);
			_db.mockWire = mockWire;
		}

		[After]
		public function tearDown():void
		{
			_db = null;
		}

		[Test]
		public function upsert_validInputs_upsertInvokedOnWire():void
		{
			_db.upsert("aCollectionName", new Document(), new Document());

			assertThat(mockWire, received().method("upsert").args(_testDBName, "aCollectionName", instanceOf(Document), instanceOf(Document)).once());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function upsert_invalidEmptyCollectionName_throwsError():void
		{
			_db.upsert("", new Document(), new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function upsert_invalidNullCollectionName_throwsError():void
		{
			_db.upsert(null, new Document(), new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function upsert_invalidCollectionNameWithPeriod_throwsError():void
		{
			_db.upsert("aCollection.name", new Document(), new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function upsert_invalidNullSelector_throwsError():void
		{
			_db.upsert("aCollectionName", null, new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function upsert_invalidNullDocument_throwsError():void
		{
			_db.upsert("aCollectionName", new Document(), null);
		}
	}
}
