package flexUnitTests.as3.mongo.db.collection
{
	import as3.mongo.db.DB;
	import as3.mongo.db.collection.Collection;
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.database.FindOneResult;

	import flash.net.Socket;

	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.instanceOf;
	import org.osflash.signals.Signal;

	public class Collection_findOneTests
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
		public function findOne_allScenarios_dbFindOneInvoked():void
		{
			_mockFindOneMethod();

			_collection.findOne(new Document(), new Document());

			assertThat(mockDB, received().method("findOne").args(_collection.name, instanceOf(Document), instanceOf(Document)));
		}

		[Test]
		public function findOne_allScenarios_returnsSignal():void
		{
			_mockFindOneMethod();

			const signal:Signal = _collection.findOne(new Document(), new Document());

			assertTrue(signal is Signal);
		}

		private function _mockFindOneMethod():void
		{
			mock(mockDB).method("findOne").args(_collection.name, instanceOf(Document), instanceOf(Document)).returns(new Signal(FindOneResult));
		}
	}
}
