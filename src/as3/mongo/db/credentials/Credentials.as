package as3.mongo.db.credentials
{
	import as3.mongo.error.MongoError;
	
	import com.adobe.crypto.MD5;

	public class Credentials
	{
		private var _username:String;
		private var _password:String;
		
		public function Credentials(aUsername:String, aPassword:String)
		{
			_initializeCredentials(aUsername, aPassword);
		}
		
		private function _initializeCredentials(aUsername:String, aPassword:String):void
		{
			_checkForInvalidCredentials(aUsername, aPassword);
			
			_username = aUsername;
			_password = aPassword;
		}
		
		private function _checkForInvalidCredentials(aUsername:String, aPassword:String):void
		{
			if (null == aUsername)
				throw new MongoError(MongoError.DATABASE_USERNAME_MAY_NOT_BE_NULL);
			
			if (null == aPassword)
				throw new MongoError(MongoError.DATABASE_PASSWORD_MAY_NOT_BE_NULL);
		}
		
		public function get password():String
		{
			return _password;
		}

		public function get username():String
		{
			return _username;
		}

		public function getCredentialsHash():String
		{
			const preHash:String = username + ":mongo:" + password;
			
			return MD5.hash(preHash);
		}
		
		public function getAuthenticationDigest(nonce:String):String
		{
			_checkForInvalidNonce(nonce);
			
			const preHash:String = nonce + username + getCredentialsHash();
			
			return MD5.hash(preHash);
		}

		private function _checkForInvalidNonce(nonce:String):void
		{
			if (null == nonce || "" == nonce)
				throw new MongoError(MongoError.NONCE_MUST_NOT_BE_NULL_OR_EMPTY);
		}


	}
}