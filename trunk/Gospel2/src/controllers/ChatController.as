package controllers
{
	import models.vo.UserVO;
	
	import views.ChatWindow;

	public class ChatController
	{
		
		[DexterEvent]
		public function sendChat(content:String,user:UserVO = null):void{
			if(user){
				sendDexterEvent("sendToUser",user,"chatPrivate",content,UserVO.self.id);
			}else{
				sendDexterEvent("broadcast","chat",content,UserVO.self.id);
			}
		}
		[DexterEvent]
		public function tip_dockVideo(id:String):void{
			var user:UserVO = sendDexterEvent("getUserByID",id);
			if(user)sendDexterEvent("$chat","“"+user.name+"”已经上了视频","系统提示");
		}
		[DexterEvent]
		public function userOnline(user:UserVO):void{
			sendDexterEvent("$chat","“"+user.name+"”上线","系统提示");
		}
		[DexterEvent]
		public function userOffline(user:UserVO):void{
			sendDexterEvent("$chat","“"+user.name+"”已经下线","系统提示");
		}
		[DexterEvent]
		public function $chatPrivate(content:String,from:String):void{
			
		}
		[DexterEvent]
		public function $chat(content:String,from:String):void{
			
		}
	}
}