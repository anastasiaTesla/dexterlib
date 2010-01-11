package controllers
{
	import models.StratusConnection;
	import models.vo.UserVO;
	
	import mx.collections.ArrayCollection;

	public class UserListController
	{
		private var userListMap:Object;
		public var userList:ArrayCollection;
		[DexterBinding]
		public var stratus:StratusConnection;
		[DexterEvent]
		public function $userOnline(user:Object):void{
			var u:UserVO = new UserVO(user);
			if(!userListMap[u.id]){
				userListMap[u.id] = u;
				userList.addItem(u);
				sendDexterEvent("userOnline",u);
			}
			stratus.netGroup.sendToNearest(["alreadyOnline",UserVO.self],u.groupAddress);
		}
		[DexterEvent]
		public function $alreadyOnline(userVO:Object):void{
			var u:UserVO = new UserVO(userVO);
			if(!userListMap[u.id]){
				userListMap[u.id] = u;
				userList.addItem(u);
			}
		}
		[DexterEvent]
		public function $userOffline(id:String):void{
			var userVO:UserVO = getUserByGroupAddress(id);
			userOffline(userVO.id);
		}
		private function userOffline(id:String):void{
			sendDexterEvent("userOffline",userListMap[id]);
			userList.removeItemAt(userList.getItemIndex(userListMap[id]));
			delete userListMap[id];
		}
		[DexterEvent]
		public function ServerConnectSuccess():void{
			userListMap = {};
			userList = new ArrayCollection();
			userListMap[UserVO.self.id] = UserVO.self;
			userList.addItemAt(UserVO.self,0);
		}
		[DexterEvent]
		public function getUserByID(id:String):UserVO{
			return userListMap[id];
		}
		[DexterEvent]
		public function getUserByGroupAddress(groupAddress:String):UserVO{
			for each(var userVO:UserVO in userListMap)
				if(userVO.groupAddress == groupAddress)
					return userVO;
			return null;
		}
	}
}