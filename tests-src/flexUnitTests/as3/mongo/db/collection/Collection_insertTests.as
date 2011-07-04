package flexUnitTests.as3.mongo.db.collection
{
	import as3.mongo.db.DB;
	import as3.mongo.db.collection.Collection;
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.cursor.Cursor;

	import flash.net.Socket;

	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.instanceOf;

	public class Collection_insertTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockDB:DB;

		private var _collection:Collection;

		[Before]
		public function setUp():void
		{
			_collection = new Collection("testCollection", mockDB);
		}

		[After]
		public function tearDown():void
		{
			_collection = null;
		}

		[Test]
		public function insert_inputIsDocumentInstance_saveInvokedOnDB():void
		{
			const testDocument:Document = new Document();

			_collection.insert(testDocument);

			assertThat(mockDB, received().method("insert").args(_collection.name, testDocument).once());
		}


		[Test(expects = "as3.mongo.error.MongoError")]
		public function insert_inputIsNull_throwsError():void
		{
			_collection.insert(null);
		}
	}
}
