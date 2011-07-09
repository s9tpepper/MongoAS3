package flexUnitTests.as3.mongo.wire.messages.client.opgetmore
{
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.client.OpGetMore;

	import org.serialization.bson.Int64;

	public class TestOpGetMore extends OpGetMore
	{
		public function TestOpGetMore(fullCollectionName:String, numberToReturn:int, cursorID:Int64)
		{
			super(fullCollectionName, numberToReturn, cursorID);
		}

		public function set mockMsgHeader(value:MsgHeader):void
		{
			_msgHeader = value;
		}
	}
}
