package flexUnitTests.as3.mongo.wire.messages.client
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.MsgHeader;
	import as3.mongo.wire.messages.client.OpQuery;
	
	import flash.utils.ByteArray;
	
	import org.serialization.bson.BSON;
	import org.bson.BSONEncoder;
	
	public class TestOpQuery extends OpQuery
	{
		public function TestOpQuery(queryFlags:int, queryFullCollectionName:String, queryNumberToSkip:int, queryNumberToReturn:int, queryQuery:Document, queryReturnFieldSelector:Document=null)
		{
			super(queryFlags, queryFullCollectionName, queryNumberToSkip, queryNumberToReturn, queryQuery, queryReturnFieldSelector);
		}
		
		public function set msgHeader(header:MsgHeader):void
		{
			_msgHeader = header;
		}
		
		public function set bsonEncoder(value:BSONEncoder):void
		{
			_bsonEncoder = value;
		}
	}
}