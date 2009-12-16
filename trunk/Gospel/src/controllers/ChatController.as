package controllers
{
	import flash.net.SharedObject;
	
	import models.vo.UserVO;

	public class ChatController
	{
		[DexterBinding(model="server",property="userListSO")]
		public var userListSO:SharedObject;
		[DexterEvent]
		public function sendChat(content:String):void{
			userListSO.send("receiveChat",content,UserVO.self.id);
		}
	}
}