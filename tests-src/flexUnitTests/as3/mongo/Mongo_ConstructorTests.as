package flexUnitTests.as3.mongo
{
	import as3.mongo.Mongo;
	
	import org.flexunit.asserts.assertEquals;

	public class Mongo_ConstructorTests
	{		
		private static const _HOST:String = "host";
		private static const _MONGO_PORT:Number = 999;
		
		private var _mongo:Mongo;
		
		
		[Before]
		public function setUp():void
		{
			_mongo = new Mongo(_HOST, _MONGO_PORT);
		}
		
		[After]
		public function tearDown():void
		{
			_mongo = null;
		}
		
		
		[Test]
		public function Mongo_onInstantiation_hostReturnsCorrectValue():void
		{
			assertEquals(_HOST, _mongo.host);
		}
		
		[Test]
		public function Mongo_onInstantiation_portReturnsCorrectValue():void
		{
			assertEquals(_MONGO_PORT, _mongo.port);
		}
		
		[Test]
		public function Mongo_onInstantiation_defaultPortIs27017():void
		{
			_mongo = new Mongo("");
			
			const defaultMongoPort:Number = 27017;
			assertEquals(defaultMongoPort, _mongo.port);
		}
	}
}