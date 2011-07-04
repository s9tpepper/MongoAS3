package flexUnitTests.as3.mongo.wire.messages
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.MessageFactory;
	import as3.mongo.wire.messages.client.OpUpdate;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	public class MessageFactory_makeUpdateOpUpdateMessage
	{

		private var _messageFactory:MessageFactory;
		private var _validModifier:Document         = new Document();
		private var _validSelector:Document         = new Document();
		private var _validCollectionName:String     = "aCollectionName";
		private var _validDBName:String             = "aDBName";
		private var _validFullCollectionName:String = "aDBName.aCollectionName";
		private var _opUpdate:OpUpdate;

		[Before]
		public function setUp():void
		{
			_messageFactory = new MessageFactory();
			_opUpdate = _messageFactory.makeUpdateOpUpdateMessage(_validDBName, _validCollectionName, _validSelector, _validModifier);
		}

		[After]
		public function tearDown():void
		{
			_messageFactory = null;
		}

		[Test]
		public function makeUpdateOpUpdateMessage_validInputs_returnsOpUpdateInstance():void
		{
			assertTrue(_opUpdate is OpUpdate);
		}

		[Test]
		public function makeUpdateOpUpdateMessage_validInputs_fullCollectionNameCorrect():void
		{
			assertEquals(_validFullCollectionName, _opUpdate.fullCollectionName);
		}

		[Test]
		public function makeUpdateOpUpdateMessage_validInputs_selectorIsSet():void
		{
			assertEquals(_validSelector, _opUpdate.selector);
		}

		[Test]
		public function makeUpdateOpUpdateMessage_validInputs_modifierIsSet():void
		{
			assertEquals(_validModifier, _opUpdate.update);
		}
	}
}
