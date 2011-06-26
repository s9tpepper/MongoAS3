package as3.mongo.wire.messages
{
	import flash.utils.ByteArray;

	public interface IMessage
	{
		function toByteArray():ByteArray;
	}
}
