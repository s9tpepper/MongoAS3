package flexUnitTests.as3.mongo.wire.messages.client.opinsert
{
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;
	import as3.mongo.wire.messages.client.OpInsert;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	public class OpInsert_addDocumentTests
	{

		private var _mongoError:MongoError;
		private var _opInsert:OpInsert;
		private var _testFlags:Number          = 8;
		private var _testCollectionName:String = "dbname.collectionname";
		private var _testDocument:Document     = new Document();

		[Before]
		public function setUp():void
		{
			_opInsert = new OpInsert(_testCollectionName);
		}

		[After]
		public function tearDown():void
		{
			_opInsert = null;
		}

		[Test]
		public function addDocument_aDocumentInstance_documentsContainsInstance():void
		{
			_opInsert.addDocument(_testDocument);

			assertTrue(_opInsert.containsDocument(_testDocument));
		}

		[Test]
		public function addDocument_aDocumentInstance_totalDocumentsIsOneMoreThanItWas():void
		{
			const totalDocumentsBefore:uint = _opInsert.totalDocuments;

			_opInsert.addDocument(_testDocument);

			assertEquals(totalDocumentsBefore + 1, _opInsert.totalDocuments);
		}

		[Test(expects = "as3.mongo.error.MongoError")]
		public function addDocument_aNullInstance_throwsMongoError():void
		{
			_opInsert.addDocument(null);
		}
	}
}
