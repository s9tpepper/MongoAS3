package flexUnitTests.as3.mongo.db.collection
{
	import as3.mongo.db.DB;
	import as3.mongo.db.collection.Collection;
	import as3.mongo.db.document.Document;

	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;

	public class Collection_updateFirstTests
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockDB:DB;

		private var _testCollectionName:String;
		private var _collection:Collection;

		[Before]
		public function setUp():void
		{
			_collection = new Collection(_testCollectionName, mockDB);
		}

		[After]
		public function tearDown():void
		{
			_collection = null;
		}

		[Test]
		public function updateFirst_validSelectorAndUpdateDocumentInstances_updateFirstInvokedOnDB():void
		{
			const testSelector:Document = new Document();
			const testUpdate:Document   = new Document();
			_collection.updateFirst(testSelector, testUpdate);

			assertThat(mockDB, received().method("updateFirst").args(_testCollectionName, testSelector, testUpdate).once());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function updateFirst_selectorIsNull_throwsError():void
		{
			_collection.updateFirst(null, new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function updateFirst_updateIsNull_throwsError():void
		{
			_collection.updateFirst(new Document(), null);
		}
	}
}
