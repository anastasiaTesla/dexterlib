package gospel.controllers
{
	import com.adobe.rtc.session.ConnectSession;
	
	import gospel.models.GospelModel;
	import gospel.models.LocalSetting;
	import gospel.views.WaitWindow;

	public class ApplicationController
	{
		[DexterBinding]
		public var gospelModel:GospelModel;
		[DexterBinding]
		public var localSetting:LocalSetting;
		[DexterBinding]
		public var connectSession:ConnectSession;
		[DexterEvent]
		public function appStart():void{
			gospelModel.loadConfig();
			WaitWindow.wait("加载配置文件");
		}
		[DexterEvent]
		public function configComplete():void{
			WaitWindow.waitThingDone("加载配置文件");
			if(localSetting.autoLogin){
				login();
			}
		}
		[DexterEvent]
		public function enterRoom(room:String,userName:String,pwd:String):void{
			localSetting.userName = userName;
			localSetting.pwd = pwd;
			localSetting.room = room;
			if(connectSession.isSynchronized)connectSession.logout();
			login();
		}
		private function login():void{
			WaitWindow.wait("进入房间");
			connectSession.roomURL = gospelModel.roomURL + localSetting.room;
			connectSession.login();
		}
	}
}