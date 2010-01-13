package controllers
{
	
	import flash.net.SharedObject;
	
	import models.GospelModel;
	import models.LocalSetting;
	import models.vo.UserVO;
	
	import mx.controls.Alert;
	
	import views.ChangeNickWindow;
	import views.WaitWindow;

	public class ApplicationController
	{
		[DexterBinding]
		public var gospelModel:GospelModel;
		[DexterBinding]
		public var localSetting:LocalSetting;
		[DexterBinding(model="server",property="userListSO")]
		public var userListSO:SharedObject;
		[DexterEvent]
		public function appStart():void{
			gospelModel.loadConfig();
			gospelModel.lookIp();
			localSetting.initCamera();
		}
		[DexterEvent]
		public function configComplete():void{
			if(localSetting.autoLogin){
				login();
			}
		}
		[DexterEvent]
		public function enterRoom(room:XML,userName:String,pwd:String):void{
			gospelModel.selectedRoom = room;
			localSetting.userName = userName;
			localSetting.pwd = pwd;
			localSetting.room = room.@code;
			if(pwd == room.@pwd){
				localSetting.role = UserVO.ADMIN;
				login();
			}else if(!pwd){
				localSetting.role = UserVO.GUEST;
				login();
			}else{
				Alert.show("密码错误！");
			}
		}
		private function login():void{
			WaitWindow.wait("进入房间");
			sendDexterEvent("ConnectServer");
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