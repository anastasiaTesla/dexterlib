package controllers
{
	import flash.net.SharedObject;

	public class ChatController
	{
		[DexterBinding(model="server",property="userListSO")]
		public var userListSO:SharedObject;
		[DexterBinding]
		public var connectionController:ConnectionController;
		[DexterEvent]
		public function sendChat(content:String):void{
			userListSO.send("receiveChat",content,connectionController.self.id);
		}
	}
}