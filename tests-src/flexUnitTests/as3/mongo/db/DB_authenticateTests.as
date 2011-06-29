package flexUnitTests.as3.mongo.db
{
	import as3.mongo.db.DB;
	import as3.mongo.db.credentials.Credentials;
	import as3.mongo.error.MongoError;
	import as3.mongo.wire.Wire;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;

	public class DB_authenticateTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject = "false", type = "nice")]
		public var mockWire:Wire;


		private var _testDBName:String = "testDBName";
		private var _testHost:String   = "host";
		private var _testPort:Number   = 2;
		private var _db:TestDB;


		[Before]
		public function setUp():void
		{
			_db = new TestDB(_testDBName, _testHost, _testPort);
		}

		[After]
		public function tearDown():void
		{
			_db = null;
		}


		[Test(expects = "as3.mongo.error.MongoError")]
		public function authenticate_setCredentialsNotCalledYet_throwsMongoError():void
		{
			var error:MongoError;

			_db.authenticate();
		}

		[Test]
		public function authenticate_setCredentialsCalledFirst_returnsTrueThatItIsAttemptingAuthentication():void
		{
			_mockWireGetNonceMethod();

			const credentials:Credentials          = new Credentials("aUsername", "aPassword");
			_db.setCredentials(credentials);

			const attemptingAuthentication:Boolean = _db.authenticate();

			assertTrue(attemptingAuthentication);
		}

		private function _mockWireGetNonceMethod():void
		{
			mockWire = nice(Wire, null, [_db]);
			mock(mockWire).method("getNonce").noArgs();
			_db.mockWire = mockWire;
		}


	}
}
