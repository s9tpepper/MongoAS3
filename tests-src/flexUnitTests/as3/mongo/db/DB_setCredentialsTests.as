package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.credentials.Credentials;
	
	import org.flexunit.asserts.assertTrue;

	public class DB_setCredentialsTests
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
		
		
		[Test]
		public function setCredentials_bothArgumentsNotNullOrEmpty_hasCredentialsIsTrue():void
		{
			const credentials:Credentials = new Credentials("username", "password");
			
			_db.setCredentials(credentials);
			
			assertTrue(_db.hasCredentials);
		}
	}
}