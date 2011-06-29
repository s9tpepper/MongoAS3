package as3.mongo.db
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.database.OpReply;

	import mx.utils.ObjectUtil;

	public class Authentication
	{
		private const _NONCE_QUERY:Document = new Document("getnonce:1");
		private var _db:DB;

		// FIXME: I have to store a reference to this cursor or the call dies. Create an active cursors array?
		private var _nonceCursor:Cursor;

		public function Authentication(aDB:DB)
		{
			trace("Authentication()");
			_initializeAuthentication(aDB);
		}

		private function _initializeAuthentication(aDB:DB):void
		{
			_db = aDB;
			_getNonce();
		}

		private function _getNonce():void
		{
			trace("_NONCE_QUERY = " + ObjectUtil.toString(_NONCE_QUERY));

			// FIXME: Need to get rid of having to keep a ref. of the Cursor?
			_nonceCursor = _db.wire.findOne("$cmd", _NONCE_QUERY, null, _readNonceResponse);

			trace("_getNonce()");
		}

		private function _readNonceResponse(opReply:OpReply):void
		{
			trace("_readNonceResponse()");
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
			trace("_finishAuthentication()");
			trace("nonce = " + nonce);
			const digest:String        = _db.credentials.getAuthenticationDigest(nonce);
			const authCommand:Document = new Document("authenticate:1", "user:" + _db.credentials.username, "nonce:" + nonce, "key:" + digest);

			// FIXME: Same as _getNonce() method, need to get rid of having to keep a ref. of the Cursor?
			_nonceCursor = _db.wire.runCommand(authCommand, _readAuthCommandReply);
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
