package as3.mongo.db
{
	import as3.mongo.db.collection.Collection;
	import as3.mongo.db.credentials.Credentials;
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;
	import as3.mongo.wire.Wire;
	import as3.mongo.wire.cursor.Cursor;

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
		public function get hasCredentials():Boolean
		{
			return (credentials is Credentials);
		}

		private var _isConnected:Boolean;

		public function get isConnected():Boolean
		{
			return _isConnected;
		}

		private var _port:uint;

		public function get port():uint
		{
			return _port;
		}

		private var _host:String;

		public function get host():String
		{
			return _host;
		}

		private var _isAuthenticated:Boolean;

		public function get isAuthenticated():Boolean
		{
			return _isAuthenticated;
		}

		private var _name:String;

		public function get name():String
		{
			return _name;
		}

		protected var _wire:Wire;

		public function get wire():Wire
		{
			return _wire;
		}

		private var _collections:Dictionary;
		protected var credentials:Credentials;

		public const CONNECTED:Signal                = new Signal(DB);
		public const CONNECTION_FAILED:Signal        = new Signal(DB);
		public const SOCKET_POLICY_FILE_ERROR:Signal = new Signal(DB);

		public function DB(databaseName:String, databaseHost:String, databasePort:uint)
		{
			_initialize(databaseName, databaseHost, databasePort);
		}

		private function _initialize(databaseName:String, databaseHost:String, databasePort:uint):void
		{
			_wire = new Wire(this);

			_collections = new Dictionary();

			_name = databaseName;
			_host = databaseHost;
			_port = databasePort;
		}

		public function setCredentials(dbCredentials:Credentials):void
		{
			credentials = dbCredentials;
		}

		public function authenticate():void
		{
			if (!hasCredentials)
				throw new MongoError(MongoError.CALL_SET_CREDENTIALS_BEFORE_AUTHENTICATE);

			wire.getNonce();
		}


		public function collection(collectionName:String):Collection
		{
			DBInputValidator.checkForInvalidCollectionNames(collectionName);

			return _getCollection(collectionName);
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

		public function findOne(collectionName:String,
								query:Document,
								returnFields:Document=null,
								readAllDocumentsCallback:Function=null):Cursor
		{
			DBInputValidator.checkForInvalidFindOneParameters(collectionName, query);

			return wire.findOne(collectionName, query, returnFields, readAllDocumentsCallback);
		}


		public function connect():void
		{
			wire.connect();
		}
	}
}
