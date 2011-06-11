package flexUnitTests.as3.mongo.wire.messages.database
{
	import as3.mongo.wire.messages.OpCodes;
	import as3.mongo.wire.messages.database.OpReply;
	
	import flash.net.Socket;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import mockolate.runner.MockolateRule;

	public class OpReply_ConstructorTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock(inject="true", type="nice")]
		public var mockSocket:Socket;
		
		private var _opReply:OpReply;
		private var testMessageLength:int = 81;
		
		[Before]
		public function setUp():void
		{
			_opReply = new OpReply(testMessageLength, mockSocket);
		}
		
		[After]
		public function tearDown():void
		{
			_opReply = null;
		}
		
		
		[Test]
		public function OpReply_onInstantiation_msgHeaderIsNotNull():void
		{
			assertNotNull(_opReply.msgHeader);
		}
		
		[Test]
		public function OpReply_onInstantiation_msgHeaderOpCodeIsOpReplyCode():void
		{
			assertEquals(OpCodes.OP_REPLY, _opReply.msgHeader.opCode);
		}
		
		[Test]
		public function OpReply_onInstantiation_messageLengthIsSet():void
		{
			assertEquals(testMessageLength, _opReply.messageLength);
		}

		[Test]
		public function OpReply_onInstantiation_bufferSocketIsSet():void
		{
			assertNotNull(_opReply.socket);
		}
	}
}