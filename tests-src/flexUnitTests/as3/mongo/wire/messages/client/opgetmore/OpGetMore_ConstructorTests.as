package flexUnitTests.as3.mongo.wire.messages.client.opgetmore
{
	import as3.mongo.wire.messages.OpCodes;
	import as3.mongo.wire.messages.client.OpGetMore;

	import flash.utils.ByteArray;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.serialization.bson.Int64;

	public class OpGetMore_ConstructorTests
	{
		private var _testCursorID:Int64;
		private var _testNumberToReturn:int        = 3;
		private var _testFullCollectionName:String = "aDbName.aCollectionName";
		private var _opGetMore:OpGetMore;

		[Before]
		public function setUp():void
		{
			_testCursorID = new Int64(_getTestCursorIDByteArray());
			_opGetMore = new OpGetMore(_testFullCollectionName, _testNumberToReturn, _testCursorID);
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
		public function OpGetMore_onInstantiation_msgHeaderIsNotNull():void
		{
			assertNotNull(_opGetMore.msgHeader);
		}

		[Test]
		public function OpGetMore_onInstantiation_msgHeaderOpCodeSetToOpGetMore():void
		{
			assertEquals(OpCodes.OP_GET_MORE, _opGetMore.msgHeader.opCode);
		}

		[Test]
		public function OpGetMore_onInstantiation_fullCollectionNameIsSet():void
		{
			assertEquals(_testFullCollectionName, _opGetMore.fullCollectionName);
		}

		[Test]
		public function OpGetMore_onInstantiation_numberToReturnIsSet():void
		{
			assertEquals(_testNumberToReturn, _opGetMore.numberToReturn);
		}

		[Test]
		public function OpGetMore_onInstantiation_cursorIDIsSet():void
		{
			assertEquals(_testCursorID, _opGetMore.cursorID);
		}
	}
}
