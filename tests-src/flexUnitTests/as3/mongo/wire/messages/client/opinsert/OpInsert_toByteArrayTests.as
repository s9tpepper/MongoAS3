package flexUnitTests.as3.mongo.wire.messages.client.opinsert
{
	import as3.mongo.wire.messages.client.OpInsert;

	import flash.utils.ByteArray;

	import org.flexunit.asserts.assertTrue;

	public class OpInsert_toByteArrayTests
	{

		private var _opInsert:OpInsert;
		private var _testFlags:Number          = 8;
		private var _testCollectionName:String = "dbname.collectionname";

		[Before]
		public function setUp():void
		{
			_opInsert = new OpInsert(_testFlags, _testCollectionName);
		}

		[After]
		public function tearDown():void
		{
			_opInsert = null;
		}

		[Test]
		public function toByteArray_allScenarios_returnsByteArrayInstance():void
		{
			assertTrue(_opInsert.toByteArray() is ByteArray);
		}
	}
}
