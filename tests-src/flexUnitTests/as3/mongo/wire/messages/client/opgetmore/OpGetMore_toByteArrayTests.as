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
			const byteArray:ByteArray = _opGetMore.toByteArray();

			assertThat(mockMsgHeader, received().method("toByteArray").noArgs().once());
		}

		[Test]
		public function toByteArray_allScenarios_byteArrayIsSameAsByteArrayFromMsgHeader():void
		{
			const byteArray:ByteArray = _opGetMore.toByteArray();

			assertEquals(_testByteArray, byteArray);
		}

		[Test]
		public function toByteArray_allScenarios_placeholderZeroIntIsWrittenAfterMsgHeader():void
		{
			const byteArray:ByteArray = _opGetMore.toByteArray();

			_assertPlaceholderZeroWrittenCorrectly(byteArray);
		}

		private function _assertPlaceholderZeroWrittenCorrectly(byteArray:ByteArray):void
		{
			const zeroIntPlaceholderPosition:int = 16;
			byteArray.position = zeroIntPlaceholderPosition;
			assertEquals(0, byteArray.readInt());
		}


		[Test]
		public function toByteArray_allScenarios_fullCollectionUTFBytesAreWrittenAfterZeroPlaceholder():void
		{
			const byteArray:ByteArray = _opGetMore.toByteArray();

			_assertFullCollectionUTFBytesWrittenCorrectly(byteArray);
		}

		private function _assertFullCollectionUTFBytesWrittenCorrectly(byteArray:ByteArray):void
		{
			const fullCollectionNamePosition:int = 20;
			byteArray.position = fullCollectionNamePosition;
			assertEquals(_testFullCollectionName, byteArray.readUTFBytes(_testFullCollectionName.length));
		}


		[Test]
		public function toByteArray_allScenarios_cStringZeroEndMarkerIsWrittenAfterFullCollectionName():void
		{
			const byteArray:ByteArray = _opGetMore.toByteArray();

			_assertCStringZeroEndMarkerWrittenCorrectly(byteArray);
		}

		private function _assertCStringZeroEndMarkerWrittenCorrectly(byteArray:ByteArray):void
		{
			const cStringZeroEndMarkerPosition:int = 20 + _testFullCollectionName.length;
			byteArray.position = cStringZeroEndMarkerPosition;
			assertEquals(0, byteArray.readByte());
		}


		[Test]
		public function toByteArray_allScenarios_numberToReturnIsWrittenAfterCString():void
		{
			const byteArray:ByteArray = _opGetMore.toByteArray();

			_assertNumberToReturnIsWrittenCorrectly(byteArray);
		}

		private function _assertNumberToReturnIsWrittenCorrectly(byteArray:ByteArray):void
		{
			const numberToReturnPosition:int = 20 + _testFullCollectionName.length + 1;
			byteArray.position = numberToReturnPosition;
			assertEquals(_testNumberToReturn, byteArray.readInt());
		}


		[Test]
		public function toByteArray_allScenarios_cursorIDIsWritten():void
		{
			const byteArray:ByteArray = _opGetMore.toByteArray();

			_assertCursorIDIsWrittenCorrectly(byteArray);
		}

		private function _assertCursorIDIsWrittenCorrectly(byteArray:ByteArray):void
		{
			const cursorIDPosition:int = 20 + _testFullCollectionName.length + 5;
			byteArray.position = cursorIDPosition;

			var int64:Int64            = _getEncodedInt64(byteArray);
			assertTrue(Int64.cmp(_testCursorID, int64) == 0);
		}


		private function _getEncodedInt64(byteArray:ByteArray):Int64
		{
			const first:int            = byteArray.readInt();
			const second:int           = byteArray.readInt();

			const int64Bytes:ByteArray = new ByteArray();
			int64Bytes.writeInt(first);
			int64Bytes.writeInt(second);
			int64Bytes.position = 0;

			return new Int64(int64Bytes);
		}

		[Test]
		public function toByteArray_allScenarios_updateMessagLengthInvokedOnMsgHeader():void
		{
			const byteArray:ByteArray = _opGetMore.toByteArray();

			assertThat(mockMsgHeader, received().method("updateMessageLength").arg(byteArray).once());
		}

		[Test]
		public function toByteArray_allScenarios_returnByteArrayWithPositionAtZero():void
		{
			const byteArray:ByteArray = _opGetMore.toByteArray();

			assertEquals(0, byteArray.position);
		}
	}
}
