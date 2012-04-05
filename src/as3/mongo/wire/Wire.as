package as3.mongo.wire
{
	import as3.mongo.db.DB;
	import as3.mongo.db.document.Document;
	import as3.mongo.error.MongoError;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.cursor.GetMoreMessage;
	import as3.mongo.wire.messages.IMessage;
	import as3.mongo.wire.messages.MessageFactory;
	import as3.mongo.wire.messages.client.FindOptions;
	import as3.mongo.wire.messages.client.OpDelete;
	import as3.mongo.wire.messages.client.OpGetMore;
	import as3.mongo.wire.messages.client.OpInsert;
	import as3.mongo.wire.messages.client.OpQuery;
	import as3.mongo.wire.messages.client.OpUpdate;
	import as3.mongo.wire.messages.database.FindOneOpReplyLoader;
	import as3.mongo.wire.messages.database.OpReply;
	import as3.mongo.wire.messages.database.OpReplyLoader;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	import org.serialization.bson.Int64;

	public class Wire {
		private var db:DB;
		private var messageFactory:MessageFactory;
		
		// for requests that just push bytes through the Socket and don't wait for a reply
		private var noReplySocket:Socket;
		private var pendingNoReplyMessages:Vector.<IMessage>;
		
		private var activeRequestSequences:Vector.<RequestSequence>;
		

		public function Wire (db:DB) {
			this.db = db;
			init();
		}
		
		
		//-----<REQUESTS>--------------------------------------------//
		//-----no-reply requests-----//
		public function insert (dbName:String, collectionName:String, document:Document) :void {
			const opInsert:OpInsert = messageFactory.makeSaveOpInsertMessage(dbName, collectionName, document);
			sendMessage(opInsert);
		}
		
		public function remove (dbName:String, collectionName:String, selector:Document) :void {
			const opDelete:OpDelete = messageFactory.makeRemoveOpDeleteMessage(dbName, collectionName, selector);
			sendMessage(opDelete);
		}
		
		public function updateFirst (dbName:String, collectionName:String, selector:Document, document:Document) :void {
			const opUpdate:OpUpdate = messageFactory.makeUpdateFirstOpUpdateMessage(dbName, collectionName, selector, document);
			sendMessage(opUpdate);
		}
		
		public function update (dbName:String, collectionName:String, selector:Document, modifier:Document) :void {
			const opUpdate:OpUpdate = messageFactory.makeUpdateOpUpdateMessage(dbName, collectionName, selector, modifier);
			sendMessage(opUpdate);
		}
		
		public function upsert (dbName:String, collectionName:String, selector:Document, document:Document) :void {
			const opUpdate:OpUpdate = messageFactory.makeUpsertOpUpdateMessage(dbName, collectionName, selector, document);
			sendMessage(opUpdate);
		}
		
		//-----request sequences-----//
		public function find (dbName:String, collectionName:String, query:Document, options:FindOptions=null) :Signal {
			if (null == options) {
				options = new FindOptions();
			}
			
			const opQuery:OpQuery = messageFactory.makeFindOpQueryMessage(dbName, collectionName, query, options);
			const opReplyLoader:OpReplyLoader = new OpReplyLoader();
			
			var cursor:Cursor = new Cursor();
			cursor.getMoreMessage = new GetMoreMessage(dbName, collectionName, options, this, cursor);
			
			launchRequestSequence(opQuery, opReplyLoader, cursor);
			
			return cursor.cursorReady;
		}
		
		public function findOne (collectionName:String, query:Document, returnFields:Document=null) :Signal {
			const opQuery:OpQuery = messageFactory.makeFindOneOpQueryMessage(db.name, collectionName, query, returnFields);
			const findOneOpReplyLoader:FindOneOpReplyLoader = new FindOneOpReplyLoader();
			launchRequestSequence(opQuery, findOneOpReplyLoader);

			return findOneOpReplyLoader.LOADED;
		}
		
		public function getMore (dbName:String, collectionName:String, options:FindOptions, cursorID:Int64) :Signal {
			const opGetMore:OpGetMore = messageFactory.makeGetMoreOpGetMoreMessage(dbName, collectionName, options.numberToReturn, cursorID);
			const opReplyLoader:OpReplyLoader = new OpReplyLoader();
			launchRequestSequence(opGetMore, opReplyLoader);
			
			return opReplyLoader.LOADED;
		}
		
		public function runCommand (command:Document) :Signal {
			const opQuery:OpQuery = messageFactory.makeRunCommandOpQueryMessage(db.name, "$cmd", command);
			const opReplyLoader:OpReplyLoader = new OpReplyLoader();
			launchRequestSequence(opQuery, opReplyLoader);
			
			return opReplyLoader.LOADED;
		}
		//-----</REQUESTS>-------------------------------------------//
		
		
		
		private function init () :void {
			initSocketResources();
			messageFactory = new MessageFactory();
			activeRequestSequences = new Vector.<RequestSequence>();
		}
		
		private function sendMessage (message:IMessage) :void {
			if (!noReplySocket.connected) {
				pendingNoReplyMessages.push(message);
				return;
			}
			
			noReplySocket.writeBytes(message.toByteArray());
			noReplySocket.flush();
		}
		
		private function launchRequestSequence (query:IMessage, replyLoader:OpReplyLoader, cursor:Cursor=null) :void {
			var rs:RequestSequence = new RequestSequence(query, replyLoader, cursor);
			
			rs.addEventListener(IOErrorEvent.IO_ERROR, onRequestSequenceComplete);
			rs.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onRequestSequenceComplete);
			rs.addEventListener(Event.COMPLETE, onRequestSequenceComplete);
			
			activeRequestSequences.push(rs);
			rs.begin(db.host, db.port);
		}
		
		private function onRequestSequenceComplete (evt:Event) :void {
			var rs:RequestSequence = evt.target as RequestSequence;
			if (!rs) { return; }
			
			rs.removeEventListener(IOErrorEvent.IO_ERROR, onRequestSequenceComplete);
			rs.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onRequestSequenceComplete);
			rs.removeEventListener(Event.COMPLETE, onRequestSequenceComplete);
			
			var i:int = activeRequestSequences.indexOf(rs);
			if (i != -1) {
				activeRequestSequences.splice(i, 1);
			}
			
			if (evt is IOErrorEvent) {
				db.connectionFailed.dispatch(db);
			} else if (evt is SecurityErrorEvent) {
				db.socketPolicyFileError.dispatch(db);
			}
		}
		
		private function initSocketResources () :void {
			pendingNoReplyMessages = new Vector.<IMessage>();
			
			noReplySocket = new Socket();
			noReplySocket.addEventListener(IOErrorEvent.IO_ERROR, onSocketReady);
			noReplySocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketReady);
			noReplySocket.addEventListener(Event.CONNECT, onSocketReady);
			noReplySocket.connect(db.host, db.port);
		}
		
		private function onSocketReady (evt:Event) :void {
			noReplySocket.removeEventListener(IOErrorEvent.IO_ERROR, onSocketReady);
			noReplySocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketReady);
			noReplySocket.removeEventListener(Event.CONNECT, onSocketReady);
			
			if (evt is IOErrorEvent) {
				db.connectionFailed.dispatch(db);
				return;
			} else if (evt is SecurityErrorEvent) {
				db.socketPolicyFileError.dispatch(db);
				return;
			}
			
			for (var i:int=0; i<pendingNoReplyMessages.length; i++) {
				sendMessage(pendingNoReplyMessages[i]);
			}
			pendingNoReplyMessages = null;
		}
	}
}