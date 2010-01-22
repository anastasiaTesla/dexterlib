package controllers
{
	import flash.events.Event;
	
	import models.LocalSetting;
	import models.vo.ChatMsgVO;
	import models.vo.UserVO;
	
	import views.ChatWindow;

	public class ChatController
	{
		[DexterBinding]
		public var localSetting:LocalSetting;
		[DexterEvent]
		public function sendChat(content:ChatMsgVO,user:UserVO):void{
			if(user == UserVO.all){
				sendDexterEvent("sendToOthers","chat",content,UserVO.self.id);
			}else{
				sendDexterEvent("sendToUser",user,"chatPrivate",content,UserVO.self.id);
			}
		}
//		[DexterEvent]
//		public function tip_dockVideo(id:String):void{
//			var user:UserVO = sendDexterEvent("getUserByID",id);
//			if(user)sendDexterEvent("$chat","“"+user.name+"”已经上了视频","系统提示");
//		}
//		[DexterEvent]
//		public function userOnline(user:UserVO):void{
//			sendDexterEvent("$chat","“"+user.name+"”上线","系统提示");
//		}
//		[DexterEvent]
//		public function userOffline(user:UserVO):void{
//			sendDexterEvent("$chat","“"+user.name+"”已经下线","系统提示");
//		}
		[DexterEvent]
		public function $chatPrivate(content:Object,from:String):void{
			var chatVO:ChatMsgVO = new ChatMsgVO(content);
			chatVO.time = new Date().toLocaleTimeString();
			var userVO:UserVO = sendDexterEvent("getUserByID",from);
			if(userVO){
				userVO.messages.push(chatVO);
				if(localSetting.autoPopUpChat){
					ChatWindow.Open(userVO.id);
				}else{
					var chatWindow:ChatWindow = ChatWindow.GetWindow(userVO.id);
					if(chatWindow){
						chatWindow.checkMessage();
					}else{
						userVO.dispatchEvent(new Event("msgLengthChange"));
					}
				}
			}
		}
		[DexterEvent]
		public function $chat(content:Object,from:String):void{
			$chatPrivate(content,UserVO.all.id);
		}
		[DexterEvent]
		public function chatToUser(userVO:UserVO):void{
			if(userVO != UserVO.self)
			var chatWindow:ChatWindow = ChatWindow.Open(userVO.id);
		}
	}
}