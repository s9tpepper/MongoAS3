package flexUnitTests.as3.mongo.db.collection
{
	import as3.mongo.db.DB;
	import as3.mongo.db.collection.Collection;
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.client.FindOptions;
	import as3.mongo.wire.messages.client.OpQueryFlags;
	import as3.mongo.wire.messages.database.OpReplyLoader;

	import flash.net.Socket;

	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.osflash.signals.Signal;

	public class Collection_findTests
	{
		[Rule]
		public var mocks:MockolateRule        = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockDB:DB;

		private var testCollectionName:String = "aCollection";
		private var _collection:Collection;

		[Before]
		public function setUp():void
		{
			_collection = new Collection(testCollectionName, mockDB);
		}

		[After]
		public function tearDown():void
		{
			_collection = null;
		}

		[Test]
		public function find_validInputs_findInvokedOnDB():void
		{
			var testDoc:Document        = new Document("hello:world");
			var findOptions:FindOptions = new FindOptions();
			_collection.find(testDoc, findOptions);

			assertThat(mockDB, received().method("find").args(testCollectionName, testDoc, findOptions).once());
		}

		[Test]
		public function find_validInputs_returnsSignal():void
		{
			var testDoc:Document        = new Document("hello:world");
			var findOptions:FindOptions = new FindOptions();
			mock(mockDB).method("find").returns(new Signal(Cursor));

			const signal:Signal         = _collection.find(testDoc, findOptions);

			assertTrue(signal is Signal);
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function find_nullQueryDocument_throwsError():void
		{
			_collection.find(null, new FindOptions());
		}
	}
}
