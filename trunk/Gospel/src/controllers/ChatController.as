package controllers
{
	import flash.net.SharedObject;
	
	import models.vo.UserVO;

	public class ChatController
	{
		[DexterEvent]
		public function sendChat(content:String):void{
			sendDexterEvent("broadcast","receiveChat",content,UserVO.self.id);
		}
	}
}