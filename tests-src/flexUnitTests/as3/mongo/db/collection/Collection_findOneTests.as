package flexUnitTests.as3.mongo.db.collection
{
	import as3.mongo.db.DB;
	import as3.mongo.db.collection.Collection;
	import as3.mongo.db.document.Document;
	
	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	
	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;

	public class Collection_findOneTests
	{		
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock(inject="true", type="nice")]
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
			const testCallback:Function = function():void {};
			mock(mockDB).method("findOne").args(_collection.name, instanceOf(Document), instanceOf(Document), testCallback);
			
			_collection.findOne(new Document(), new Document(), testCallback);
			
			assertThat(mockDB, received().method("findOne").args(_collection.name, instanceOf(Document), instanceOf(Document), testCallback));
		}
	}
}