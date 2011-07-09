package flexUnitTests.as3.mongo.wire.messages.client.opgetmore
{
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.client.OpGetMore;

	import flash.utils.ByteArray;

	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.serialization.bson.Int64;

	public class OpGetMore_toByteArrayTests
	{
		[Rule]
		public var mocks:MockolateRule             = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockMsgHeader:MsgHeader;

		private var _testCursorID:Int64;
		private var _testNumberToReturn:int        = 3;
		private var _testFullCollectionName:String = "aDbName.aCollectionName";
		private var _opGetMore:TestOpGetMore;
		private var _testByteArray:ByteArray;

		[Before]
		public function setUp():void
		{
			_assembleOpGetMoreToTestWith();
			_assembleMockMsgHeader();
		}

		private function _assembleOpGetMoreToTestWith():void
		{
			_testCursorID = new Int64(_getTestCursorIDByteArray());
			_opGetMore = new TestOpGetMore(_testFullCollectionName, _testNumberToReturn, _testCursorID);
		}

		private function _assembleMockMsgHeader():void
		{
			_testByteArray = new ByteArray();
			_testByteArray.writeInt(0);
			_testByteArray.writeInt(0);
			_testByteArray.writeInt(0);
			_testByteArray.writeInt(0);
			mock(mockMsgHeader).method("toByteArray").returns(_testByteArray);
			_opGetMore.mockMsgHeader = mockMsgHeader;
		}

		private function _getTestCursorIDByteArray():ByteArray
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeInt(0);
			byteArray.writeInt(0);
			byteArray.writeInt(0);
			byteArray.position = 0;
			return byteArray;
		}

		[After]
		public function tearDown():void
		{
			_testCursorID = null;
			_opGetMore = null;
		}

		[Test]
		public function toByteArray_allScenarios_toByteArrayInvokedOnMsgHeader():void
		{
			const ba:ByteArray = _opGetMore.toByteArray();

			assertThat(mockMsgHeader, received().method("toByteArray").noArgs().once());
		}

		[Test]
		public function toByteArray_allScenarios_byteArrayIsSameAsByteArrayFromMsgHeader():void
		{
			const ba:ByteArray = _opGetMore.toByteArray();

			assertEquals(_testByteArray, ba);
		}

		[Test]
		public function toByteArray_allScenarios_placeholderZeroIntIsWrittenAfterMsgHeader():void
		{
			const ba:ByteArray                   = _opGetMore.toByteArray();

			const zeroIntPlaceholderPosition:int = 16;
			ba.position = zeroIntPlaceholderPosition;
			assertEquals(0, ba.readInt());
		}

		[Test]
		public function toByteArray_allScenarios_fullCollectionUTFBytesAreWrittenAfterZeroPlaceholder():void
		{
			const ba:ByteArray                   = _opGetMore.toByteArray();

			const fullCollectionNamePosition:int = 20;
			ba.position = fullCollectionNamePosition;
			assertEquals(_testFullCollectionName, ba.readUTFBytes(_testFullCollectionName.length));
		}

		[Test]
		public function toByteArray_allScenarios_cStringZeroEndMarkerIsWrittenAfterFullCollectionName():void
		{
			const ba:ByteArray                     = _opGetMore.toByteArray();

			const cStringZeroEndMarkerPosition:int = 20 + _testFullCollectionName.length;
			ba.position = cStringZeroEndMarkerPosition;
			assertEquals(0, ba.readByte());
		}

		[Test]
		public function toByteArray_allScenarios_numberToReturnIsWrittenAfterCString():void
		{
			const ba:ByteArray               = _opGetMore.toByteArray();

			const numberToReturnPosition:int = 20 + _testFullCollectionName.length + 1;
			ba.position = numberToReturnPosition;
			assertEquals(_testNumberToReturn, ba.readInt());
		}

		[Test]
		public function toByteArray_allScenarios_cursorIDIsWritten():void
		{
			const ba:ByteArray         = _opGetMore.toByteArray();

			const cursorIDPosition:int = 20 + _testFullCollectionName.length + 5;
			ba.position = cursorIDPosition;

			var int64:Int64            = _getEncodedInt64(ba);
			assertTrue(Int64.cmp(_testCursorID, int64) == 0);
		}

		private function _getEncodedInt64(ba:ByteArray):Int64
		{
			const first:int            = ba.readInt();
			const second:int           = ba.readInt();

			const int64Bytes:ByteArray = new ByteArray();
			int64Bytes.writeInt(first);
			int64Bytes.writeInt(second);
			int64Bytes.position = 0;

			return new Int64(int64Bytes);
		}

		[Test]
		public function toByteArray_allScenarios_updateMessagLengthInvokedOnMsgHeader():void
		{
			const ba:ByteArray = _opGetMore.toByteArray();

			assertThat(mockMsgHeader, received().method("updateMessageLength").arg(ba).once());
		}

		[Test]
		public function toByteArray_allScenarios_returnByteArrayWithPositionAtZero():void
		{
			const ba:ByteArray = _opGetMore.toByteArray();

			assertEquals(0, ba.position);
		}
	}
}
