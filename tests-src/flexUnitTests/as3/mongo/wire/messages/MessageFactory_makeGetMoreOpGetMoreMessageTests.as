package flexUnitTests.as3.mongo.wire.messages
{
	import as3.mongo.wire.messages.MessageFactory;
	import as3.mongo.wire.messages.client.OpGetMore;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.serialization.bson.Int64;

	public class MessageFactory_makeGetMoreOpGetMoreMessageTests
	{
		private var _messageFactory:MessageFactory;
		private var _opGetMore:OpGetMore;
		private var _testCursorID:Int64            = Int64.ONE;
		private var _testNumberToReturn:int        = 5;
		private var _testCollectionName:String     = "aCollectionName";
		private var _testDBName:String             = "aDBName";
		private var _testFullCollectionName:String = "aDBName.aCollectionName";

		[Before]
		public function setUp():void
		{
			_messageFactory = new MessageFactory();
			_opGetMore = _messageFactory.makeGetMoreOpGetMoreMessage(_testDBName, _testCollectionName, _testNumberToReturn, _testCursorID);
		}

		[After]
		public function tearDown():void
		{
			_messageFactory = null;
		}

		[Test]
		public function makeGetMoreOpGetMoreMessage_validInputs_returnsOpGetMoreInstance():void
		{
			assertTrue(_opGetMore is OpGetMore);
		}

		[Test]
		public function makeGetMoreOpGetMoreMessage_validInputs_fullCollectionNameCorrect():void
		{
			assertEquals(_testFullCollectionName, _opGetMore.fullCollectionName);
		}

		[Test]
		public function makeGetMoreOpGetMoreMessage_validInputs_numberToReturnIsCorrect():void
		{
			assertEquals(_testNumberToReturn, _opGetMore.numberToReturn);
		}

		[Test]
		public function makeGetMoreOpGetMoreMessage_validInputs_cursorIDIsCorrect():void
		{
			assertEquals(_testCursorID, _opGetMore.cursorID);
		}
	}
}
