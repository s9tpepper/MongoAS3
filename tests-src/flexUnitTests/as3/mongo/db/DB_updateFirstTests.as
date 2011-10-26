package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.DB;
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.Wire;

	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;

	public class DB_updateFirstTests
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
		public function updateFirst_validInputs_updateFirstInvokedOnWire():void
		{
			const testCollectionName:String = "aCollection";
			const selector:Document         = new Document();
			const update:Document           = new Document();

			_db.updateFirst(testCollectionName, selector, update);

			assertThat(mockWire, received().method("updateFirst").args(_testDBName, testCollectionName, selector, update).once());
		}

		[Deprecated(message = "This test is deprecated as of version 0.3. Periods in collection names are needed to access collections like 'system.indexes'.")]
		[Ignore]
		[Test(expects = "as3.mongo.error.MongoError")]
		public function updateFirst_invalidCollectionNameContainsPeriod_throwsError():void
		{
			_db.updateFirst("acollectionname.withperiod", new Document(), new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function updateFirst_nullCollectionName_throwsError():void
		{
			_db.updateFirst(null, new Document(), new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function updateFirst_emptyCollectionName_throwsError():void
		{
			_db.updateFirst("", new Document(), new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function updateFirst_nullSelector_throwsError():void
		{
			_db.updateFirst("acollection", null, new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function updateFirst_nullUpdate_throwsError():void
		{
			_db.updateFirst("acollection", new Document(), null);
		}
	}
}
