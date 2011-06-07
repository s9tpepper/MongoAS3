package flexUnitTests.as3.mongo.wire.cursor
{
	import flash.net.Socket;
	
	public class TestSocket extends Socket
	{
		public function TestSocket(host:String=null, port:int=0)
		{
			super(host, port);
		}
		
		public override function readInt():int
		{
			return 250;
		}
	}
}