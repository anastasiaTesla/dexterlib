package controllers
{
	import models.StratusConnection;
	import models.vo.UserVO;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;

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
			if(!userListMap[u.id]){
				userListMap[u.id] = u;
				userList.addItem(u);
				sendDexterEvent("userOnline",u);
			}
			sendDexterEvent("sendToUser",u,"alreadyOnline",UserVO.self);
		}
		[DexterEvent]
		public function $updateIp(user:Object):void{
			userListMap[user.id].ip = user.ip;
			userListMap[user.id].address = user.address;
			userList.refresh();
		}
		[DexterEvent]
		public function $alreadyOnline(userVO:Object):void{
			var u:UserVO = new UserVO(userVO);
			if(!userListMap[u.id]){
				userListMap[u.id] = u;
				userList.addItem(u);
				sendDexterEvent("alreadyOnline",u);
			}
		}
		[DexterEvent]
		public function $userOffline(id:String):void{
			var userVO:UserVO = getUserByGroupAddress(id);
			if(userVO)userOffline(userVO.id);
		}
		private function userOffline(id:String):void{
			sendDexterEvent("userOffline",userListMap[id]);
			userList.removeItemAt(userList.getItemIndex(userListMap[id]));
			delete userListMap[id];
		}
		[DexterEvent]
		public function ServerConnectSuccess():void{
			userListMap = {};
			userListMap[UserVO.self.id] = UserVO.self;
			userList = new ArrayCollection([UserVO.self]);
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