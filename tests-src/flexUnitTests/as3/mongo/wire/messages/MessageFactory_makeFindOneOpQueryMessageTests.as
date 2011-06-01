package flexUnitTests.as3.mongo.wire.messages
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.MessageFactory;
	import as3.mongo.wire.messages.client.OpQuery;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	public class MessageFactory_makeFindOneOpQueryMessageTests
	{
		private var _messageFactory:MessageFactory;
		private var _opQuery:OpQuery;
		
		private var testReturnFieldSelectorDocument:Document = new Document();
		private var testQueryDocument:Document = new Document();
		private var testCollectionName:String = "aCollection";
		private var testDBName:String = "aDatabase";

		[Before]
		public function setUp():void
		{
			_messageFactory = new MessageFactory();
			_opQuery = _messageFactory.makeFindOneOpQueryMessage(testDBName, 
																 testCollectionName, 
																 testQueryDocument, 
																 testReturnFieldSelectorDocument);
		}

		[After]
		public function tearDown():void
		{
			_messageFactory = null;
			_opQuery = null;
		}

		[Test]
		public function makeFindOneOpQueryMessage_validInputs_returnsOpQuery():void
		{
			assertTrue(_opQuery is OpQuery);
		}
		
		[Test]
		public function makeFindOneOpQueryMessage_validInputs_opQueryFlagsSetToZero():void
		{
			assertEquals(0, _opQuery.flags);
		}
		
		[Test]
		public function makeFindOneOpQueryMessage_validInputs_fullCollectionNameSet():void
		{
			const fullCollectionName:String = "aDatabase.aCollection";
			assertEquals(fullCollectionName, _opQuery.fullCollectionName);
		}
		
		[Test]
		public function makeFindOneOpQueryMessage_validInputs_opQueryNumberToSkipSetToZero():void
		{
			assertEquals(0, _opQuery.numberToSkip);
		}
		
		[Test]
		public function makeFindOneOpQueryMessage_validInputs_opQueryNumberToReturnSetToOne():void
		{
			assertEquals(1, _opQuery.numberToReturn);
		}
		
		[Test]
		public function makeFindOneOpQueryMessage_validInputs_queryReturnsQueryDocument():void
		{
			assertEquals(testQueryDocument, _opQuery.query);
		}
		
		[Test]
		public function makeFindOneOpQueryMessage_validInputs_returnFieldSelectorReturnsTheTestDocument():void
		{
			assertEquals(testReturnFieldSelectorDocument, _opQuery.returnFieldSelector);
		}
	}
}
