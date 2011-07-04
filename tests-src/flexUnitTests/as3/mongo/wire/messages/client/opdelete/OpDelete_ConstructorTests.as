package flexUnitTests.as3.mongo.wire.messages.client.opdelete
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.OpCodes;
	import as3.mongo.wire.messages.client.OpDelete;

	import flexunit.framework.Test;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;

	public class OpDelete_ConstructorTests
	{
		private const _testFullCollectionName:String = "aDB.aCollection";
		private const _testSelector:Document         = new Document();

		private var _opDelete:OpDelete;

		[Before]
		public function setUp():void
		{
			_opDelete = new OpDelete(_testFullCollectionName, _testSelector);
		}

		[After]
		public function tearDown():void
		{
			_opDelete = null;
		}

		[Test]
		public function OpDelete_onInstantiation_fullCollectionNameIsStored():void
		{
			assertEquals(_testFullCollectionName, _opDelete.fullCollectionName);
		}

		[Test]
		public function OpDelete_onInstantiation_selectorIsStored():void
		{
			assertEquals(_testSelector, _opDelete.selector);
		}

		[Test]
		public function OpDelete_onInstantiation_flagsIsZero():void
		{
			assertEquals(0, _opDelete.flags);
		}

		[Test]
		public function OpDelete_onInstantiation_msgHeaderIsNotNull():void
		{
			assertNotNull(_opDelete.msgHeader);
		}

		[Test]
		public function OpDelete_onInstantiation_opCodeIsOpDelete():void
		{
			assertEquals(OpCodes.OP_DELETE, _opDelete.msgHeader.opCode);
		}

		[Test]
		public function OpDelete_onInstantiation_bsonEncoderIsNotNull():void
		{
			assertNotNull(_opDelete.bsonEncoder);
		}
	}
}
