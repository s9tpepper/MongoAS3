package as3.mongo
{
	import as3.mongo.db.DB;
	import as3.mongo.error.MongoError;
	
	import flash.utils.Dictionary;

	public class Mongo
	{
		private var _host:String;
		private var _port:uint;
		private var _databases:Dictionary;
		
		public function Mongo(host:String, port:uint=27017)
		{
			_initialize(host, port);
		}
		
		public function get port():uint
		{
			return _port;
		}

		public function get host():String
		{
			return _host;
		}
		
		
		private function _initialize(mongoHost:String, mongoPort:uint):void
		{
			_databases = new Dictionary();
			
			_host = mongoHost;
			_port = mongoPort;
		}
		

		public function db(databaseName:String):DB
		{
			if (null == databaseName)
				throw new MongoError(MongoError.DATABASE_NAME_MUST_NOT_BE_NULL);
			
			return _getDatabase(databaseName);
		}
		
		private function _getDatabase(databaseName:String):DB
		{
			var db:DB = _databases[databaseName];
			if (null == db)
			{
				db = new DB(databaseName, host, port);
				_databases[databaseName] = db;
			}
			
			return db;
		}
	}
}