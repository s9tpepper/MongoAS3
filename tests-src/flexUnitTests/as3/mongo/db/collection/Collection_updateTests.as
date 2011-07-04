package flexUnitTests.as3.mongo.db.collection
{
	import as3.mongo.db.DB;
	import as3.mongo.db.collection.Collection;
	import as3.mongo.db.document.Document;

	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;

	public class Collection_updateTests
	{
		[Rule]
		public var mocks:MockolateRule         = new MockolateRule();

		[Mock(inject = "true", type = "nice")]
		public var mockDB:DB;

		private var _testCollectionName:String = "aCollectionName";
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
		public function update_validInputs_updateInvokedOnDB():void
		{
			var selector:Document = new Document("selector:value");
			var modifier:Document = new Document("selector:newValue");

			_collection.update(selector, modifier);

			assertThat(mockDB, received().method("update").args(_testCollectionName, selector, modifier).once());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function update_invalidNullSelector_throwsError():void
		{
			_collection.update(null, new Document());
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function update_invalidNullModifier_throwsError():void
		{
			_collection.update(new Document(), null);
		}
	}
}
