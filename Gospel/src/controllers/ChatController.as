package controllers
{
	import models.vo.UserVO;

	public class ChatController
	{
		[DexterEvent]
		public function sendChat(content:String):void{
			sendDexterEvent("broadcast","receiveChat",content,UserVO.self.id);
		}
		[DexterEvent]
		public function tip_dockVideo(id:String):void{
			var user:UserVO = sendDexterEvent("getUserByID",id);
			sendDexterEvent("receiveChat","“"+user.name+"”已经上了视频","系统提示");
		}
		[DexterEvent]
		public function userOnline(user:UserVO):void{
			sendDexterEvent("receiveChat","“"+user.name+"”上线","系统提示");
		}
		[DexterEvent]
		public function userOffline(user:UserVO):void{
			sendDexterEvent("receiveChat","“"+user.name+"”已经下线","系统提示");
		}
	}
}