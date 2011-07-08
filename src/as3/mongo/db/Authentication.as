package as3.mongo.db
{
	import as3.mongo.db.document.Document;
	import as3.mongo.wire.cursor.Cursor;
	import as3.mongo.wire.messages.database.FindOneResult;
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
			_initializeAuthentication(aDB);
		}

		private function _initializeAuthentication(aDB:DB):void
		{
			_db = aDB;
			_getNonce();
		}

		private function _getNonce():void
		{
			trace("_getNonce()");
			_db.wire.findOne("$cmd", _NONCE_QUERY).addOnce(_readNonceResponse);
		}

		private function _readNonceResponse(findOneResult:FindOneResult):void
		{
			trace("_readNonceResponse()");
			trace("findOneResult = " + ObjectUtil.toString(findOneResult));
			if (findOneResult.success)
				_finishAuthentication(findOneResult.document.nonce);
			else
				_db.authenticationProblem.dispatch(_db);
		}

		private function _finishAuthentication(nonce:String):void
		{
			const digest:String        = _db.credentials.getAuthenticationDigest(nonce);
			const authCommand:Document = new Document();
			authCommand.put("authenticate", "1");
			authCommand.put("user", _db.credentials.username);
			authCommand.put("nonce", nonce);
			authCommand.put("key", digest);

			_db.wire.runCommand(authCommand).addOnce(_readAuthCommandReply);
		}

		private function _readAuthCommandReply(opReply:OpReply):void
		{
			if (opReply.documents[0] && opReply.documents[0].ok == 1)
				_db.authenticated.dispatch(_db);
			else
				_db.authenticationProblem.dispatch(_db);
		}
	}
}
