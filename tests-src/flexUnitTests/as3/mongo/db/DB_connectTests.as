package flexUnitTests.as3.mongo.db
{
	import ab.flex.utils.flexunit.signals.AsyncSignalHandler;
	import ab.flex.utils.flexunit.signals.AsyncSignalHandlerEvent;
	
	import as3.mongo.wire.Wire;
	
	import flash.net.Socket;
	
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;

	public class DB_connectTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock(inject="false", type="nice")]
		public var wire:Wire;
		
		private var _testDBName:String = "testDBName";
		private var _testHost:String = "host";
		private var _testPort:Number = 2;
		private var _db:TestDB;
		
		[Before]
		public function setUp():void
		{
			_db = new TestDB(_testDBName, _testHost, _testPort);
			wire = nice(Wire, null, [_db]);
		}
		
		[After]
		public function tearDown():void
		{
			_db = null;
		}
		
		[Test]
		public function connect_allScenarios_connectInvokedOnWire():void
		{
			mock(wire).method("connect")
					  .noArgs();
			_db.mockWire = wire;
			
			_db.connect();
			
			assertThat(wire, received().method("connect")
									   .noArgs()
									   .once());
		}
	}
}