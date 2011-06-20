package flexUnitTests.as3.mongo.wire.messages.client.opinsert
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.client.OpInsert;

	import flash.utils.ByteArray;

	import flexunit.framework.Test;

	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.bson.BSONEncoder;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.instanceOf;

	public class OpInsert_toByteArrayTests
	{
		[Rule]
		public var mocks:MockolateRule         = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockMsgHeader:MsgHeader;

		[Mock(inject = "true", type = "nice")]
		public var mockBSONEncoder:BSONEncoder;

		private var _opInsert:TestOpInsert;
		private var _testMsgHeaderByteArray:ByteArray;
		private var _testFlags:Number          = 8;
		private var _testCollectionName:String = "aDataBaseName.aCollectionName";

		[Before]
		public function setUp():void
		{
			_opInsert = new TestOpInsert(_testFlags, _testCollectionName);

			_mockOpInsertMsgHeader();

			_mockBSONEncoder();
		}

		private function _mockBSONEncoder():void
		{
			mock(mockBSONEncoder).method("encode").args(instanceOf(Document)).returns(new ByteArray());
			_opInsert.mockBSONEncoder = mockBSONEncoder;
		}


		private function _mockOpInsertMsgHeader():void
		{
			_testMsgHeaderByteArray = new ByteArray();
			_testMsgHeaderByteArray.writeInt(0);
			_testMsgHeaderByteArray.writeInt(0);
			_testMsgHeaderByteArray.writeInt(0);
			_testMsgHeaderByteArray.writeInt(0);
			mock(mockMsgHeader).method("toByteArray").noArgs().returns(_testMsgHeaderByteArray);
			_opInsert.mockMsgHeader = mockMsgHeader;
		}

		[After]
		public function tearDown():void
		{
			_opInsert = null;
		}

		[Test]
		public function toByteArray_allScenarios_returnsByteArrayInstance():void
		{
			assertTrue(_opInsert.toByteArray() is ByteArray);
		}

		[Test]
		public function toByteArray_allScenarios_byteArrayReturnedWithPositionAtZero():void
		{
			assertEquals(0, _opInsert.toByteArray().position);
		}

		[Test]
		public function toByteArray_allScenarios_msgHeaderToByteArrayInvoked():void
		{
			_opInsert.toByteArray();

			assertThat(mockMsgHeader, received().method("toByteArray").noArgs().once());
		}

		[Test]
		public function toByteArray_allScenarios_byteArrayReturnedIsSameAsOneReturnedFromMsgHeader():void
		{
			assertEquals(_testMsgHeaderByteArray, _opInsert.toByteArray());
		}

		[Test]
		public function toByteArray_allScenarios_checkFlagsWrittenToByteArrayCorrectly():void
		{
			const opInsertByteArray:ByteArray = _opInsert.toByteArray();

			assertFlagsWrittenToByteArrayCorrectly(opInsertByteArray);
		}

		private function assertFlagsWrittenToByteArrayCorrectly(opInsertByteArray:ByteArray):void
		{
			const positionOfFlags:uint = 16;
			opInsertByteArray.position = positionOfFlags;
			assertEquals(_testFlags, opInsertByteArray.readInt());
		}

		[Test]
		public function toByteArray_allScenarios_fullCollectionNameWrittenToByteArrayCorrectly():void
		{
			const opInsertByteArray:ByteArray = _opInsert.toByteArray();

			assertFullCollectionNameWrittenToByteArrayCorrectly(opInsertByteArray);
		}

		private function assertFullCollectionNameWrittenToByteArrayCorrectly(opInsertByteArray:ByteArray):void
		{
			const positionOfFullCollectionName:uint = 20;
			opInsertByteArray.position = positionOfFullCollectionName;
			assertEquals(_testCollectionName, opInsertByteArray.readUTFBytes(_testCollectionName.length));
		}


		[Test]
		public function toByteArray_allScenarios_fullCollectionNameHasZeroAppendedToMarkEndOfCString():void
		{
			const opInsertByteArray:ByteArray = _opInsert.toByteArray();

			assertCStringEndMarkerWrittenToByteArrayCorrectly(opInsertByteArray);
		}

		private function assertCStringEndMarkerWrittenToByteArrayCorrectly(opInsertByteArray:ByteArray):void
		{
			const positionOfCStringEndMarker:uint = 20 + _testCollectionName.length;
			opInsertByteArray.position = positionOfCStringEndMarker;
			assertEquals(0, opInsertByteArray.readInt());
		}

		[Test]
		public function toByteArray_allScenarios_bsonEncoderEncodeInvokedOncePerDocument():void
		{
			_opInsert.addDocument(new Document());

			_opInsert.toByteArray();

			assertThat(mockBSONEncoder, received().method("encode").arg(instanceOf(Document)).once());
		}

		[Test]
		public function toByteArray_allScenarios_bsonEncoderEncodeInvokedTwiceOncePerEachDocument():void
		{
			_opInsert.addDocument(new Document());
			_opInsert.addDocument(new Document());

			_opInsert.toByteArray();

			assertThat(mockBSONEncoder, received().method("encode").arg(instanceOf(Document)).twice());
		}

		[Test]
		public function testByteArray_allScenarios_updateMessageLengthInvokedOnMsgHeader():void
		{
			_opInsert.toByteArray();

			assertThat(mockMsgHeader, received().method("updateMessageLength").arg(_testMsgHeaderByteArray).once());
		}
	}
}
