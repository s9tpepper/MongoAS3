package flexUnitTests.as3.mongo.wire.messages
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.MessageFactory;
	import as3.mongo.wire.messages.client.OpUpdate;
	import as3.mongo.wire.messages.client.OpUpdateFlags;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	public class MessageFactory_makeUpdateFirstOpUpdateMessageTests
	{

		private var _messageFactory:MessageFactory;
		private var _testDBName:String             = "aDB";
		private var _testCollectionName:String     = "aCollection";
		private var _testFullCollectionName:String = "aDB.aCollection";
		private var _testSelector:Document         = new Document();
		private var _testUpdate:Document           = new Document();
		private var _opUpdate:OpUpdate;

		[Before]
		public function setUp():void
		{
			_messageFactory = new MessageFactory();
			_opUpdate = _messageFactory.makeUpdateFirstOpUpdateMessage(_testDBName, _testCollectionName, _testSelector, _testUpdate);
		}

		[After]
		public function tearDown():void
		{
			_messageFactory = null;
		}

		[Test]
		public function makeUpdateFirstOpUpdateMessage_validInputs_OpUpdateInstanceReturned():void
		{
			assertTrue(_opUpdate is OpUpdate);
		}

		[Test]
		public function makeUpdateFirstOpUpdateMessage_validInputs_flagsIsSetToNoFlags():void
		{
			assertEquals(OpUpdateFlags.NO_FLAGS, _opUpdate.flags);
		}

		[Test]
		public function makeUpdateFirstOpUpdateMessage_validInputs_fullCollectionNameIsSet():void
		{
			assertEquals(_testFullCollectionName, _opUpdate.fullCollectionName);
		}

		[Test]
		public function makeUpdateFirstOpUpdateMessage_validInputs_selectorIsSet():void
		{
			assertEquals(_testSelector, _opUpdate.selector);
		}

		[Test]
		public function makeUpdateFirstOpUpdateMessage_validInputs_updateIsSet():void
		{
			assertEquals(_testUpdate, _opUpdate.update);
		}
	}
}
