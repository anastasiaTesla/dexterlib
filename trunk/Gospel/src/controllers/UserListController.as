package controllers
{
	import flash.utils.getTimer;
	
	import models.vo.UserVO;
	
	import mx.collections.ArrayCollection;

	public class UserListController
	{
		private var userListMap:Object;
		public var userList:ArrayCollection;
		private var userAliveTime:Object;
		[DexterEvent]
		public function $stillAlive(user:Object):void{
			var u:UserVO = new UserVO(user);
			if(!userListMap[u.id]){
				userListMap[u.id] = u;
				userList.addItem(u);
				sendDexterEvent("userOnline",u);
			}
			userAliveTime[u.id] = getTimer()/1000>>0;
		}
		[DexterEvent]
		public function checkUserAlive():void{
			for(var id:String in userAliveTime){
				var timeStamp:int = userAliveTime[id];
				if((getTimer()/1000>>0) - timeStamp>10){
					userOffline(id);
				}
			}
		}
		[DexterEvent]
		public function $userOffline(id:String):void{
			userOffline(id);
		}
		private function userOffline(id:String):void{
			sendDexterEvent("userOffline",userListMap[id]);
			delete userAliveTime[id];
			userList.removeItemAt(userList.getItemIndex(userListMap[id]));
			delete userListMap[id];
		}
		[DexterEvent]
		public function ServerConnectSuccess():void{
			userListMap = {};
			userList = new ArrayCollection();
			userAliveTime = {};
			userListMap[UserVO.self.id] = UserVO.self;
			userList.addItemAt(UserVO.self,0);
		}
		[DexterEvent]
		public function getUserByID(id:String):UserVO{
			return userListMap[id];
		}
	}
}