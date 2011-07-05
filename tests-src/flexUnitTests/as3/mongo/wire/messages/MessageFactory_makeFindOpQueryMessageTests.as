package flexUnitTests.as3.mongo.wire.messages
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.MessageFactory;
	import as3.mongo.wire.messages.client.FindOptions;
	import as3.mongo.wire.messages.client.OpQuery;
	import as3.mongo.wire.messages.client.OpQueryFlags;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	public class MessageFactory_makeFindOpQueryMessageTests
	{

		private var _messageFactory:MessageFactory;
		private var _validFindOptions:FindOptions   = new FindOptions();
		private var _validQuery:Document            = new Document();
		private var _validCollectionName:String     = "aCollectionName";
		private var _validDBName:String             = "aDBName";
		private var _validFullCollectionName:String = "aDBName.aCollectionName";
		private var _opQuery:OpQuery;

		[Before]
		public function setUp():void
		{
			_messageFactory = new MessageFactory();
			_opQuery = _messageFactory.makeFindOpQueryMessage(_validDBName, _validCollectionName, _validQuery, _validFindOptions);
		}

		[After]
		public function tearDown():void
		{
			_messageFactory = null;
			_opQuery = null;
		}

		[Test]
		public function makeFindOpQueryMessage_validInputs_returnsOpQueryInstance():void
		{
			assertTrue(_opQuery is OpQuery);
		}

		[Test]
		public function makeFindOpQueryMessage_validInputs_fullCollectionNameIsCorrect():void
		{
			assertEquals(_validFullCollectionName, _opQuery.fullCollectionName);
		}

		[Test]
		public function makeFindOpQueryMessage_validInputs_queryDocumentIsSet():void
		{
			assertEquals(_validQuery, _opQuery.query);
		}

		[Test]
		public function makeFindOpQueryMessage_validInputs_flagsAreSet():void
		{
			const testFindOptions:FindOptions = new FindOptions(10, 11, new Document("hello:world"), OpQueryFlags.EXHAUST);
			_opQuery = _messageFactory.makeFindOpQueryMessage(_validDBName, _validCollectionName, _validQuery, testFindOptions);
			assertEquals(testFindOptions.flags, _opQuery.flags);
		}

		[Test]
		public function makeFindOpQueryMessage_validInputs_numberToReturnIsSet():void
		{
			const testFindOptions:FindOptions = new FindOptions(10, 11, new Document("hello:world"), OpQueryFlags.EXHAUST);
			_opQuery = _messageFactory.makeFindOpQueryMessage(_validDBName, _validCollectionName, _validQuery, testFindOptions);
			assertEquals(testFindOptions.numberToReturn, _opQuery.numberToReturn);
		}

		[Test]
		public function makeFindOpQueryMessage_validInputs_numbetToSkipIsSet():void
		{
			const testFindOptions:FindOptions = new FindOptions(10, 11, new Document("hello:world"), OpQueryFlags.EXHAUST);
			_opQuery = _messageFactory.makeFindOpQueryMessage(_validDBName, _validCollectionName, _validQuery, testFindOptions);
			assertEquals(testFindOptions.numberToSkip, _opQuery.numberToSkip);
		}

		[Test]
		public function makeFindOpQueryMessage_validInputs_returnFieldSelectorIsSet():void
		{
			const testFindOptions:FindOptions = new FindOptions(10, 11, new Document("hello:world"), OpQueryFlags.EXHAUST);
			_opQuery = _messageFactory.makeFindOpQueryMessage(_validDBName, _validCollectionName, _validQuery, testFindOptions);
			assertEquals(testFindOptions.returnFieldSelector, _opQuery.returnFieldSelector);
		}
	}
}
