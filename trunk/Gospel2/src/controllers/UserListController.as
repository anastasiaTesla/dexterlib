package controllers
{
	import models.StratusConnection;
	import models.vo.UserVO;
	
	import mx.collections.ArrayCollection;

	public class UserListController
	{
		private var userListMap:Object;
		[Bindable]
		public var userList:ArrayCollection;
		[DexterBinding]
		public var stratus:StratusConnection;
		[DexterEvent]
		public function $userOnline(user:Object):void{
			var u:UserVO = new UserVO(user);
			u.groupAddress = stratus.netGroup.convertPeerIDToGroupAddress(u.id);
			if(!userListMap[u.id]){
				userListMap[u.id] = u;
				userList.addItem(u);
				sendDexterEvent("userOnline",u);
			}
			sendDexterEvent("sendToUserTrust",u,"alreadyOnline",UserVO.self.toObject);
		}
		[DexterEvent]
		public function $alreadyOnline(userVO:Object):void{
			var u:UserVO = new UserVO(userVO);
			u.groupAddress = stratus.netGroup.convertPeerIDToGroupAddress(u.id);
			if(!userListMap[u.id]){
				userListMap[u.id] = u;
				userList.addItem(u);
				sendDexterEvent("alreadyOnline",u);
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
			userListMap = {all:UserVO.all};
			userListMap[UserVO.self.id] = UserVO.self;
			userList = new ArrayCollection([UserVO.all,UserVO.self]);
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