package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.DB;
	import as3.mongo.wire.Wire;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	public class DB_ConstructorTests
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
		
		[Test]
		public function DB_onInstantiation_hasWireCreated():void
		{
			assertTrue(_db.wire is Wire);
		}
		
		[Test]
		public function DB_onInstantiation_nameReturnsCorrectValue():void
		{
			assertEquals(_testDBName, _db.name);
		}
		
		[Test]
		public function DB_onInstantiation_isConnectedIsFalse():void
		{
			assertFalse(_db.isConnected);
		}
		
		[Test]
		public function DB_onInstantiation_isAuthenticatedIsFalse():void
		{
			assertFalse(_db.isAuthenticated);
		}
		
		[Test]
		public function DB_onInstantiation_hasCredentialsIsFalse():void
		{
			assertFalse(_db.hasCredentials);
		}
		
		[Test]
		public function DB_onInstantiation_hostReturnsCorrectValue():void
		{
			assertEquals(_testHost, _db.host);
		}
		
		[Test]
		public function DB_onInstantiation_portReturnsCorrectValue():void
		{
			assertEquals(_testPort, _db.port);
		}
	}
}