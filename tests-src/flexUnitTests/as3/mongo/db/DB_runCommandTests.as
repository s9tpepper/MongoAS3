package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.DB;
	
	import org.flexunit.asserts.fail;

	public class DB_runCommandTests
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
		
		[Ignore]
		[Test]
		public function runCommand_scenario_expectedBehavior():void
		{
			fail("Fail: runCommand_scenario_expectedBehavior not implemented.");
		}
	}
}