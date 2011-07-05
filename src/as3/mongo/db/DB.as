package as3.mongo.db
{
	import as3.mongo.db.collection.Collection;
	import as3.mongo.db.credentials.Credentials;
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;
	import as3.mongo.wire.Wire;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.client.FindOptions;

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
		protected var _authenticationFactory:AuthenticationFactory;


		public function get authenticationFactory():AuthenticationFactory
		{
			return _authenticationFactory;
		}

		public function set authenticationFactory(value:AuthenticationFactory):void
		{
			_authenticationFactory = value;
		}

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
			_authenticationFactory = new AuthenticationFactory();

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
			DBMethodInputValidator.canAuthenticate(this);
			authenticationFactory.getAuthentication(this);
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

		public function findOne(collectionName:String, query:Document, returnFields:Document=null):Signal
		{
			DBMethodInputValidator.checkForInvalidFindOneParameters(collectionName, query);

			return wire.findOne(collectionName, query, returnFields);
		}

		public function runCommand(command:Document):Signal
		{
			return wire.runCommand(command);
		}

		public function connect():void
		{
			wire.connect();
		}

		public function insert(collectionName:String, document:Document):void
		{
			wire.insert(name, collectionName, document);
		}

		public function remove(collectionName:String, selector:Document):void
		{
			wire.remove(name, collectionName, selector);
		}

		public function updateFirst(collectionName:String, selector:Document, update:Document):void
		{
			_validateUpdateMethodsInputs(collectionName, selector, update);
			wire.updateFirst(name, collectionName, selector, update);
		}

		public function update(collectionName:String, selector:Document, modifier:Document):void
		{
			_validateUpdateMethodsInputs(collectionName, selector, modifier);
			wire.update(name, collectionName, selector, modifier);
		}

		public function upsert(collectionName:String, selector:Document, document:Document):void
		{
			_validateUpdateMethodsInputs(collectionName, selector, document);
			wire.upsert(name, collectionName, selector, document);
		}

		private function _validateUpdateMethodsInputs(collectionName:String, document1:Document, document2:Document):void
		{
			DBMethodInputValidator.checkForInvalidCollectionNames(collectionName);
			DBMethodInputValidator.checkForInvalidDocumentInputs(document1);
			DBMethodInputValidator.checkForInvalidDocumentInputs(document2);
		}

		public function find(collectionName:String, query:Document, options:FindOptions=null):Cursor
		{
			DBMethodInputValidator.checkForInvalidCollectionNames(collectionName);
			DBMethodInputValidator.checkForInvalidDocumentInputs(query);
			return wire.find(name, collectionName, query, options);
		}
	}
}
