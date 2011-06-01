package flexUnitTests.as3.mongo
{
	import as3.mongo.Mongo;
	import as3.mongo.db.DB;
	import as3.mongo.error.MongoError;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;

	public class Mongo_dbTests
	{		
		private var _mongo:Mongo;
		
		
		[Before]
		public function setUp():void
		{
			_mongo = new Mongo("");
		}
		
		[After]
		public function tearDown():void
		{
			_mongo = null;
		}
		
		
		[Test]
		public function db_dbNameNotNull_returnsDB():void
		{
			const db:DB = _mongo.db("aDatabase");
			
			assertTrue(db is DB);
		}
		
		
		[Test(expects="as3.mongo.error.MongoError")]
		public function db_dbNameNull_throwsMongoError():void
		{
			var error:MongoError;
			
			_mongo.db(null);
		}
		
		
		[Test]
		public function db_secondDbCallToSameDBName_returnsSameDBInstance():void
		{
			const dbName:String = "testDBName";
			const firstCall:DB = _mongo.db(dbName);
			const secondCall:DB = _mongo.db(dbName);
			
			assertEquals(firstCall, secondCall);
		}
	}
}