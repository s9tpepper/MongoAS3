package flexUnitTests.as3.mongo.db.collection
{
	import as3.mongo.db.DB;
	import as3.mongo.db.collection.Collection;
	
	import asx.array.inject;
	
	import mockolate.runner.MockolateRule;
	
	import org.flexunit.asserts.assertEquals;

	public class Collection_ConstructorTests
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
		public function Collection_onInstantiation_constructorArgumentsAreStored():void
		{
			assertConstructorArgumentsStored();
		}
		
		private function assertConstructorArgumentsStored():void
		{
			assertEquals(testCollectionName, _collection.name);
			assertEquals(mockDB, _collection.db);
		}
		
		
	}
}