package as3.mongo.wire.messages
{
	import flash.utils.ByteArray;

	public interface IMessage
	{
		function toByteArray():ByteArray;
		
		function get requestID():int;
		
		function get responseTo():int;
		
		function get opCode():int;
		
		function set requestID(value:int):void;
		
		function set responseTo(value:int):void;
		
		function set opCode(value:int):void;
	}
}