package org.bson
{
	import flash.utils.ByteArray;
	
	import org.serialization.bson.BSON;

	public class BSONDecoder
	{
		public function BSONDecoder()
		{
		}
		
		public function decode(byteArray:ByteArray):Object
		{
			return BSON.decode(byteArray);
		}
	}
}