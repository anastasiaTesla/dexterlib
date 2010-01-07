package controllers
{
	import flash.net.SharedObject;
	
	import models.LocalSetting;
	import models.vo.UserVO;

	public class VideoController
	{
		[DexterBinding(model="server",property="initSO")]
		public var initSO:SharedObject;
		[DexterBinding]
		public var localSetting:LocalSetting;
		[DexterEvent]
		public function publishUserVideo(user:UserVO):void{
			if(user.id == initSO.data["publisher"]){
			}else{
				initSO.setProperty("publisher",user.id);
			}
		}
		[DexterEvent]
		public function initSOchange_publisher(id:String):void{
			var user:UserVO = sendDexterEvent("getUserByID",id);
			if(!user)return;
			sendDexterEvent("publishOutStream",user);
			sendDexterEvent("setVideo",id);
			sendDexterEvent("tip_dockVideo",id);
		}
		[DexterEvent]
		public function initSOsuccess_publisher(id:String):void{
			initSOchange_publisher(id);
		}
	}
}