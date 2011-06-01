package as3.mongo.wire.messages
{
	public class OpCodes
	{
		static public const OP_REPLY:int = 1;
		static public const OP_MSG:int = 1000;
		static public const OP_UPDATE:int = 2001;
		static public const OP_INSERT:int = 2002;
		static public const RESERVED:int = 2003;
		static public const OP_QUERY:int = 2004;
		static public const OP_GET_MORE:int = 2005;
		static public const OP_DELETE:int = 2006;
		static public const OP_KILL_CURSORS:int = 2007;
		
		
		public function OpCodes()
		{
		}
	}
}