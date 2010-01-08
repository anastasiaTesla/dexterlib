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
		public var stratus:StratusConnection;
		[DexterEvent]
		public function ConnectServer():void{
			UserVO.self.name = localSetting.userName;
			UserVO.self.role = localSetting.role;
			stratus.connect(gospelModel.connectUrl+"/"+gospelModel.developerKey+"/"+localSetting.room);
		}
	}
}