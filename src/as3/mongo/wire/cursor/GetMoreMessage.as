package as3.mongo.wire.cursor
{
	import as3.mongo.wire.Wire;
	import as3.mongo.wire.messages.client.FindOptions;
	import as3.mongo.wire.messages.database.OpReply;

	import org.osflash.signals.Signal;
	import org.serialization.bson.Int64;

	public class GetMoreMessage
	{
		private var _wire:Wire;
		private var _options:FindOptions;
		private var _collectionName:String;
		private var _dbName:String;
		private var _cursor:Cursor;

		public function GetMoreMessage(dbName:String,
									   collectionName:String,
									   options:FindOptions,
									   wire:Wire,
									   cursor:Cursor)
		{
			_initializeGetMoreMessage(dbName, collectionName, options, wire, cursor);
		}

		private function _initializeGetMoreMessage(dbName:String,
												   collectionName:String,
												   options:FindOptions,
												   wire:Wire,
												   cursor:Cursor):void
		{
			_dbName = dbName;
			_collectionName = collectionName;
			_options = options;
			_wire = wire;
			_cursor = cursor;
		}

		public function send():void
		{
			_wire.getMore(_dbName, _collectionName, _options, _cursor.cursorID).addOnce(_onGetMoreReplyLoaded);
		}

		private function _onGetMoreReplyLoaded(opReply:OpReply):void
		{
			_cursor.handleGotMoreReply(opReply);
		}
	}
}
