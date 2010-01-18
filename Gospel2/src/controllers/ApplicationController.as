package controllers
{
	
	import flash.net.SharedObject;
	import flash.text.TextField;
	
	import models.GospelModel;
	import models.LocalSetting;
	import models.StratusConnection;
	import models.vo.UserVO;
	
	import views.ChangeNickWindow;
	import views.FloatInfo;
	import views.WaitWindow;

	public class ApplicationController
	{
		[DexterBinding]
		public var gospelModel:GospelModel;
		[DexterBinding]
		public var localSetting:LocalSetting;
		[DexterBinding(model="server",property="userListSO")]
		public var userListSO:SharedObject;
		[DexterBinding]
		public var stratus:StratusConnection;
		[DexterEvent]
		public function appStart():void{
			gospelModel.loadConfig();
//			gospelModel.lookIp();
			localSetting.initCamera();
		}
		[DexterEvent]
		public function configComplete():void{
			gospelModel.selectedRoom = gospelModel.roomList.source.(@code == localSetting.room)[0];
			if(localSetting.autoLogin){
				login();
			}
		}
		[DexterEvent]
		public function enterRoom(room:XML,userName:String):void{
			var test:TextField = new TextField();
			test.text = userName;
			if(test.textWidth>50){
				FloatInfo.show("昵称太长");
				return;
			}
			gospelModel.selectedRoom = room;
			localSetting.userName = userName;
			localSetting.room = room.@code;
			if(localSetting.pwd == room.@pwd){
				localSetting.role = UserVO.ADMIN;
				login();
			}else if(!localSetting.pwd){
				localSetting.role = UserVO.GUEST;
				login();
			}else{
				FloatInfo.show("密码错误！");
			}
		}
		private function login():void{
			WaitWindow.wait("进入房间");
			UserVO.self.name = localSetting.userName;
			UserVO.self.role = localSetting.role;
			stratus.connect(gospelModel.connectUrl+"/"+gospelModel.developerKey+"/"+localSetting.room);
		}
		[DexterEvent]
		public function changeNick(user:UserVO):void{
			ChangeNickWindow.show(user);
		}
		[DexterEvent]
		public function kickUser(user:UserVO):void{
			sendDexterEvent("broadcast","kickUser",user.id);
		}
		[DexterEvent]
		public function $kickUser(id:String):void{
			if(UserVO.self.id == id)exitRoom();
		}
		[DexterEvent]
		public function exitRoom():void{
			
		}
		[DexterEvent]
		public function sendChangeNick(id:String,newName:String):void{
			var user:UserVO = sendDexterEvent("getUserByID",id) as UserVO;
			user.name = newName;
			userListSO.setProperty(id,user);
			sendDexterEvent("broadcast","changeNick",id,newName);
		}
		[DexterEvent]
		public function $changeNick(id:String,newName:String):void{
			var user:UserVO = sendDexterEvent("getUserByID",id) as UserVO;
			user.name = newName;
			if(user.isSelf){
				localSetting.userName = newName;
				sendDexterEvent("$chat","你的昵称已经被管理员修改，新昵称："+newName,"系统消息");
			}
		}
	}
}