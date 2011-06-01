package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.DB;
	import as3.mongo.error.MongoError;
	
	import org.flexunit.asserts.fail;

	public class DB_authenticateTests
	{		
		private var _testDBName:String = "testDBName";
		private var _testHost:String = "host";
		private var _testPort:Number = 2;
		private var _db:DB;
		
		[Before]
		public function setUp():void
		{
			_db = new DB(_testDBName, _testHost, _testPort);
		}
		
		[After]
		public function tearDown():void
		{
			_db = null;
		}

		
		[Test(expects="as3.mongo.error.MongoError")]
		public function authenticate_setCredentialsNotCalledYet_throwsMongoError():void
		{
			var error:MongoError;
			
			_db.authenticate();
		}
		
		
	}
}