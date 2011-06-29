package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.Wire;

	import mockolate.nice;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;

	public class DB_saveTests
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
		public function save_collectionNameAndDocumentAreNotNull_saveInvokedOnWire():void
		{
			_db.save("testCollection", new Document(), function():void
			{
			});

			assertThat(mockWire, received().method("save").args(instanceOf(String), instanceOf(String), instanceOf(Document), instanceOf(Function)).once());
		}
	}
}
