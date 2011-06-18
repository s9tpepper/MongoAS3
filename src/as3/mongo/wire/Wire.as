package as3.mongo.wire
{
	import as3.mongo.db.DB;
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.cursor.CursorFactory;
	import as3.mongo.wire.messages.MessageFactory;
	import as3.mongo.wire.messages.client.OpQuery;
	import as3.mongo.wire.messages.database.OpReply;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.setTimeout;

	import mx.utils.ObjectUtil;

	import org.bson.BSONEncoder;
	import org.osflash.signals.Signal;

	public class Wire
	{
		public static const NONCE_QUERY:Document          = new Document("getnonce:1");
		public static const AUTHENTICATION_PROBLEM:Signal = new Signal();

		protected var _socket:Socket;
		protected var _messageFactory:MessageFactory;
		protected var _cursorFactory:CursorFactory;

		private var _db:DB;
		private var _isConnected:Boolean;
		private var _nonceCursor:Cursor;

		public function get cursorFactory():CursorFactory
		{
			return _cursorFactory;
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
			_messageFactory = new MessageFactory();
			_cursorFactory = new CursorFactory();
		}

		public function connect():void
		{
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _handleSecurityError, false, 0, true);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, _handleSocketError, false, 0, true);
			_socket.addEventListener(Event.CONNECT, _handleSocketConnect, false, 0, true);
			_socket.connect(_db.host, _db.port);
		}

		private function _handleSecurityError(event:Event):void
		{
			_db.SOCKET_POLICY_FILE_ERROR.dispatch(_db);
		}

		private function _handleSocketError(event:Event):void
		{
			_db.CONNECTION_FAILED.dispatch(_db);
		}

		private function _handleSocketConnect(event:Event):void
		{
			_isConnected = true;
			_db.CONNECTED.dispatch(_db);
		}

		public function getNonce():void
		{
			_nonceCursor = findOne("$cmd", NONCE_QUERY, null, _readNonceResponse);
		}

		private function _readNonceResponse(opReply:OpReply):void
		{
			if (nonceWasReturned(opReply))
			{
				_finishAuthentication();
			}
			else
			{
				AUTHENTICATION_PROBLEM.dispatch();
			}
		}

		private function nonceWasReturned(opReply:OpReply):Boolean
		{
			return 1 == opReply.numberReturned && opReply.documents[0].ok == 1;
		}


		private function _finishAuthentication():void
		{
			trace("_finishAuthentication()");
		}

		public function findOne(collectionName:String,
								query:Document,
								returnFields:Document,
								readAllDocumentsCallback:Function):Cursor
		{
			_checkIfSocketIsConnected();

			const cursor:Cursor   = _cursorFactory.getCursor(socket);

			_setReadAllDocumentsCallback(readAllDocumentsCallback);

			const opQuery:OpQuery = messageFactory.makeFindOneOpQueryMessage(_db.name, collectionName, query, returnFields);

			_sendMessage(opQuery);

			return cursor;
		}

		private function _setReadAllDocumentsCallback(readAllDocumentsCallback:Function):void
		{
			if (readAllDocumentsCallback is Function)
				Cursor.REPLY_COMPLETE.addOnce(readAllDocumentsCallback);
		}

		private function _checkIfSocketIsConnected():void
		{
			if (false === socket.connected)
				throw new MongoError(MongoError.FIND_ONE_SOCKET_NOT_CONNECTED);
		}

		private function _sendMessage(opQuery:OpQuery):void
		{
			socket.writeBytes(opQuery.toByteArray());
			socket.flush();
		}
	}
}
