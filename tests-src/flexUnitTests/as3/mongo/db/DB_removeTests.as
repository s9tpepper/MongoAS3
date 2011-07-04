package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.Wire;

	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;

	public class DB_removeTests
	{
		[Rule]
		public var mocks:MockolateRule         = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockWire:Wire;

		private var _db:TestDB;
		private var _testCollectionName:String = "aCollection";
		private var _testSelector:Document     = new Document();
		private var _testDatabaseName:String   = "aDatabaseName";

		[Before]
		public function setUp():void
		{
			_db = new TestDB(_testDatabaseName, "host", 27017);
			_db.mockWire = mockWire;
		}

		[After]
		public function tearDown():void
		{
			_db = null;
		}

		[Test]
		public function remove_aDocumentInstanceIsPassedIn_removedInvokedOnWire():void
		{
			_db.remove(_testCollectionName, _testSelector);

			assertThat(mockWire, received().method("remove").args(_testDatabaseName, _testCollectionName, _testSelector).once());
		}
	}
}
