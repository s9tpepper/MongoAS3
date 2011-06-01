package flexUnitTests.as3.mongo.db.credentials
{
	import as3.mongo.db.credentials.Credentials;
	import as3.mongo.error.MongoError;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.fail;

	public class DBCredentialsTests
	{		
		private var testPassword:String = "password";
		private var testUsername:String = "username";
		private var _dbCredentials:Credentials;
		
		[Before]
		public function setUp():void
		{
			_dbCredentials = new Credentials(testUsername, testPassword);
		}
		
		[After]
		public function tearDown():void
		{
			_dbCredentials = null;
		}
		
		
		[Test]
		public function DBCredentials_onInstantiationWithNonNullArguments_constructorArgumentsStored():void
		{
			assertConstructorArgumentsAreStored();
		}
		private function assertConstructorArgumentsAreStored():void
		{
			assertEquals(testUsername, _dbCredentials.username);
			assertEquals(testPassword, _dbCredentials.password);
		}

		[Test(expects="as3.mongo.error.MongoError")]
		public function DBCredentials_onInstantiationUsernameIsNull_throwsUsernameCannotBeNullError():void
		{
			_dbCredentials = new Credentials(null, "aPassword");
		}
		
		[Test(expects="as3.mongo.error.MongoError")]
		public function DBCredentials_onInstantiationPasswordIsNull_throwsPasswordCannotBeNullError():void
		{
			_dbCredentials = new Credentials("aUsername", null);
		}
		
		[Test]
		public function getCredentialsHash_allScenarios_returnsMongoMD5Hash():void
		{
			const mongoMD5Hash:String = "aa5469a39788b6c3988537cd409887a1";
			
			const credentialsHash:String = _dbCredentials.getCredentialsHash();
			
			assertEquals(mongoMD5Hash, credentialsHash);
		}
		
		[Test]
		public function getAuthenticationDigest_noncePassedIn_returnsAuthenticationDigestHash():void
		{
			const nonce:String = "cd9c2d68e929ca25";
			const exampleAuthDigestHash:String = "77ddc6c3bc28907e6cb19f162d94c93e";
			
			const authenticationDigestHash:String = _dbCredentials.getAuthenticationDigest(nonce);
			
			assertEquals(exampleAuthDigestHash, authenticationDigestHash);
		}
		
		[Test(expects="as3.mongo.error.MongoError")]
		public function getAuthenticationDigest_nullNoncePassedIn_throwsMongoError():void
		{
			var error:MongoError;
			
			_dbCredentials.getAuthenticationDigest(null);
		}
		
		[Test(expects="as3.mongo.error.MongoError")]
		public function getAuthenticationDigest_emptyNoncePassedIn_throwsMongoError():void
		{
			var error:MongoError;
			
			_dbCredentials.getAuthenticationDigest("");
		}
	}
}