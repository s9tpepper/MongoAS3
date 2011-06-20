package org.bson
{
	import as3.mongo.db.document.Document;

	import flash.utils.ByteArray;

	import org.serialization.bson.BSON;

	public class BSONEncoder
	{
		public function BSONEncoder()
		{
		}

		public function encode(document:Document):ByteArray
		{
			return BSON.encode(document);
		}
	}
}