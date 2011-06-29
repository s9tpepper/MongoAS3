package as3.mongo.wire
{
	import as3.mongo.db.DB;
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.MessageFactory;
	import as3.mongo.wire.messages.client.OpInsert;
	import as3.mongo.wire.messages.client.OpQuery;

	import flash.net.Socket;

	public class Wire
	{
		protected var _socket:Socket;
		protected var _messageFactory:MessageFactory;

		protected var _db:DB;
		protected var _isConnected:Boolean;
		protected var _messenger:Messenger;
		protected var _connector:Connector;
		protected var _cursorFactory:CursorFactory;

		public function get connector():Connector
		{
			return _connector;
		}

		public function get messenger():Messenger
		{
			return _messenger;
		}

		public function get db():DB
		{
			return _db;
		}

		public function get messageFactory():MessageFactory
		{
			return _messageFactory;
		}

		public function get socket():Socket
		{
			return _socket;
		}

		public function get isConnected():Boolean
		{
			return _isConnected;
		}

		public function Wire(db:DB)
		{
			_initializeWire(db);
		}

		private function _initializeWire(db:DB):void
		{
			_db = db;
			_socket = new Socket();
			_messenger = new Messenger(this);
			_connector = new Connector(this);
			_messageFactory = new MessageFactory();
			_cursorFactory = new CursorFactory();
		}

		public function connect():void
		{
			_connector.connect();
		}

		internal function setConnected(value:Boolean):void
		{
			_isConnected = value;
		}

		public function runCommand(command:Document, readCommandReplyCallback:Function=null):Cursor
		{
			_checkIfSocketIsConnected();
			const opQuery:OpQuery = messageFactory.makeRunCommandOpQueryMessage(_db.name, "$cmd", command);
			const cursor:Cursor   = _getCursor(readCommandReplyCallback);
			_messenger.sendMessage(opQuery);
			return cursor;
		}

		public function findOne(collectionName:String,
								query:Document,
								returnFields:Document,
								readAllDocumentsCallback:Function=null):Cursor
		{
			_checkIfSocketIsConnected();
			const opQuery:OpQuery = messageFactory.makeFindOneOpQueryMessage(_db.name, collectionName, query, returnFields);
			const cursor:Cursor   = _getCursor(readAllDocumentsCallback);
			_messenger.sendMessage(opQuery);
			return cursor;
		}

		private function _getCursor(readAllDocumentsCallback:Function):Cursor
		{
			const cursor:Cursor = _cursorFactory.getCursor(socket);
			if (readAllDocumentsCallback is Function)
				cursor.REPLY_COMPLETE.addOnce(readAllDocumentsCallback);
			return cursor;
		}


		private function _checkIfSocketIsConnected():void
		{
			if (false === socket.connected)
				throw new MongoError(MongoError.FIND_ONE_SOCKET_NOT_CONNECTED);
		}

		public function save(dbName:String,
							 collectionName:String,
							 document:Document,
							 readAllDocumentsCallback:Function=null):void
		{
			_checkIfSocketIsConnected();
			const opInsert:OpInsert = messageFactory.makeSaveOpInsertMessage(dbName, collectionName, document);
			_messenger.sendMessage(opInsert);
		}
	}
}
