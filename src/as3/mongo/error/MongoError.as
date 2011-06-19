package as3.mongo.error
{

	public class MongoError extends Error
	{
		public static const DATABASE_NAME_MUST_NOT_BE_NULL:String                                           = "The database name must not be null value.";
		public static const DATABASE_USERNAME_MAY_NOT_BE_NULL:String                                        = "The database username must not be a null value.";
		public static const DATABASE_PASSWORD_MAY_NOT_BE_NULL:String                                        = "The database password must not be a null value.";
		public static const CALL_SET_CREDENTIALS_BEFORE_AUTHENTICATE:String                                 = "The setCredentials method should be used before invoking authenticate().";
		public static const COLLECTION_NAME_MAY_NOT_BE_NULL_OR_EMPTY:String                                 = "The collection name may not be null or empty.";
		public static const NONCE_MUST_NOT_BE_NULL_OR_EMPTY:String                                          = "The nonce for authenticationDigest may not be null or empty.";
		public static const DOCUMENT_CONSTRUCTOR_ARGS_MUST_BE_COLON_SEPARATED_KEY_VALUE_STRING_PAIRS:String = "Arguments passed into the Document class must be string key:value pairs.";
		public static const DOCUMENT_CONSTRUCTOR_STRING_ARG_MUST_BE_COLON_SEPARATED:String                  = "One of the arguments passed into the Document constructor is not a key value pair separated by a colon.";
		public static const INVALID_OP_CODE:String                                                          = "The opCode used is invalid.";
		public static const QUERY_DOCUMENT_MAY_NOT_BE_NULL:String                                           = "The query Document object may not be null";
		public static const FIND_ONE_SOCKET_NOT_CONNECTED:String                                            = "The database.connect method must be used so a connection exists before calling findOne method.";
		public static const NOT_INSTANCE_CLASS:String                                                       = "This class is not meant to be instantiated.";
		public static const DOCUMENT_MUST_NOT_BE_NULL:String                                                = "The document instance may not be a null value.";

		public function MongoError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}
