package flexUnitTests.as3.mongo.wire.messages
{
	import as3.mongo.wire.messages.OpCodes;
	import as3.mongo.error.MongoError;
	import as3.mongo.wire.messages.MsgHeader;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;

	[RunWith("org.flexunit.runners.Parameterized")]
	public class MsgHeader_setOpCodeTests
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
		
		public static var validOpCodes:Array = [
		  [OpCodes.OP_DELETE],
		  [OpCodes.OP_GET_MORE],
	  	  [OpCodes.OP_INSERT],
		  [OpCodes.OP_KILL_CURSORS],
		  [OpCodes.OP_MSG],
		  [OpCodes.OP_QUERY],
		  [OpCodes.OP_REPLY],
		  [OpCodes.OP_UPDATE],
		  [OpCodes.RESERVED]
	     ];
		
		public static var invalidOpCodes:Array = [[_generateRandomInvalidCode()],
			[_generateRandomInvalidCode()],
			[_generateRandomInvalidCode()],
			[_generateRandomInvalidCode()],
			[_generateRandomInvalidCode()],
			[_generateRandomInvalidCode()],
			[_generateRandomInvalidCode()],
			[_generateRandomInvalidCode()],
			[_generateRandomInvalidCode()]
	   ];
		
		private static function _generateRandomInvalidCode():int
		{
			var invalidCode:int = Math.floor(Math.random() * 9999);
			while (-1 != validOpCodes.lastIndexOf(invalidCode))
			{
				invalidCode = Math.floor(Math.random() * 9999);
			}
			
			return invalidCode;
		}
		
		[Test(dataProvider="validOpCodes")]
		public function setOpCode_validOpCode_opCodeReturnsCorrectValue(opCode:int):void
		{
			_msgHeader.opCode = opCode;
			
			assertEquals(opCode, _msgHeader.opCode);
		}
		
		[Test(dataProvider="invalidOpCodes", expects="as3.mongo.error.MongoError")]
		public function setOpCode_invalidOpCode_throwsMongoError(invalidOpCode:int):void
		{
			var error:MongoError;
			
			_msgHeader.opCode = invalidOpCode;
		}
	}
}