package as3.mongo.db
{

	public class AuthenticationFactory
	{
		public function AuthenticationFactory()
		{
		}

		public function getAuthentication(db:DB):Authentication
		{
			return new Authentication(db);
		}
	}
}
