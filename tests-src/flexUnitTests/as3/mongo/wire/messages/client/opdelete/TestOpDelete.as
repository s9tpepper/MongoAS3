package flexUnitTests.as3.mongo.wire.messages.client.opdelete
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.client.OpDelete;
	import org.bson.BSONEncoder;

	public class TestOpDelete extends OpDelete
	{
		public function TestOpDelete(aFullCollectionName:String, aSelector:Document)
		{
			super(aFullCollectionName, aSelector);
		}

		public function set mockMsgHeader(value:MsgHeader):void
		{
			_msgHeader = value;
		}
	}
}
