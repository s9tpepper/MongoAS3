package flexUnitTests.as3.mongo.wire.messages.client.opinsert
{
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.client.OpInsert;

	import org.bson.BSONEncoder;
	import org.serialization.bson.BSON;

	public class TestOpInsert extends OpInsert
	{
		public function TestOpInsert(insertFlags:int, fullCollectionName:String)
		{
			super(insertFlags, fullCollectionName);
		}

		public function set mockMsgHeader(aMockedMsgHeader:MsgHeader):void
		{
			_msgHeader = aMockedMsgHeader;
		}

		public function set mockBSONEncoder(aMockedBSONEncoder:BSONEncoder):void
		{
			_bsonEncoder = aMockedBSONEncoder;
		}
	}
}
