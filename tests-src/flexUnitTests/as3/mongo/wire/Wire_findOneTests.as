package flexUnitTests.as3.mongo.wire
{
	import as3.mongo.db.DB;
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.CursorFactory;
	import as3.mongo.wire.Wire;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.MessageFactory;
	import as3.mongo.wire.messages.client.OpQuery;
	import as3.mongo.wire.messages.database.OpReply;
	import as3.mongo.wire.messages.database.OpReplyLoader;

	import flash.net.Socket;
	import flash.utils.ByteArray;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.bson.BSONEncoder;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.text.re;
	import org.osflash.signals.Signal;

	public class Wire_findOneTests
	{
		[Rule]
		public var mocks:MockolateRule                = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockedDB:DB;

		[Mock(inject = "true", type = "nice")]
		public var mockedMessageFactory:MessageFactory;

		[Mock(inject = "true", type = "nice")]
		public var mockedSocket:Socket;

		[Mock(inject = "false", type = "nice")]
		public var mockOpReplyLoader:OpReplyLoader;

		[Mock(inject = "true", type = "nice")]
		public var mockedCursorFactory:CursorFactory;

		private var _wire:TestWire;
		private var readAllDocumentsCallback:Function = function(opReply:OpReply):void
		{
		};
		private var testResultFieldsSelector:Document = new Document();
		private var testQuery:Document                = new Document("getNonce:1");
		private var testCollection:String             = "aCollection";
		private var _returnedOpQueryMessage:OpQuery;

		[Before]
		public function setUp():void
		{
			mockOpReplyLoader = nice(OpReplyLoader, null, [mockedSocket]);

			mock(mockedSocket).method("toString").returns("[object MockedSocket]");
			mock(mockedSocket).getter("bytesAvailable").returns(8);

			_wire = new TestWire(mockedDB);
			_wire.mockMessageFactory = mockedMessageFactory;

			mock(mockedSocket).getter("connected").returns(true);
			_wire.mockSocket = mockedSocket;
		}

		[After]
		public function tearDown():void
		{
			_wire = null;
		}


		[Test]
		public function findOne_validInputs_makeOpQueryMessageInvoked():void
		{
			var dbName:String = _setUpMocksForMakeOpQueryMessageInvoke();

			_wire.findOne(testCollection, testQuery, testResultFieldsSelector);

			assertThat(mockedMessageFactory, received().method("makeFindOneOpQueryMessage").args(dbName, testCollection, testQuery, testResultFieldsSelector).once());
		}

		private function _setUpMocksForMakeOpQueryMessageInvoke():String
		{
			var dbName:String = _setUpMockDB();

			_setUpMockMessageFactoryFindOneOpQueryMessageMethod(dbName);

			return dbName;
		}

		private function _setUpMockMessageFactoryFindOneOpQueryMessageMethod(dbName:String):void
		{
			_returnedOpQueryMessage = new OpQuery(0, testCollection, 0, 1, testQuery, testResultFieldsSelector);
			mock(mockedMessageFactory).method("makeFindOneOpQueryMessage").args(dbName, testCollection, testQuery, testResultFieldsSelector).returns(_returnedOpQueryMessage);
		}


		private function _setUpMockDB():String
		{
			const dbName:String = "testDB";
			mock(mockedDB).getter("name").returns(dbName);
			return dbName;
		}


		[Test]
		public function findOne_validInputs_socketWriteBytesInvoked():void
		{
			_setUpMocksForMakeOpQueryMessageInvoke();

			mock(mockedSocket).method("writeBytes").args(instanceOf(ByteArray));

			_wire.findOne(testCollection, testQuery, testResultFieldsSelector);

			assertThat(mockedSocket, received().method("writeBytes").arg(instanceOf(ByteArray)).once());
		}

		[Test]
		public function findOne_validInputs_socketFlushInvoked():void
		{
			_setUpMocksForMakeOpQueryMessageInvoke();

			mock(mockedSocket).method("flush").noArgs();

			_wire.findOne(testCollection, testQuery, testResultFieldsSelector);

			assertThat(mockedSocket, received().method("flush").noArgs().once());
		}

		[Test]
		public function findOne_validInputs_returnsSignalInstance():void
		{
			_setUpMocksForMakeOpQueryMessageInvoke();

			const signal:Signal = _wire.findOne(testCollection, testQuery, testResultFieldsSelector);

			assertTrue(signal is Signal);
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function findOne_socketNotConnected_throwsMongoError():void
		{
			_mockDisconnectedSocket();

			_wire.findOne(testCollection, testQuery, testResultFieldsSelector);
		}

		private function _mockDisconnectedSocket():void
		{
			mockedSocket = nice(Socket);
			mock(mockedSocket).getter("connected").returns(false);
			_wire.mockSocket = mockedSocket;
		}
	}
}
