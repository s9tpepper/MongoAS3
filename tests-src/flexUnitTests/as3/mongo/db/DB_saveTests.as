package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.DB;
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.Wire;
	import as3.mongo.wire.cursor.Cursor;

	import flash.net.Socket;

	import flexUnitTests.as3.mongo.wire.TestWire;

	import flexunit.framework.Test;

	import mockolate.mock;
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
		private var _testSocket:Socket = new Socket();

		[Before]
		public function setUp():void
		{
			_db = new TestDB("aDatabaseName", "aHost", 27017);
//			mockWire = new TestWire(_db);
//			mock(mockWire).getter("socket").returns(_testSocket);
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
			mock(mockWire).method("save").args(instanceOf(String), instanceOf(Document)).returns(new Cursor(_testSocket));

			_db.save("testCollection", new Document());

			assertThat(mockWire, received().method("save").args(instanceOf(String), instanceOf(Document)).once());
		}
	}
}
