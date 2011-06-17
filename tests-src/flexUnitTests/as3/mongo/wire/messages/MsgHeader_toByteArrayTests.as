package flexUnitTests.as3.mongo.wire.messages
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.OpCodes;
	import org.flexunit.asserts.assertEquals;

	public class MsgHeader_toByteArrayTests
	{
		private static const _MESSAGE_HEADER_LENGTH:Number = 16;
		private var _msgHeader:MsgHeader;
		private var testOpCode:int                         = OpCodes.OP_QUERY;
		private var testRequestID:int                      = 31894;
		private var testResponseTo:int                     = 13442;

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
		public function toByteArray_allScenarios_byteArrayReturnedIsLittleEndian():void
		{
			const byteArray:ByteArray = _msgHeader.toByteArray();

			assertEquals(Endian.LITTLE_ENDIAN, byteArray.endian);

		}


		[Test]
		public function toByteArray_allScenarios_byteArrayReturnedWithPositionIsAtEndReadyToBeAppendedTo():void
		{
			const byteArray:ByteArray = _msgHeader.toByteArray();

			assertEquals(_MESSAGE_HEADER_LENGTH, byteArray.position);

		}

		[Test]
		public function toByteArray_allScenarios_messageLengthWrittenCorrectlyToByteArray():void
		{
			const byteArray:ByteArray                   = _msgHeader.toByteArray();

			const messageLengthByteArrayPosition:Number = 0;
			byteArray.position = messageLengthByteArrayPosition;
			assertEquals(_MESSAGE_HEADER_LENGTH, byteArray.readInt());
		}

		[Test]
		public function toByteArray_allScenarios_opCodeWrittenCorrectlyToByteArray():void
		{
			_msgHeader.opCode = testOpCode;
			const byteArray:ByteArray          = _msgHeader.toByteArray();

			const opCodeByteArrayPosition:uint = 12;
			byteArray.position = opCodeByteArrayPosition;

			assertEquals(testOpCode, byteArray.readInt());

		}

		[Test]
		public function toByteArray_allScenarios_requestIDWrittenCorrectlyToByteArray():void
		{
			_msgHeader.requestID = testRequestID;
			const byteArray:ByteArray             = _msgHeader.toByteArray();

			const requestIDByteArrayPosition:uint = 4;
			byteArray.position = requestIDByteArrayPosition;

			assertEquals(testRequestID, byteArray.readInt());

		}

		[Test]
		public function toByteArray_allScenarios_responseToWrittenCorrectlyToByteArray():void
		{
			_msgHeader.responseTo = testResponseTo;
			const byteArray:ByteArray              = _msgHeader.toByteArray();

			const responseToByteArrayPosition:uint = 8;
			byteArray.position = responseToByteArrayPosition;

			assertEquals(testResponseTo, byteArray.readInt());

		}
	}
}
