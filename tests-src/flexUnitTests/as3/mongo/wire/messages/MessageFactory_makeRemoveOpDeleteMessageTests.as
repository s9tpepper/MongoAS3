package flexUnitTests.as3.mongo.wire.messages
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.MessageFactory;
	import as3.mongo.wire.messages.client.OpDelete;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	public class MessageFactory_makeRemoveOpDeleteMessageTests
	{

		private var _messageFactory:MessageFactory;
		private var _opDelete:OpDelete;
		private var _testDBName:String             = "aDBName";
		private var _testCollectionName:String     = "aCollectionName";
		private var _testSelector:Document         = new Document();
		private var _testFullCollectionName:String = "aDBName.aCollectionName";

		[Before]
		public function setUp():void
		{
			_messageFactory = new MessageFactory();

			_opDelete = _messageFactory.makeRemoveOpDeleteMessage(_testDBName, _testCollectionName, _testSelector);
		}

		[After]
		public function tearDown():void
		{
			_messageFactory = null;
		}

		[Test]
		public function makeRemoveOpDeleteMessage_validInputs_returnsOpDeleteInstance():void
		{
			assertTrue(_opDelete is OpDelete);
		}

		[Test]
		public function makeRemoveOpDeleteMessage_validInputs_fullCollectionNameCorrect():void
		{
			assertEquals(_testFullCollectionName, _opDelete.fullCollectionName);
		}

		[Test]
		public function makeRemoveOpDeleteMessage_validInputs_selectorReferenceSet():void
		{
			assertEquals(_testSelector, _opDelete.selector);
		}
	}
}
