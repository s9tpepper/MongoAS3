package flexUnitTests.as3.mongo.wire
{
	import as3.mongo.wire.Messenger;
	import as3.mongo.wire.Wire;

	import mockolate.runner.MockolateRule;

	import org.flexunit.asserts.assertEquals;

	public class MessengerTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockWire:Wire;


		private var _messenger:Messenger;

		[Before]
		public function setUp():void
		{
			_messenger = new Messenger(mockWire);
		}

		[After]
		public function tearDown():void
		{
			_messenger = null;
		}

		[Test]
		public function Messenger_onInstantiation_wireIsStored():void
		{
			assertEquals(mockWire, _messenger.wire);
		}
	}
}
