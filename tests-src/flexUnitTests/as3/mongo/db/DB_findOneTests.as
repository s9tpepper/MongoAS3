package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.DB;
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;
	import as3.mongo.wire.Wire;
	import as3.mongo.wire.cursor.Cursor;
	
	import flash.events.EventDispatcher;
	import flash.events.UncaughtErrorEvent;
	
	import flexunit.framework.TestCase;
	
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	
	import mx.core.FlexGlobals;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.instanceOf;


	public class DB_findOneTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock(inject="false", type="nice")]
		public var mockWire:Wire;

		[Mock(inject="false", type="nice")]
		public var mockCursor:Cursor;
		
		private var _db:TestDB;
		private var testDatabaseName:String = "testDBName";
		private var testHost:String = "testhost";
		private var testPort:uint = 2;
		
		
		[Before]
		public function setUp():void
		{
			_db = new TestDB(testDatabaseName, testHost, testPort);
		}
		
		[After]
		public function tearDown():void
		{
			_db = null;
		}
		
		[Test(expects="as3.mongo.error.MongoError")]
		public function findOne_collectionNameIsNull_throwsMongoError():void
		{
			var error:MongoError;
			
			_db.findOne(null, new Document(), new Document(), null);
		}
		
		[Test(expects="as3.mongo.error.MongoError")]
		public function findOne_queryDocumentIsNull_throwsMongoError():void
		{
			var error:MongoError;
			
			_db.findOne("collectionName", null, null, null);
		}
		
		[Test]
		public function findOne_collectionNameAndQueryNotNull_findOneInvokedOnWire():void
		{
			const testCollectionName:String = "collectionName";
			const testQuery:Document = new Document();
			const testResultFieldSelector:Document = new Document();
			const testReadResults:Function = function():void {};
			
			mockWireFindOneMethod(testCollectionName, testQuery, testResultFieldSelector, testReadResults);
			
			_db.findOne(testCollectionName, testQuery, testResultFieldSelector, testReadResults);
			
			assertThat(mockWire, received().method("findOne").args(testCollectionName, testQuery, testResultFieldSelector, testReadResults).once());
		}
		private function mockWireFindOneMethod(testCollectionName:String, testQuery:Document, testResultFieldSelector:Document, testReadResults:Function):void
		{
			mockWire = nice(Wire, null, [_db]);
			mockCursor = nice(Cursor);
			mock(mockWire).method("findOne").args(testCollectionName, testQuery, testResultFieldSelector, testReadResults).returns(mockCursor);
			_db.mockWire = mockWire;
		}

		[Test]
		public function findOne_validInputs_returnsCursor():void
		{
			const testCollectionName:String = "collectionName";
			const testQuery:Document = new Document();
			const testResultFieldSelector:Document = new Document();
			const testReadResults:Function = function():void {};
			mockWireFindOneMethod(testCollectionName, testQuery, testResultFieldSelector, testReadResults);
			
			const cursor:Cursor = _db.findOne(testCollectionName, testQuery, testResultFieldSelector, testReadResults);
			
			assertTrue(cursor is Cursor);
		}
	}
}