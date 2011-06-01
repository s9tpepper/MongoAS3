package flexUnitTests.as3.mongo.db.document
{
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;
	
	import org.flexunit.asserts.assertEquals;

	public class Document_ConstructorTests
	{		
		private var _document:Document;
		
		[Test]
		public function Document_noConstructorArguments_totalFieldsIsZero():void
		{
			_document = new Document();
			
			assertEquals(0, _document.totalFields);
		}
		
		[Test]
		public function Document_constructorHasOneOrMoreColonSeparatedStringArguments_totalFieldsIsCorrect():void
		{
			_document = new Document("field1:value1", "field2:value2");
			
			assertEquals(2, _document.totalFields);
		}
		
		
		[Test]
		public function Document_twoColonSeparatedKeyValuePairs_keyAndValuesInCorrectIndex():void
		{
			_document = new Document("field1:value1", "field2:value2");
			
			assertFieldsAreInCorrectIndex();
		}
		private function assertFieldsAreInCorrectIndex():void
		{
			assertEquals("field1", _document.getKeyAt(0));
			assertEquals("value1", _document.getValueAt(0));
			assertEquals("field2", _document.getKeyAt(1));
			assertEquals("value2", _document.getValueAt(1));
		}
		
		
		[Test(expects="as3.mongo.error.MongoError")]
		public function Document_aConstructorArgumentIsNotAString_throwsError():void
		{
			var error:MongoError;
			
			_document = new Document("field:value", 234);
		}
		
		[Test(expects="as3.mongo.error.MongoError")]
		public function Document_constructorHasStringArgumentWithoutColonSeparator_throwsMongoError():void
		{
			_document = new Document("field1:value1", "field2");
		}
	}
}