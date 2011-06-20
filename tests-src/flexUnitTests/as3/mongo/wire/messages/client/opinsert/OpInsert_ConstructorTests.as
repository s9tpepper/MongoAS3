package flexUnitTests.as3.mongo.wire.messages.client.opinsert
{
	import as3.mongo.wire.messages.OpCodes;
	import as3.mongo.wire.messages.client.OpInsert;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;

	public class OpInsert_ConstructorTests
	{

		private var _opInsert:OpInsert;
		private var _testFlags:Number          = 8;
		private var _testCollectionName:String = "dbname.collectionname";

		[Before]
		public function setUp():void
		{
			_opInsert = new OpInsert(_testFlags, _testCollectionName);
		}

		[After]
		public function tearDown():void
		{
			_opInsert = null;
		}

		[Test]
		public function OpInsert_onInstantiation_flagsReturnedCorrectly():void
		{
			assertEquals(_testFlags, _opInsert.flags);
		}

		[Test]
		public function OpInsert_onInstantiation_collectionNameReturnedCorrectly():void
		{
			assertEquals(_testCollectionName, _opInsert.collectionName);
		}

		[Test]
		public function OpInsert_onInstantiation_msgHeaderIsNotNull():void
		{
			assertNotNull(_opInsert.msgHeader);
		}

		[Test]
		public function OpInsert_onInstantiation_msgHeaderOpCodeIsOpInsertCode():void
		{
			assertEquals(OpCodes.OP_INSERT, _opInsert.msgHeader.opCode);
		}

		[Test]
		public function OpInsert_onInstantiation_totalDocumentsIsZero():void
		{
			assertEquals(0, _opInsert.totalDocuments);
		}
	}
}
