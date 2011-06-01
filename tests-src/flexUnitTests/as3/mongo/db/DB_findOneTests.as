package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.DB;
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;

	public class DB_findOneTests
	{		
		private var _db:DB;
		private var testDatabaseName:String = "testDBName";
		private var testHost:String = "testhost";
		private var testPort:uint = 2;
		
		[Before]
		public function setUp():void
		{
			_db = new DB(testDatabaseName, testHost, testPort);
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
		
		
	}
}