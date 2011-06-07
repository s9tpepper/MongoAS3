package flexUnitTests.as3.mongo.wire
{
	import as3.mongo.db.DB;
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.Wire;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.cursor.CursorFactory;
	import as3.mongo.wire.messages.MessageFactory;
	import as3.mongo.wire.messages.client.OpQuery;
	
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	
	import org.bson.BSONEncoder;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.text.re;

	public class Wire_findOneTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock(inject="true", type="nice")]
		public var mockedDB:DB;
		
		[Mock(inject="true", type="nice")]
		public var mockedMessageFactory:MessageFactory;
		
		[Mock(inject="true", type="nice")]
		public var mockedSocket:Socket;
		
		[Mock(inject="true", type="nice")]
		public var mockedCursorFactory:CursorFactory;
		
		private var _wire:TestWire;
		private var readAllDocumentsCallback:Function = function():void{};
		private var testResultFieldsSelector:Document = new Document();
		private var testQuery:Document = new Document("getNonce:1");
		private var testCollection:String = "aCollection";
		private var _returnedOpQueryMessage:OpQuery;
		
		[Before]
		public function setUp():void
		{
			mock(mockedSocket).method("toString").returns("[object MockedSocket]");
			
			_wire = new TestWire(mockedDB);
			_wire.mockMessageFactory = mockedMessageFactory;
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
			
			_wire.findOne(testCollection, testQuery, testResultFieldsSelector, readAllDocumentsCallback);
			
			assertThat(mockedMessageFactory, received().method("makeFindOneOpQueryMessage")
													   .args(dbName,
														  	 testCollection,
														  	 testQuery,
														  	 testResultFieldsSelector)
													   .once());
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
			mock(mockedMessageFactory).method("makeFindOneOpQueryMessage")
									  .args(dbName,
										    testCollection,
										    testQuery,
										    testResultFieldsSelector)
									  .returns(_returnedOpQueryMessage);
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
			
			_wire.findOne(testCollection, testQuery, testResultFieldsSelector, readAllDocumentsCallback);
			
			assertThat(mockedSocket, received().method("writeBytes").arg(instanceOf(ByteArray)).once());
		}
		
		[Test]
		public function findOne_validInputs_socketFlushInvoked():void
		{
			_setUpMocksForMakeOpQueryMessageInvoke();
			
			mock(mockedSocket).method("flush").noArgs();
			
			_wire.findOne(testCollection, testQuery, testResultFieldsSelector, readAllDocumentsCallback);
			
			assertThat(mockedSocket, received().method("flush").noArgs().once());
		}
		
		[Test]
		public function findOne_validInputs_cursorFactoryGetCursorInvoked():void
		{
			_setUpMocksForMakeOpQueryMessageInvoke();
			mock(mockedCursorFactory).method("getCursor").args(mockedSocket);
			_wire.mockCursorFactory = mockedCursorFactory;
			
			_wire.findOne(testCollection, testQuery, testResultFieldsSelector, readAllDocumentsCallback);
			
			assertThat(mockedCursorFactory, received().method("getCursor").args(mockedSocket).once());
		}
		
		[Test]
		public function findOne_validInputs_returnsCursorInstance():void
		{
			_setUpMocksForMakeOpQueryMessageInvoke();
			
			const cursor:Cursor = _wire.findOne(testCollection, testQuery, testResultFieldsSelector, readAllDocumentsCallback);
			
			assertTrue(cursor is Cursor);
		}
	}
}