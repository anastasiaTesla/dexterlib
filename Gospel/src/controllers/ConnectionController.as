package controllers
{
	import models.ServerConnection;
	import models.StratusConnection;

	public class ConnectionController
	{
		[DexterBinding]
		public var server:ServerConnection;
		[DexterBinding]
		public var stratus:StratusConnection;
		public function ConnectionController()
		{
		}
		[DexterEvent]
		public function ConnectServer():void{
			stratus.Connect();
		}
		[DexterEvent]
		public function StratusConnectSuccess():void{
			server.Connect(stratus.nearID);
		}
	}
}