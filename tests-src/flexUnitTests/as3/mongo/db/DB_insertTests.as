package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.Wire;

	import mockolate.nice;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;

	public class DB_insertTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject = "false", type = "nice")]
		public var mockWire:Wire;

		private var _db:TestDB;

		[Before]
		public function setUp():void
		{
			_db = new TestDB("aDatabaseName", "aHost", 27017);

			mockWire = nice(Wire, null, [_db]);

			_db.mockWire = mockWire;
		}

		[After]
		public function tearDown():void
		{
			_db = null;
		}

		[Test]
		public function insert_collectionNameAndDocumentAreNotNull_saveInvokedOnWire():void
		{
			_db.insert("testCollection", new Document());

			assertThat(mockWire, received().method("insert").args(instanceOf(String), instanceOf(String), instanceOf(Document)).once());
		}
	}
}
