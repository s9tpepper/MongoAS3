package as3.mongo.db
{
	import as3.mongo.db.collection.Collection;
	import as3.mongo.db.credentials.Credentials;
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.Wire;
	import as3.mongo.wire.cursor.Cursor;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import org.osflash.signals.Signal;

	public class DB extends EventDispatcher
	{
		public const AUTHENTICATED:Signal            = new Signal(DB);
		public const AUTHENTICATION_PROBLEM:Signal   = new Signal(DB);
		public const CONNECTED:Signal                = new Signal(DB);
		public const CONNECTION_FAILED:Signal        = new Signal(DB);
		public const SOCKET_POLICY_FILE_ERROR:Signal = new Signal(DB);

		protected var _collections:Dictionary;
		protected var _credentials:Credentials;
		protected var _isConnected:Boolean;
		protected var _port:uint;
		protected var _host:String;
		protected var _isAuthenticated:Boolean;
		protected var _name:String;
		protected var _wire:Wire;


		public function get credentials():Credentials
		{
			return _credentials;
		}

		public function get hasCredentials():Boolean
		{
			return (_credentials is Credentials);
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

		public function get wire():Wire
		{
			return _wire;
		}

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
			_credentials = dbCredentials;
		}

		public function authenticate():Boolean
		{
			trace("authenticate()");
			DBMethodInputValidator.canAuthenticate(this);
			new Authentication(this);
			return true;
		}

		public function collection(collectionName:String):Collection
		{
			DBMethodInputValidator.checkForInvalidCollectionNames(collectionName);
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
			DBMethodInputValidator.checkForInvalidFindOneParameters(collectionName, query);

			return wire.findOne(collectionName, query, returnFields, readAllDocumentsCallback);
		}

		public function runCommand(command:Document, readCommandReplyCallback:Function=null):Cursor
		{
			return _wire.runCommand(command, readCommandReplyCallback);
		}

		public function connect():void
		{
			wire.connect();
		}

		public function save(collectionName:String, document:Document, readAllDocumentsCallback:Function=null):void
		{
			wire.save(name, collectionName, document, readAllDocumentsCallback);
		}
	}
}
