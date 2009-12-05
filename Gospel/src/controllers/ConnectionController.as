package controllers
{
	import models.GospelModel;
	import models.LocalSetting;
	import models.ServerConnection;
	import models.StratusConnection;
	import models.vo.UserVO;

	public class ConnectionController
	{
		[DexterBinding]
		public var localSetting:LocalSetting;
		[DexterBinding]
		public var gospelModel:GospelModel;
		[DexterBinding]
		public var server:ServerConnection;
		[DexterBinding]
		public var stratus:StratusConnection;
		[Bindable]
		public var self:UserVO = new UserVO();
		[DexterEvent]
		public function ConnectServer():void{
			self.name = localSetting.userName;
			self.role = localSetting.role;
			stratus.connect(gospelModel.connectUrl+"/"+gospelModel.developerKey+"/"+localSetting.room);
		}
		[DexterEvent]
		public function StratusConnectSuccess():void{
			self.id = stratus.nearID;
			server.Connect(self);
		}
	}
}