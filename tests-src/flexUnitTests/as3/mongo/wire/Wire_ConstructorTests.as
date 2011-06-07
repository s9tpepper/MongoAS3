package flexUnitTests.as3.mongo.wire
{
	import as3.mongo.db.DB;
	import as3.mongo.wire.Wire;
	
	import org.flexunit.asserts.assertNotNull;

	public class Wire_ConstructorTests
	{		
		private var _wire:Wire;
		
		[Before]
		public function setUp():void
		{
			_wire = new Wire(new DB("db", "host", 27017));
		}
		
		[After]
		public function tearDown():void
		{
			_wire = null;
		}
		
		[Test]
		public function Wire_onInstantiation_hasASocketInstance():void
		{
			assertNotNull(_wire.socket);
		}
		
		[Test]
		public function Wire_onInstantiation_hasMessageFactory():void
		{
			assertNotNull(_wire.messageFactory);
		}
	}
}