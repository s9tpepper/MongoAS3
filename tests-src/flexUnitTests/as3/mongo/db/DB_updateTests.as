package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.Wire;

	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;

	public class DB_updateTests
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
		public function update_validInputs_updateInvokedOnWire():void
		{
			_db.update("aCollectionName", new Document(), new Document());

			assertThat(mockWire, received().method("update").args(_testDBName, "aCollectionName", instanceOf(Document), instanceOf(Document)).once());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function update_invalidEmptyCollectionName_throwsError():void
		{
			_db.update("", new Document(), new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function update_invalidNullCollectionName_throwsError():void
		{
			_db.update(null, new Document(), new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function update_invalidCollectionNameWithPeriodInIt_throwsError():void
		{
			_db.update("aCollection.name", new Document(), new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function update_invalidNullSelector_throwsError():void
		{
			_db.update("aCollectionName", null, new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function update_invalidNullModifier_throwsError():void
		{
			_db.update("aCollectionName", new Document(), null);
		}
	}
}
