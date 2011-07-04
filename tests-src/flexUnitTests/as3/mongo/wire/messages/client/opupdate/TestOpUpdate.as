package flexUnitTests.as3.mongo.wire.messages.client.opupdate
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.client.OpUpdate;

	public class TestOpUpdate extends OpUpdate
	{
		public function TestOpUpdate(aFullCollectionName:String, aFlags:int, aSelector:Document, aUpdate:Document)
		{
			super(aFullCollectionName, aFlags, aSelector, aUpdate);
		}

		public function set mockMsgHeader(value:MsgHeader):void
		{
			_msgHeader = value;
		}
	}
}
