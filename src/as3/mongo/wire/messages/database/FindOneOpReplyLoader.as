package as3.mongo.wire.messages.database
{
	import flash.net.Socket;

	import org.osflash.signals.Signal;

	public class FindOneOpReplyLoader extends OpReplyLoader
	{
		public function FindOneOpReplyLoader(aSocket:Socket)
		{
			super(aSocket);
		}

		override protected function _initializeOpReplyLoader(aSocket:Socket):void
		{
			super._initializeOpReplyLoader(aSocket);

			_LOADED = new Signal(FindOneResult);
		}

		override protected function _dispatchLoadedSignal():void
		{
			const opReply:OpReply = new OpReply(_currentReplyLength, socket);
			_LOADED.dispatch(new FindOneResult((opReply.numberReturned == 1), opReply.documents[0]));
		}
	}
}
