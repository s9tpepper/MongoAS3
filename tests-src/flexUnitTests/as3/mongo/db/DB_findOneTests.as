package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.AuthenticationFactory;
	import as3.mongo.db.DB;
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;
	import as3.mongo.wire.Wire;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.database.FindOneResult;
	import as3.mongo.wire.messages.database.OpReplyLoader;

	import flash.events.EventDispatcher;
	import flash.events.UncaughtErrorEvent;
	import flash.net.Socket;

	import flexunit.framework.TestCase;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import mx.core.FlexGlobals;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.instanceOf;
	import org.osflash.signals.Signal;


	public class DB_findOneTests
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
			_db.authenticationFactory = mockAuthFactory;
		}

		[After]
		public function tearDown():void
		{
			_db = null;
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function findOne_collectionNameIsNull_throwsMongoError():void
		{
			var error:MongoError;

			_db.findOne(null, new Document(), new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function findOne_queryDocumentIsNull_throwsMongoError():void
		{
			var error:MongoError;

			_db.findOne("collectionName", null, null);
		}

		[Test]
		public function findOne_collectionNameAndQueryNotNull_findOneInvokedOnWire():void
		{
			const testCollectionName:String        = "collectionName";
			const testQuery:Document               = new Document();
			const testResultFieldSelector:Document = new Document();
			const testReadResults:Function         = function():void
			{
			};

			mockWireFindOneMethod(testCollectionName, testQuery, testResultFieldSelector);

			_db.findOne(testCollectionName, testQuery, testResultFieldSelector);

			assertThat(mockWire, received().method("findOne").args(testCollectionName, testQuery, testResultFieldSelector).once());
		}

		private function mockWireFindOneMethod(testCollectionName:String,
											   testQuery:Document,
											   testResultFieldSelector:Document):void
		{
			mockWire = nice(Wire, null, [_db]);
			mockSocket = nice(Socket)
			mockOpReplyLoader = nice(OpReplyLoader, null, [mockSocket]);
			mockCursor = nice(Cursor, null, [mockOpReplyLoader]);
			mock(mockWire).method("findOne").args(testCollectionName, testQuery, testResultFieldSelector).returns(new Signal(FindOneResult));
			_db.mockWire = mockWire;
		}

		[Test]
		public function findOne_validInputs_returnsSignal():void
		{
			const testCollectionName:String        = "collectionName";
			const testQuery:Document               = new Document();
			const testResultFieldSelector:Document = new Document();
			const testReadResults:Function         = function():void
			{
			};
			mockWireFindOneMethod(testCollectionName, testQuery, testResultFieldSelector);

			const signal:Signal                    = _db.findOne(testCollectionName, testQuery, testResultFieldSelector);

			assertTrue(signal is Signal);
		}
	}
}
