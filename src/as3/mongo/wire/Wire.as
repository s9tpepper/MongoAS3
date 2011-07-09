package as3.mongo.wire
{
	import as3.mongo.db.DB;
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.cursor.GetMoreMessage;
	import as3.mongo.wire.messages.MessageFactory;
	import as3.mongo.wire.messages.client.FindOptions;
	import as3.mongo.wire.messages.client.OpDelete;
	import as3.mongo.wire.messages.client.OpGetMore;
	import as3.mongo.wire.messages.client.OpInsert;
	import as3.mongo.wire.messages.client.OpQuery;
	import as3.mongo.wire.messages.client.OpUpdate;
	import as3.mongo.wire.messages.database.FindOneOpReplyLoader;
	import as3.mongo.wire.messages.database.OpReply;
	import as3.mongo.wire.messages.database.OpReplyLoader;

	import flash.net.Socket;

	import org.osflash.signals.Signal;
	import org.serialization.bson.Int64;

	public class Wire
	{
		protected var _socket:Socket;
		protected var _messageFactory:MessageFactory;

		protected var _db:DB;
		protected var _isConnected:Boolean;
		protected var _messenger:Messenger;
		protected var _connector:Connector;
		protected var _cursorFactory:CursorFactory;
		protected var _activeCursors:Array;

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
			_activeCursors = new Array();
		}

		public function connect():void
		{
			_connector.connect();
		}

		internal function setConnected(value:Boolean):void
		{
			_isConnected = value;
		}

		public function runCommand(command:Document):Signal
		{
			_checkIfSocketIsConnected();
			const opQuery:OpQuery             = messageFactory.makeRunCommandOpQueryMessage(_db.name, "$cmd", command);
			const opReplyLoader:OpReplyLoader = new OpReplyLoader(socket);
			_messenger.sendMessage(opQuery);

			_activeOpReplyLoaders.push(opReplyLoader);
			opReplyLoader.LOADED.addOnce(_onOpReplyLoaded);
			return opReplyLoader.LOADED;
		}

		private var _activeOpReplyLoaders:Vector.<OpReplyLoader> = new Vector.<OpReplyLoader>();

		public function findOne(collectionName:String, query:Document, returnFields:Document=null):Signal
		{
			_checkIfSocketIsConnected();
			const opQuery:OpQuery                           = messageFactory.makeFindOneOpQueryMessage(_db.name, collectionName, query, returnFields);
			const findOneOpReplyLoader:FindOneOpReplyLoader = new FindOneOpReplyLoader(socket);
			_messenger.sendMessage(opQuery);

			_activeOpReplyLoaders.push(findOneOpReplyLoader);
			findOneOpReplyLoader.LOADED.addOnce(_onOpReplyLoaded);
			return findOneOpReplyLoader.LOADED;
		}

		private function _onOpReplyLoaded(document:Object):void
		{
			const loadedLoaders:Vector.<OpReplyLoader> = new Vector.<OpReplyLoader>();
			var loader:OpReplyLoader
			for each (loader in _activeOpReplyLoaders)
			{
				if (loader.isLoaded)
					loadedLoaders.push(loader);
			}

			for each (loader in loadedLoaders)
			{
				if (_activeOpReplyLoaders.lastIndexOf(loader) != -1)
					_activeOpReplyLoaders.splice(_activeOpReplyLoaders.lastIndexOf(loader), 1);
			}
		}

		private function _checkIfSocketIsConnected():void
		{
			if (false === socket.connected)
				throw new MongoError(MongoError.SOCKET_NOT_CONNECTED);
		}

		// TODO: Write integration tests for this
		public function insert(dbName:String, collectionName:String, document:Document):void
		{
			_checkIfSocketIsConnected();
			const opInsert:OpInsert = messageFactory.makeSaveOpInsertMessage(dbName, collectionName, document);
			_messenger.sendMessage(opInsert);
		}

		// TODO: Write integration tests for this
		public function remove(dbName:String, collectionName:String, selector:Document):void
		{
			_checkIfSocketIsConnected();
			const opDelete:OpDelete = messageFactory.makeRemoveOpDeleteMessage(dbName, collectionName, selector);
			_messenger.sendMessage(opDelete);
		}

		// TODO: Write integration tests for this
		public function updateFirst(dbName:String, collectionName:String, selector:Document, document:Document):void
		{
			_checkIfSocketIsConnected();
			const opUpdate:OpUpdate = messageFactory.makeUpdateFirstOpUpdateMessage(dbName, collectionName, selector, document);
			_messenger.sendMessage(opUpdate);
		}

		// TODO: Write integration tests for this
		public function update(dbName:String, collectionName:String, selector:Document, modifier:Document):void
		{
			_checkIfSocketIsConnected();
			const opUpdate:OpUpdate = messageFactory.makeUpdateOpUpdateMessage(dbName, collectionName, selector, modifier);
			_messenger.sendMessage(opUpdate);
		}

		// TODO: Write integration tests for this
		public function upsert(dbName:String, collectionName:String, selector:Document, document:Document):void
		{
			_checkIfSocketIsConnected();
			const opUpdate:OpUpdate = messageFactory.makeUpsertOpUpdateMessage(dbName, collectionName, selector, document);
			_messenger.sendMessage(opUpdate);
		}

		public function find(dbName:String, collectionName:String, query:Document, options:FindOptions=null):Signal
		{
			_checkIfSocketIsConnected();
			const opQuery:OpQuery             = messageFactory.makeFindOpQueryMessage(dbName, collectionName, query, options);
			const opReplyLoader:OpReplyLoader = new OpReplyLoader(socket);

			const cursor:Cursor               = _cursorFactory.getCursor(opReplyLoader);
			cursor.getMoreMessage = new GetMoreMessage(dbName, collectionName, options, this, cursor);
			_activeCursors.push(cursor);
			cursor.cursorReady.addOnce(_onCursorReady);

			_messenger.sendMessage(opQuery);
			return cursor.cursorReady;
		}

		private function _onCursorReady(cursor:Cursor):void
		{
			if (-1 < _activeCursors.lastIndexOf(cursor))
			{
				_activeCursors.splice(_activeCursors.lastIndexOf(cursor), 1);
			}
		}

		public function getMore(dbName:String, collectionName:String, options:FindOptions, cursorID:Int64):Signal
		{
			_checkIfSocketIsConnected();

			const opGetMore:OpGetMore         = messageFactory.makeGetMoreOpGetMoreMessage(dbName, collectionName, options.numberToReturn, cursorID);
			const opReplyLoader:OpReplyLoader = new OpReplyLoader(socket);
			_messenger.sendMessage(opGetMore);
			_activeOpReplyLoaders.push(opReplyLoader);
			opReplyLoader.LOADED.addOnce(_onOpReplyLoaded);
			return opReplyLoader.LOADED;
		}
	}
}
