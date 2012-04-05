package as3.mongo.wire {
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.IMessage;
	import as3.mongo.wire.messages.database.OpReply;
	import as3.mongo.wire.messages.database.OpReplyLoader;
	
	import com.transmote.utils.time.Timeout;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;

	public class RequestSequence extends EventDispatcher {
		private var query:IMessage;
		private var replyLoader:OpReplyLoader;
		private var socket:Socket;
		private var cursor:Cursor;
		
		public function RequestSequence (query:IMessage, replyLoader:OpReplyLoader, cursor:Cursor=null) {
			this.query = query;
			this.replyLoader = replyLoader;
			this.cursor = cursor;
			
			init();
		}
		
		public function begin (host:String, port:int) :void {
			if (!socket.connected) {
				socket.connect(host, port);
			} else {
				// force asynchronicity
				var beginTimeout:Timeout = new Timeout(beginSequence, 1);
			}
		}
		
		private function init () :void {
			initSocket();
		}
		
		
		
		//-----<REQUEST SEQUENCE>------------------------------------//
		private function beginSequence () :void {
			initReplyLoader();
			doQuery();
		}
		
		private function initReplyLoader () :void {
			replyLoader.initializeOpReplyLoader(socket);
			replyLoader.LOADED.addOnce(onReplyLoaded);
		}
		
		private function doQuery () :void {
			socket.writeBytes(query.toByteArray());
			socket.flush();
		}
		
		private function onReplyLoaded (reply:OpReply) :void {
			if (cursor) {
				cursor.onReplyLoaded(reply);
			}
			
			closeSocket();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		//-----</REQUEST SEQUENCE>-----------------------------------//
		
		
		
		//-----<SOCKET MANAGEMENT>-----------------------------------//
		private function initSocket () :void {
			socket = new Socket();
			socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketReady);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketReady);
			socket.addEventListener(Event.CONNECT, onSocketReady);
		}
		
		private function onSocketReady (evt:Event) :void {
			var socket:Socket = evt.target as Socket;
			if (!socket) { return; }
			socket.removeEventListener(IOErrorEvent.IO_ERROR, onSocketReady);
			socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketReady);
			socket.removeEventListener(Event.CONNECT, onSocketReady);
			
			if (evt is ErrorEvent) {
				dispatchEvent(evt);
				return;
			}
			
			beginSequence();
		}
		
		private function closeSocket () :void {
			try {
				socket.close();
			} catch (e:Error) {}
			
			socket = null;
		}
		//-----</SOCKET MANAGEMENT>----------------------------------//		
	}
}