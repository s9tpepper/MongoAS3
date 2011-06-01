package flexUnitTests.as3.mongo.wire.messages
{
	import as3.mongo.wire.messages.MsgHeader;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;

	public class MsgHeader_ConstructorTests
	{		
		private var _msgHeader:MsgHeader;
		
		[Before]
		public function setUp():void
		{
			_msgHeader = new MsgHeader();
		}
		
		[After]
		public function tearDown():void
		{
			_msgHeader = null;
		}
		
		
		[Test]
		public function MsgHeader_onInstantiation_opCodeReturnsZero():void
		{
			assertEquals(0, _msgHeader.opCode);
		}

		[Test]
		public function MsgHeader_onInstantiation_responseToReturnsZero():void
		{
			assertEquals(0, _msgHeader.responseTo);
		}
		
		[Test]
		public function MsgHeader_onInstantiation_requestIDSet():void
		{
			assertTrue(0 < _msgHeader.requestID);
		}
		
		[Test]
		public function MsgHeader_onSubsequentInstantiation_requestIDIncreasesByOne():void
		{
			const requestID:int = _msgHeader.requestID;
			_msgHeader = new MsgHeader();
			const subsequentRequestID:int = _msgHeader.requestID;
			
			assertEquals(requestID + 1, subsequentRequestID);
		}
	}
}