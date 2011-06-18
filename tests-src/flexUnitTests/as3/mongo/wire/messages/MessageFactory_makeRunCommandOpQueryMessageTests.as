package flexUnitTests.as3.mongo.wire.messages
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.MessageFactory;
	import as3.mongo.wire.messages.client.OpQuery;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;

	public class MessageFactory_makeRunCommandOpQueryMessageTests
	{

		private static const _TEST_DB_NAME:String              = "dbName";
		private static const _TEST_COLLECTION_NAME:String      = "collectionName";
		private static const _TEST_FULL_COLLECTION_NAME:String = "dbName.collectionName";
		private static const _TEST_COMMAND_DOCUMENT:Document   = new Document();

		private var _messageFactory:MessageFactory;

		[Before]
		public function setUp():void
		{
			_messageFactory = new MessageFactory();
		}

		[After]
		public function tearDown():void
		{
			_messageFactory = null;
		}


		private function _getRunCommandOpQueryMessage():OpQuery
		{
			return _messageFactory.makeRunCommandOpQueryMessage(_TEST_DB_NAME, _TEST_COLLECTION_NAME, _TEST_COMMAND_DOCUMENT);
		}

		[Test]
		public function makeRunCommandOpQueryMessage_validInputs_returnsOpQuery():void
		{
			assertTrue(_getRunCommandOpQueryMessage() is OpQuery);
		}

		[Test]
		public function makeRunCommandOpQueryMessage_validInputs_opQueryFlagsSetToZero():void
		{
			assertEquals(0, _getRunCommandOpQueryMessage().flags);
		}

		[Test]
		public function makeRunCommandOpQueryMessage_validInputs_fullCollectionNameSet():void
		{
			assertEquals(_TEST_FULL_COLLECTION_NAME, _getRunCommandOpQueryMessage().fullCollectionName);
		}

		[Test]
		public function makeRunCommandOpQueryMessage_validInputs_opQueryNumberToSkipSetToZero():void
		{
			assertEquals(0, _getRunCommandOpQueryMessage().numberToSkip);
		}

		[Test]
		public function makeRunCommandOpQueryMessage_validInputs_opQueryNumberToReturnSetToNegativeOne():void
		{
			assertEquals(-1, _getRunCommandOpQueryMessage().numberToReturn);
		}

		[Test]
		public function makeRunCommandOpQueryMessage_validInputs_queryReturnsQueryDocument():void
		{
			assertEquals(_TEST_COMMAND_DOCUMENT, _getRunCommandOpQueryMessage().query);
		}

		[Test]
		public function makeRunCommandOpQueryMessage_validInputs_returnFieldSelectorIsNull():void
		{
			assertNull(_getRunCommandOpQueryMessage().returnFieldSelector);
		}
	}
}
