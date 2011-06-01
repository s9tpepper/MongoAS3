package as3.mongo.db
{
	import as3.mongo.db.collection.Collection;
	import as3.mongo.db.credentials.Credentials;
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	public class DB extends EventDispatcher
	{
		public const CONNECTED:Signal = new Signal(DB);
		public const CONNECTION_FAILED:Signal = new Signal(DB);
		public const SOCKET_POLICY_FILE_ERROR:Signal = new Signal(DB);
		
		private var _name:String;
		private var _host:String;
		private var _port:uint;
		private var _isConnected:Boolean;
		private var _isAuthenticated:Boolean;
		private var _collections:Dictionary;
		
		protected var credentials:Credentials;
		protected var socket:Socket;
		
		public function DB(databaseName:String, databaseHost:String, databasePort:uint)
		{
			_initialize(databaseName, databaseHost, databasePort);
		}
		
		public function get hasCredentials():Boolean
		{
			return (credentials is Credentials);
		}

		public function get isConnected():Boolean
		{
			return _isConnected;
		}

		public function get port():uint
		{
			return _port;
		}

		public function get host():String
		{
			return _host;
		}

		public function get isAuthenticated():Boolean
		{
			return _isAuthenticated;
		}

		public function get name():String
		{
			return _name;
		}

		private function _initialize(databaseName:String, databaseHost:String, databasePort:uint):void
		{
			_collections = new Dictionary();
			
			_name = databaseName;
			_host = databaseHost;
			_port = databasePort;
		}
		
		public function connect():void
		{
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _handleSecurityError, false, 0, true);
			socket.addEventListener(IOErrorEvent.IO_ERROR, _handleSocketError, false, 0, true);
			socket.addEventListener(Event.CONNECT, _handleSocketConnect, false, 0, true);
			socket.connect(host, port);
		}
		
		private function _handleSecurityError(event:Event):void
		{
			SOCKET_POLICY_FILE_ERROR.dispatch(this);
		}
		private function _handleSocketError(event:Event):void
		{
			CONNECTION_FAILED.dispatch(this);
		}
		private function _handleSocketConnect(event:Event):void
		{
			_isConnected = true;
			CONNECTED.dispatch(this);
		}
		
		public function setCredentials(dbCredentials:Credentials):void
		{
			credentials = dbCredentials;
		}
		
		public function authenticate():void
		{
			if (!hasCredentials)
				throw new MongoError(MongoError.CALL_SET_CREDENTIALS_BEFORE_AUTHENTICATE);
			
		}
		
		public function collection(collectionName:String):Collection
		{
			_checkForInvalidCollectionNames(collectionName);
			
			return _getCollection(collectionName);
		}

		private function _checkForInvalidCollectionNames(collectionName:String):void
		{
			if (null == collectionName)
				throw new MongoError(MongoError.COLLECTION_NAME_MAY_NOT_BE_NULL_OR_EMPTY);
		
			if ("" == collectionName)
				throw new MongoError(MongoError.COLLECTION_NAME_MAY_NOT_BE_NULL_OR_EMPTY);
		}

		private function _getCollection(collectionName:String):Collection
		{
			var collection:Collection = _collections[collectionName];
			
			if (null == collection)
			{
				collection = new Collection(collectionName, this);
				_collections[collectionName] = collection;
			}
			return collection;
		}
		
		public function findOne(collectionName:String, query:Document, returnFields:Document=null, readAllDocumentsCallback:Function=null):void
		{
			if (null == collectionName)
				throw new MongoError(MongoError.COLLECTION_NAME_MAY_NOT_BE_NULL_OR_EMPTY);
		}
	}
}