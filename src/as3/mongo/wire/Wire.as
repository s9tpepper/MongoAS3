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

		private var _db:DB;
		private var _isConnected:Boolean;
		private var _messenger:Messenger;
		private var _connector:Connector;

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
			return _messenger.sendMessage(opQuery, readCommandReplyCallback);
		}

		public function findOne(collectionName:String,
								query:Document,
								returnFields:Document,
								readAllDocumentsCallback:Function=null):Cursor
		{
			_checkIfSocketIsConnected();
			const opQuery:OpQuery = messageFactory.makeFindOneOpQueryMessage(_db.name, collectionName, query, returnFields);
			return _messenger.sendMessage(opQuery, readAllDocumentsCallback);
		}

		private function _checkIfSocketIsConnected():void
		{
			if (false === socket.connected)
				throw new MongoError(MongoError.FIND_ONE_SOCKET_NOT_CONNECTED);
		}

		public function save(dbName:String,
							 collectionName:String,
							 document:Document,
							 readAllDocumentsCallback:Function=null):Cursor
		{
			_checkIfSocketIsConnected();
			const opInsert:OpInsert = messageFactory.makeSaveOpInsertMessage(dbName, collectionName, document);
			return _messenger.sendMessage(opInsert, readAllDocumentsCallback);
		}
	}
}
