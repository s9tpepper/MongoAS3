package flexUnitTests.as3.mongo.wire.messages
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.MessageFactory;
	import as3.mongo.wire.messages.client.OpUpdate;
	import as3.mongo.wire.messages.client.OpUpdateFlags;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	public class MessageFactory_makeUpsertOpUpdateMessageTests
	{

		private var _messageFactory:MessageFactory;
		private var _testDocument:Document         = new Document("document:newValue");
		private var _testSelector:Document         = new Document("selector:value");
		private var _testCollectionName:String     = "aCollectionName";
		private var _testDBName:String             = "aDBName";
		private var _testFullCollectionName:String = "aDBName.aCollectionName";
		private var _opUpdate:OpUpdate;

		[Before]
		public function setUp():void
		{
			_messageFactory = new MessageFactory();
			_opUpdate = _messageFactory.makeUpsertOpUpdateMessage(_testDBName, _testCollectionName, _testSelector, _testDocument);
		}

		[After]
		public function tearDown():void
		{
			_messageFactory = null;
			_opUpdate = null;
		}

		[Test]
		public function makeUpsertOpUpdateMessage_validInputs_returnsOpUpdateInstance():void
		{
			assertTrue(_opUpdate is OpUpdate);
		}

		[Test]
		public function makeUpsertOpUpdateMessage_validInputs_fullCollectionNameIsCorrect():void
		{
			assertEquals(_testFullCollectionName, _opUpdate.fullCollectionName);
		}

		[Test]
		public function makeUpsertOpUpdateMessage_validInputs_flagsIsSetToUpsert():void
		{
			assertEquals(OpUpdateFlags.UPSERT, _opUpdate.flags);
		}

		[Test]
		public function makeUpserOpUpdateMessage_validInputs_selectorIsSet():void
		{
			assertEquals(_testSelector, _opUpdate.selector);
		}

		[Test]
		public function makeUpserOpUpdateMessage_validInputs_documentIsSet():void
		{
			assertEquals(_testDocument, _opUpdate.update);
		}
	}
}
