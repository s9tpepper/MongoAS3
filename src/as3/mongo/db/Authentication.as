package as3.mongo.db
{
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.messages.database.OpReply;

	public class Authentication
	{
		private const _NONCE_QUERY:Document = new Document("getnonce:1");
		private var _db:DB;
		private var _nonceCursor:Cursor;

		public function Authentication(aDB:DB)
		{
			_initializeAuthentication(aDB);
		}

		private function _initializeAuthentication(aDB:DB):void
		{
			_db = aDB;
			_getNonce();
		}

		private function _getNonce():void
		{
			_nonceCursor = _db.wire.findOne("$cmd", _NONCE_QUERY, null, _readNonceResponse);
		}

		private function _readNonceResponse(opReply:OpReply):void
		{
			if (_authOpReplyIsSuccessful(opReply))
				_finishAuthentication(opReply.documents[0].nonce);
			else
				_db.AUTHENTICATION_PROBLEM.dispatch(_db);
		}

		private function _authOpReplyIsSuccessful(opReply:OpReply):Boolean
		{
			return 1 == opReply.numberReturned && opReply.documents[0].ok == 1;
		}

		private function _finishAuthentication(nonce:String):void
		{
			const digest:String        = _db.credentials.getAuthenticationDigest(nonce);
			const authCommand:Document = new Document("authenticate:1", "user:" + _db.credentials.username, "nonce:" + nonce, "key:" + digest);
			_db.wire.runCommand(authCommand, _readAuthCommandReply);
		}

		private function _readAuthCommandReply(opReply:OpReply):void
		{
			if (_authOpReplyIsSuccessful(opReply))
				_db.AUTHENTICATED.dispatch(_db);
			else
				_db.AUTHENTICATION_PROBLEM.dispatch(_db);
		}
	}
}
