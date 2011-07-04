package flexUnitTests.as3.mongo.wire.messages.client.opupdate
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.OpCodes;
	import as3.mongo.wire.messages.client.OpUpdate;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;

	public class OpUpdate_ConstructorTests
	{

		private var _testUpdate:Document           = new Document();
		private var _testSelector:Document         = new Document("test:value");
		private var _testFlags:int                 = 1;
		private var _testFullCollectionName:String = "aDBName.aCollectionName";
		private var _opUpdate:OpUpdate;

		[Before]
		public function setUp():void
		{
			_opUpdate = new OpUpdate(_testFullCollectionName, _testFlags, _testSelector, _testUpdate);
		}

		[After]
		public function tearDown():void
		{
			_opUpdate = null;
		}

		[Test]
		public function OpUpdate_onInstantiation_msgHeaderIsNotNull():void
		{
			assertNotNull(_opUpdate.msgHeader);
		}

		[Test]
		public function OpUpdate_onInstantiation_opCodeIsSetToOpUpdate():void
		{
			assertEquals(OpCodes.OP_UPDATE, _opUpdate.msgHeader.opCode);
		}

		[Test]
		public function OpUpdate_onInstantiation_fullCollectionNameIsSet():void
		{
			assertEquals(_testFullCollectionName, _opUpdate.fullCollectionName);
		}

		[Test]
		public function OpUpdate_onInstantiation_flagsAreSet():void
		{
			assertEquals(_testFlags, _opUpdate.flags);
		}

		[Test]
		public function OpUpdate_onInstantiation_selectorIsSet():void
		{
			assertEquals(_testSelector, _opUpdate.selector);
		}

		[Test]
		public function OpUpdate_onInstantiation_updateIsSet():void
		{
			assertEquals(_testUpdate, _opUpdate.update);
		}
	}
}
