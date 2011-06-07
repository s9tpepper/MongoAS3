package flexUnitTests.as3.mongo.wire
{
	import as3.mongo.db.DB;
	import as3.mongo.wire.Wire;
	
	import flash.net.Socket;
	
	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	
	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;

	public class Wire_getNonceTests
	{	
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock(inject="true", type="nice")]
		public var mockedDB:DB;
		
		[Mock(inject="true", type="nice")]
		public var mockedSocket:Socket;
		
		
		private var _wire:TestWire;
		
		[Before]
		public function setUp():void
		{
			_wire = new TestWire(mockedDB);
		}
		
		[After]
		public function tearDown():void
		{
			_wire = null;
		}
		
		[Test]
		public function getNonce_allScenarios_socketWriteBytesInvoked():void
		{
			mock(mockedDB).method("findOne").args("$cmd", Wire.NONCE_QUERY, null, instanceOf(Function));
			
			_wire.getNonce();
			
			assertThat(mockedDB, received().method("findOne")
										   .args("$cmd", Wire.NONCE_QUERY, null, instanceOf(Function))
										   .once());
		}
		
		
	}
}