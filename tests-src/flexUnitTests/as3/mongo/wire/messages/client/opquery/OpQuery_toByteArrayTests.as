package flexUnitTests.as3.mongo.wire.messages.client.opquery
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.MsgHeader;

	import flash.utils.ByteArray;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.bson.BSONEncoder;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.strictlyEqualTo;

	public class OpQuery_toByteArrayTests
	{
		public static const HEADER_LENGTH:Number    = 16;
		public static const INT_BYTES_LENGTH:Number = 4;
		public static const BYTE_LENGTH:Number      = 1;

		[Rule]
		public var mocks:MockolateRule              = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockMsgHeader:MsgHeader;

		[Mock(inject = "true", type = "nice")]
		public var mockBsonEncoder:BSONEncoder;

		[Mock(inject = "false", type = "nice")]
		public var mockByteArray:ByteArray;

		private var testReturnFieldSelector:Document;
		private var testQuery:Document;
		private var testNumberToReturn:int;
		private var testNumberToSkip:int;
		private var testFullCollectionName:String;
		private var testFlags:int;
		private var _opQuery:TestOpQuery;
		private var encodedQueryDocument:ByteArray;
		private var encodedReturnFieldSelectorDocument:ByteArray;


		private function _prepareMocks():ByteArray
		{
			var testByteArray:ByteArray = _prepareMockMsgHeader();

			_prepareMockBsonEncoder();

			return testByteArray;
		}

		private function _prepareMockBsonEncoder():void
		{
			encodedQueryDocument = new ByteArray();
			mock(mockBsonEncoder).method("encode").args(testQuery).returns(encodedQueryDocument);

			encodedReturnFieldSelectorDocument = new ByteArray();
			encodedReturnFieldSelectorDocument.writeInt(3);
			mock(mockBsonEncoder).method("encode").args(testReturnFieldSelector).returns(encodedReturnFieldSelectorDocument);

			_opQuery.bsonEncoder = mockBsonEncoder;
		}

		private function _prepareMockMsgHeader():ByteArray
		{
			const testByteArray:ByteArray = new ByteArray();
			testByteArray.writeInt(0);
			testByteArray.writeInt(0);
			testByteArray.writeInt(0);
			testByteArray.writeInt(0);
			mock(mockMsgHeader).method("toByteArray").noArgs().returns(testByteArray);
			_opQuery.msgHeader = mockMsgHeader;
			return testByteArray;
		}


		[Before]
		public function setUp():void
		{
			testFlags = 6;
			testFullCollectionName = "aDataBaseName.aCollectionName";
			testNumberToSkip = 10;
			testNumberToReturn = -1;
			testQuery = new Document("field:value");
			testReturnFieldSelector = new Document("returnField:value");

			_opQuery = new TestOpQuery(testFlags, testFullCollectionName, testNumberToSkip, testNumberToReturn, testQuery, testReturnFieldSelector);
		}

		[After]
		public function tearDown():void
		{
			_opQuery = null;
		}

		[Test]
		public function toByteArray_allScenarios_returnsByteArrayWithPositionAtZero():void
		{
			_prepareMocks();

			const byteArray:ByteArray = _opQuery.toByteArray();

			assertEquals(0, byteArray.position);
		}


		[Test]
		public function toByteArray_allScenarios_msgHeaderToByteArrayInvoked():void
		{
			_prepareMocks();

			_opQuery.toByteArray();

			assertThat(mockMsgHeader, received().method("toByteArray").noArgs().once());
		}

		[Test]
		public function toByteArray_allScenarios_byteArrayReturnedIsSameAsOneCreatedByMsgHeader():void
		{
			const testByteArray:ByteArray = _prepareMocks();

			const byteArray:ByteArray     = _opQuery.toByteArray();

			assertEquals(testByteArray, byteArray);
		}


		[Test]
		public function toByteArray_allScenarios_flagsAreWrittenCorrectlyToByteArray():void
		{
			_prepareMocks();

			const byteArray:ByteArray = _opQuery.toByteArray();

			_setFlagsByteArrayPosition(byteArray);
			assertEquals(testFlags, byteArray.readInt());
		}

		private function _setFlagsByteArrayPosition(byteArray:ByteArray):void
		{
			const flagsPosition:uint = HEADER_LENGTH;
			byteArray.position = flagsPosition;
		}



		[Test]
		public function toByteArray_allScenarios_fullCollectionNameWrittenCorrectlyToByteArray():void
		{
			_prepareMocks();

			const byteArray:ByteArray = _opQuery.toByteArray();

			_setFullCollectionNameByteArrayPosition(byteArray);
			assertEquals(testFullCollectionName, byteArray.readUTFBytes(_opQuery.fullCollectionName.length));
		}

		private function _setFullCollectionNameByteArrayPosition(byteArray:ByteArray):void
		{
			_setFlagsByteArrayPosition(byteArray);
			byteArray.position += INT_BYTES_LENGTH;
		}


		[Test]
		public function toByteArray_allScenarios_fullCollectionNameWriteHasZeroToMarkEndOfCString():void
		{
			_prepareMocks();

			const byteArray:ByteArray = _opQuery.toByteArray();

			_setCStringEndMarkerByteArrayPosition(byteArray);
			assertEquals(0, byteArray.readByte());
		}

		private function _setCStringEndMarkerByteArrayPosition(byteArray:ByteArray):void
		{
			_setFullCollectionNameByteArrayPosition(byteArray);
			byteArray.position += _opQuery.fullCollectionName.length;
		}


		[Test]
		public function toByteArray_allScenarios_numberToSkipWrittenCorrectly():void
		{
			_prepareMocks();

			const byteArray:ByteArray = _opQuery.toByteArray();

			_setNumberToSkipByteArrayPosition(byteArray);
			assertEquals(testNumberToSkip, byteArray.readInt());
		}

		private function _setNumberToSkipByteArrayPosition(byteArray:ByteArray):void
		{
			_setCStringEndMarkerByteArrayPosition(byteArray);
			byteArray.position += BYTE_LENGTH;
		}


		[Test]
		public function toByteArray_allScenarios_numberToReturnWrittenCorrectly():void
		{
			_prepareMocks();

			const byteArray:ByteArray = _opQuery.toByteArray();

			_setNumberToReturnByteArrayPosition(byteArray);
			assertEquals(testNumberToReturn, byteArray.readInt());
		}

		private function _setNumberToReturnByteArrayPosition(byteArray:ByteArray):void
		{
			_setNumberToSkipByteArrayPosition(byteArray);
			byteArray.position += INT_BYTES_LENGTH;
		}


		[Test]
		public function toByteArray_allScenarios_invokesEncodeOnBSONEncoderWithTestQuery():void
		{
			_prepareMocks();
			mock(mockBsonEncoder).method("encode").args(testQuery);

			_opQuery.toByteArray();

			assertThat(mockBsonEncoder, received().method("encode").arg(testQuery));
		}

		[Test]
		public function toByteArray_allScenarios_invokesWriteBytesWithByteArrayReturnedFromBSONEncoder():void
		{
			_mockByteArrayToCheckWriteBytesCall();
			_prepareMocks();

			_opQuery.toByteArray();

			assertThat(mockByteArray, received().method("writeBytes").arg(encodedQueryDocument));
		}

		private function _mockByteArrayToCheckWriteBytesCall():void
		{
			mockByteArray = nice(ByteArray);
			mock(mockByteArray).method("writeBytes").args(encodedQueryDocument);
			mock(mockMsgHeader).method("toByteArray").noArgs().returns(mockByteArray);
		}



		[Test]
		public function toByteArray_allScenarios_invokesEncodeOnBSONEncoderWithTestReturnFieldSelectorDocument():void
		{
			_prepareMocks();
			mock(mockBsonEncoder).method("encode").args(testReturnFieldSelector);

			_opQuery.toByteArray();

			assertThat(mockBsonEncoder, received().method("encode").arg(testReturnFieldSelector));
		}


		[Test]
		public function toByteArray_returnFieldSelectorDocumentIsSet_invokesWriteBytesWithByteArrayReturnedFromBSONEncoder():void
		{
			_mockByteArrayToCheckWriteBytesCallWithReturnFieldSelectorDocument();
			_prepareMocks();

			_opQuery.toByteArray();

			assertThat(mockByteArray, received().method("writeBytes").arg(encodedReturnFieldSelectorDocument));
		}

		private function _mockByteArrayToCheckWriteBytesCallWithReturnFieldSelectorDocument():void
		{
			mockByteArray = nice(ByteArray);
			mock(mockByteArray).method("writeBytes").args(encodedReturnFieldSelectorDocument);
			mock(mockMsgHeader).method("toByteArray").noArgs().returns(mockByteArray);
		}

		[Test]
		public function toByteArray_returnFieldSelectorDocumentIsNull_invokesWriteBytesOnlyInvokedOnce():void
		{
			_mockByteArrayToCheckWriteBytesCallWithNullReturnFieldSelectorDocument();
			_prepareMocks();
			_opQuery.returnFieldSelector = null;

			_opQuery.toByteArray();

			assertThat(mockByteArray, received().method("writeBytes").arg(instanceOf(ByteArray)).once());
		}

		private function _mockByteArrayToCheckWriteBytesCallWithNullReturnFieldSelectorDocument():void
		{
			mockByteArray = nice(ByteArray);
			mock(mockByteArray).method("writeBytes").args(instanceOf(ByteArray));
			mock(mockMsgHeader).method("toByteArray").noArgs().returns(mockByteArray);
		}

		[Test]
		public function testByteArray_allScenarios_updateMessageLengthInvokedOnMsgHeader():void
		{
			mock(mockMsgHeader).method("updateMessageLength").args(instanceOf(ByteArray));
			_prepareMocks();

			_opQuery.toByteArray();

			assertThat(mockMsgHeader, received().method("updateMessageLength").arg(instanceOf(ByteArray)).once());
		}
	}
}
