package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.AuthenticationFactory;
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.Wire;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.client.FindOptions;
	import as3.mongo.wire.messages.database.OpReplyLoader;

	import flash.net.Socket;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;

	public class DB_findTests
	{
		[Rule]
		public var mocks:MockolateRule      = new MockolateRule();

		[Mock(inject = "false", type = "nice")]
		public var mockWire:Wire;

		[Mock(inject = "false", type = "nice")]
		public var mockCursor:Cursor;

		[Mock(inject = "false", type = "nice")]
		public var mockSocket:Socket;

		[Mock(inject = "false", type = "nice")]
		public var mockOpReplyLoader:OpReplyLoader;

		[Mock(inject = "true", type = "nice")]
		public var mockAuthFactory:AuthenticationFactory;

		private var _db:TestDB;
		private var testDatabaseName:String = "testDBName";
		private var testHost:String         = "testhost";
		private var testPort:uint           = 2;


		[Before]
		public function setUp():void
		{
			_db = new TestDB(testDatabaseName, testHost, testPort);

			mockWire = nice(Wire, null, [_db]);
			_db.mockWire = mockWire;

			_db.authenticationFactory = mockAuthFactory;
		}

		[After]
		public function tearDown():void
		{
			_db = null;
		}

		[Test]
		public function find_validInputs_findInvokedOnWire():void
		{
			var testFindOptions:FindOptions = new FindOptions();
			var testQuery:Document          = new Document();
			var testCollectionName:String   = "aCollectionName";

			_db.find(testCollectionName, testQuery, testFindOptions);

			assertThat(mockWire, received().method("find").args(testDatabaseName, testCollectionName, testQuery, testFindOptions).once());
		}

		[Test]
		public function find_validInputsWithNullOptions_findInvokedOnWire():void
		{
			var testQuery:Document        = new Document();
			var testCollectionName:String = "aCollectionName";

			_db.find(testCollectionName, testQuery, null);

			assertThat(mockWire, received().method("find").args(testDatabaseName, testCollectionName, testQuery, null).once());
		}

		[Test]
		public function find_validInputs_returnsCursor():void
		{
			var testQuery:Document        = new Document();
			var testCollectionName:String = "aCollectionName";
			mock(mockWire).method("find").returns(new Cursor(new OpReplyLoader(new Socket())));

			const cursor:Cursor           = _db.find(testCollectionName, testQuery);

			assertTrue(cursor is Cursor);
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function find_invalidEmptyCollectionName_throwsError():void
		{
			_db.find("", new Document(), new FindOptions());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function find_invalidNullCollectionName_throwsError():void
		{
			_db.find(null, new Document(), new FindOptions());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function find_invalidCollectionNameWithPeriod_throwsError():void
		{
			_db.find("aCollection.name", new Document(), new FindOptions());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function find_invalidNullQueryDocument_throwsError():void
		{
			_db.find("aCollectionName", null, new FindOptions());
		}
	}
}
