package as3.mongo.wire.messages.client
{

	public class OpUpdateFlags
	{
		static public const NO_FLAGS:int = 0;
		static public const UPSERT:int   = 1;
		static public const MULTI:int    = 2;

		public function OpUpdateFlags()
		{
		}
	}
}
