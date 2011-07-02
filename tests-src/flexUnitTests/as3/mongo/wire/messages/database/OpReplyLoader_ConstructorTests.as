package flexUnitTests.as3.mongo.wire.messages.database
{
	import as3.mongo.wire.messages.database.OpReplyLoader;

	import flash.net.Socket;

	import mockolate.mock;
	import mockolate.runner.MockolateRule;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;

	public class OpReplyLoader_ConstructorTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockSocket:Socket;

		private var _opReplyLoader:OpReplyLoader;

		[Before]
		public function setUp():void
		{
			mock(mockSocket).method("toString").returns("[mock Socket]");

			_opReplyLoader = new OpReplyLoader(mockSocket);
		}

		[After]
		public function tearDown():void
		{
			_opReplyLoader = null;
		}

		[Test]
		public function OpReplyLoader_onInstantiation_socketReferenceStored():void
		{
			assertEquals(mockSocket, _opReplyLoader.socket);
		}

		[Test]
		public function OpReplyLoader_onInstantiation_loadedSignalIsNotNull():void
		{
			assertNotNull(_opReplyLoader.LOADED);
		}

		[Test]
		public function OpReplyLoader_onInstantiation_isLoadedIsFalse():void
		{
			assertFalse(_opReplyLoader.isLoaded);
		}
	}
}
