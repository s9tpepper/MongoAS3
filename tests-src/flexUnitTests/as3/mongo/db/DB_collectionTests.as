package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.collection.Collection;
	import as3.mongo.error.MongoError;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	public class DB_collectionTests
	{		
		private var _testDBName:String = "testDBName";
		private var _testHost:String = "host";
		private var _testPort:Number = 2;
		private var _db:TestDB;
		
		[Before]
		public function setUp():void
		{
			_db = new TestDB(_testDBName, _testHost, _testPort);
		}
		
		[After]
		public function tearDown():void
		{
			_db = null;
		}
		
		[Test(expects="as3.mongo.error.MongoError")]
		public function collection_nullCollectionName_throwsMongoError():void
		{
			var error:MongoError;
			
			_db.collection(null);
		}
		
		[Test(expects="as3.mongo.error.MongoError")]
		public function collection_emptyCollectionName_throwsMongoError():void
		{
			var error:MongoError;
			
			_db.collection("");
		}
		
		[Test]
		public function collection_nonNullCollectionName_returnsCollection():void
		{
			const testCollectionName:String = "aCollectionName";
			
			const collection:Collection = _db.collection(testCollectionName);
			
			assertTrue(collection is Collection);
		}
		
		[Test]
		public function collection_secondCallWithSameNonNullCollectionName_returnsSameCollectionInstance():void
		{
			const testCollectionName:String = "aCollectionName";
			const firstCall:Collection = _db.collection(testCollectionName);
			const secondCall:Collection = _db.collection(testCollectionName);
			
			assertEquals(firstCall, secondCall);
		}
	}
}