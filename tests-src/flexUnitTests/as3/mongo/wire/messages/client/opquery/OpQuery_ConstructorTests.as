package flexUnitTests.as3.mongo.wire.messages.client.opquery
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.OpCodes;
	import as3.mongo.wire.messages.client.OpQuery;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;

	public class OpQuery_ConstructorTests
	{		
		private var testReturnFieldSelector:Document;
		private var testQuery:Document;
		private var testNumberToReturn:int;
		private var testNumberToSkip:int;
		private var testFullCollectionName:String;
		private var testFlags:int;
		private var _opQuery:OpQuery;
		
		[Before]
		public function setUp():void
		{
			_opQuery = new OpQuery(testFlags, testFullCollectionName, testNumberToSkip, testNumberToReturn, testQuery, testReturnFieldSelector);
		}
		
		[After]
		public function tearDown():void
		{
			_opQuery = null;
		}
		
		[Test]
		public function OpQuery_onInstantiation_opCodeSetToOpQueryCode():void
		{
			assertEquals(OpCodes.OP_QUERY, _opQuery.msgHeader.opCode);
		}
		
		[Test]
		public function OpQuery_onInstantiation_bsonEncoderNotNull():void
		{
			assertNotNull(_opQuery.bsonEncoder);
		}
	}
}