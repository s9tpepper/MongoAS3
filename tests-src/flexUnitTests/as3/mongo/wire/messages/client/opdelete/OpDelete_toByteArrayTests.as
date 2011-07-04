package flexUnitTests.as3.mongo.wire.messages.client.opdelete
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.client.OpDelete;

	import flash.utils.ByteArray;

	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.bson.BSONEncoder;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.fail;
	import org.hamcrest.object.instanceOf;

	public class OpDelete_toByteArrayTests
	{
		[Rule]
		public var mocks:MockolateRule               = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockMsgHeader:MsgHeader;

		[Mock(inject = "true", type = "nice")]
		public var mockBsonEncoder:BSONEncoder;

		private const _testFullCollectionName:String = "aDB.aCollection";
		private const _testSelector:Document         = new Document();

		private var _opDelete:TestOpDelete;
		private var _testBytes:ByteArray             = new ByteArray();

		[Before]
		public function setUp():void
		{
			_opDelete = new TestOpDelete(_testFullCollectionName, _testSelector);

			_testBytes.writeInt(0);
			_testBytes.writeInt(0);
			_testBytes.writeInt(0);
			_testBytes.writeInt(0);
			mock(mockMsgHeader).method("toByteArray").noArgs().returns(_testBytes);
			_opDelete.mockMsgHeader = mockMsgHeader;
			_opDelete.bsonEncoder = mockBsonEncoder;

			mock(mockBsonEncoder).method("encode").args(instanceOf(Document)).returns(new ByteArray());
		}

		[After]
		public function tearDown():void
		{
			_opDelete = null;
		}

		[Test]
		public function toByteArray_allScenarios_toByteArrayInvokedOnMsgHeader():void
		{
			_opDelete.toByteArray();

			assertThat(mockMsgHeader, received().method("toByteArray").noArgs().once());
		}

		[Test]
		public function toByteArray_allScenarios_byteArrayReturnedIsFromMsgHeader():void
		{
			const byteArray:ByteArray = _opDelete.toByteArray();

			assertEquals(_testBytes, byteArray);
		}

		[Test]
		public function toByteArray_allScenarios_zeroIntWrittenAfterMsgHeader():void
		{
			const byteArray:ByteArray       = _opDelete.toByteArray();

			const reservedZeroPosition:uint = 16;
			byteArray.position = reservedZeroPosition;
			assertEquals(0, byteArray.readInt());
		}

		[Test]
		public function toByteArray_allScenarios_fullCollectionNameUTFBytesWritten():void
		{
			const byteArray:ByteArray         = _opDelete.toByteArray();

			const fullCollectionPosition:uint = 20;
			byteArray.position = fullCollectionPosition;

			assertEquals(_testFullCollectionName, byteArray.readUTFBytes(_testFullCollectionName.length));
		}

		[Test]
		public function toByteArray_allScenarios_CStringZeroEndMarkerWrittenAfterFullCollectionName():void
		{
			const byteArray:ByteArray       = _opDelete.toByteArray();

			const cStringZeroEndMarker:uint = 20 + _testFullCollectionName.length;
			byteArray.position = cStringZeroEndMarker;

			assertEquals(0, byteArray.readByte());
		}

		[Test]
		public function toByteArray_allScenarios_flagsWrittenAfterCStringEnd():void
		{
			const byteArray:ByteArray = _opDelete.toByteArray();

			const flagsPosition:uint  = 20 + _testFullCollectionName.length + 1;
			byteArray.position = flagsPosition;

			assertEquals(0, byteArray.readInt());
		}

		[Test]
		public function toByteArray_allScenarios_encodeInvokedOnceOnBSONEncoder():void
		{
			const byteArray:ByteArray = _opDelete.toByteArray();

			assertThat(mockBsonEncoder, received().method("encode").arg(instanceOf(Document)).once());
		}

		[Test]
		public function testByteArray_allScenarios_updateMessageLengthInvokedOnMsgHeader():void
		{
			const byteArray:ByteArray = _opDelete.toByteArray();

			assertThat(mockMsgHeader, received().method("updateMessageLength").arg(byteArray).once());
		}

		[Test]
		public function testByteArray_allScenarios_byteArrayReturnedAtPositionZero():void
		{
			const byteArray:ByteArray = _opDelete.toByteArray();

			assertEquals(0, byteArray.position);
		}
	}
}
