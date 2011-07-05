package as3.mongo.wire.messages.client
{

	public class OpQueryFlags
	{
		static public const NONE:int              = 0;
		static public const TAILABLE_CURSOR:int   = 2;
		static public const SLAVE_OK:int          = 4;
		static public const NO_CURSOR_TIMEOUT:int = 16;
		static public const AWAIT_DATA:int        = 32;
		static public const EXHAUST:int           = 64;
		static public const PARTIAL:int           = 128;

		public function OpQueryFlags()
		{
		}
	}
}
