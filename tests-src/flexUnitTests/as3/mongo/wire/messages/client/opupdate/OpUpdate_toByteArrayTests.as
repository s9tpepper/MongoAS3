package flexUnitTests.as3.mongo.wire.messages.client.opupdate
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.client.OpUpdate;

	import flash.utils.ByteArray;

	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.bson.BSONEncoder;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.instanceOf;

	public class OpUpdate_toByteArrayTests
	{
		[Rule]
		public var mocks:MockolateRule             = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockMsgHeader:MsgHeader;

		[Mock(inject = "true", type = "nice")]
		public var mockBSONEncoder:BSONEncoder;

		private var _testUpdate:Document           = new Document();
		private var _testSelector:Document         = new Document("test:value");
		private var _testFlags:int                 = 1;
		private var _testFullCollectionName:String = "aDBName.aCollectionName";
		private var _opUpdate:TestOpUpdate;

		[Before]
		public function setUp():void
		{
			_opUpdate = new TestOpUpdate(_testFullCollectionName, _testFlags, _testSelector, _testUpdate);
			mock(mockBSONEncoder).method("encode").args(instanceOf(Document)).returns(new ByteArray());
			_opUpdate.bsonEncoder = mockBSONEncoder;

			const mockHeader:ByteArray = new ByteArray();
			mockHeader.writeInt(0);
			mockHeader.writeInt(0);
			mockHeader.writeInt(0);
			mockHeader.writeInt(0);
			mock(mockMsgHeader).method("toByteArray").returns(mockHeader);

			_opUpdate.mockMsgHeader = mockMsgHeader;
		}

		[After]
		public function tearDown():void
		{
			_opUpdate = null;
		}

		[Test]
		public function toByteArray_allScenarios_toByteArrayInvokedOnMsgHeader():void
		{
			_opUpdate.toByteArray();

			assertThat(mockMsgHeader, received().method("toByteArray").noArgs().once());
		}

		[Test]
		public function toByteArray_allScenarios_returnsByteArrayInstance():void
		{
			const byteArray:ByteArray = _opUpdate.toByteArray();

			assertTrue(byteArray is ByteArray);
		}

		[Test]
		public function toByteArray_allScenarios_reservedZeroWrittenAfterMsgHeader():void
		{
			const byteArray:ByteArray       = _opUpdate.toByteArray();

			const reservedZeroPosition:uint = 16;
			byteArray.position = reservedZeroPosition;
			assertEquals(0, byteArray.readInt());
		}

		[Test]
		public function toByteArray_allScenarios_fullCollectionNameWrittenCorrectly():void
		{
			const byteArray:ByteArray         = _opUpdate.toByteArray();

			const fullCollectionPosition:uint = 20;
			byteArray.position = fullCollectionPosition;
			assertEquals(_testFullCollectionName, byteArray.readUTFBytes(_testFullCollectionName.length));
		}

		[Test]
		public function toByteArray_allScenarios_cStringZeroEndMarkerIsWrittenCorrectly():void
		{
			const byteArray:ByteArray               = _opUpdate.toByteArray();

			const cStringZeroEndMarkerPosition:uint = 20 + _testFullCollectionName.length;
			byteArray.position = cStringZeroEndMarkerPosition;
			assertEquals(0, byteArray.readByte());
		}

		[Test]
		public function toByteArray_allScenarios_flagsIsWrittenCorrectly():void
		{
			const byteArray:ByteArray = _opUpdate.toByteArray();

			const flagsPosition:uint  = 20 + _testFullCollectionName.length + 1;
			byteArray.position = flagsPosition;
			assertEquals(_testFlags, byteArray.readInt());
		}

		[Test]
		public function toByteArray_allScenarios_encodeInvokedTwiceOncePerDocumentForSelectorAndUpdate():void
		{
			const byteArray:ByteArray = _opUpdate.toByteArray();

			assertThat(mockBSONEncoder, received().method("encode").arg(instanceOf(Document)).twice());
		}

		[Test]
		public function toByteArray_allScenarios_updateMessageLengthInvokedOnMsgHeader():void
		{
			const byteArray:ByteArray = _opUpdate.toByteArray();

			assertThat(mockMsgHeader, received().method("updateMessageLength").arg(byteArray).once());
		}

		[Test]
		public function toByteArray_allScenarios_byteArrayReturnedWithPositionZero():void
		{
			const byteArray:ByteArray = _opUpdate.toByteArray();

			assertEquals(0, byteArray.position);
		}
	}
}
