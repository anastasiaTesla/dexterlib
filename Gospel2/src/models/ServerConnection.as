package models
{
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	
	import models.vo.UserVO;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class ServerConnection extends NetConnection
	{
		public var initSO:SharedObject;
		public var userListSO:SharedObject;
		private var userListMap:Object = {};
		public var userList:ArrayCollection = new ArrayCollection();
		[DexterBinding]
		public var localSetting:LocalSetting;
		[DexterBinding]
		public var gospelModel:GospelModel;
		[DexterBinding]
		public var proxy:SOProxy;
		public function ServerConnection()
		{
			super();
			addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
		}
		public function Connect(user:UserVO):void{
			connect("rtmp://"+gospelModel.serverAddr+"/gospel/"+localSetting.room,user);
			initSO = SharedObject.getRemote("initObject",uri,true);
			userListSO = SharedObject.getRemote("userList",uri,false);
			initSO.addEventListener(SyncEvent.SYNC,onSync);
			userListSO.addEventListener(SyncEvent.SYNC,onUserListSync);
			userListSO.client = proxy;
			userListSO.connect(this);
			initSO.connect(this);
		}
		private function onNetStatus(event:NetStatusEvent):void{
			trace("Server:"+event.info.code);
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					sendDexterEvent("ServerConnectSuccess");
					break;
			}
		}
		private function onSync(event:SyncEvent):void{
			for each(var o:Object in event.changeList){
				if(o.name)
					sendDexterEvent("initSO"+o.code+'_'+o.name,initSO.data[o.name]);
				else
					sendDexterEvent("initSO"+o.code);
			}
		}
		private function onUserListSync(event:SyncEvent):void{
			for each(var o:Object in event.changeList){
				switch(o.code){
					case "change":
						if(userList.length){
							if(!userListMap[o.name]){
								userListMap[o.name] = new UserVO(userListSO.data[o.name]);
								userList.addItem(userListMap[o.name]);
								sendDexterEvent("userOnline",userListMap[o.name]);
							}
						}else{
							for(var userId:String in userListSO.data){
								userListMap[userId] = new UserVO(userListSO.data[userId]);
								userList.addItem(userListMap[userId]);
							}
						}
						break;
					case "delete":
						sendDexterEvent("userOffline",userListMap[o.name]);
						userList.removeItemAt(userList.getItemIndex(userListMap[o.name]));
						delete userListMap[o.name];
						break;
					case "clear":
						userList.removeAll();
						userListMap = {};
						for(userId in userListSO.data){
							userListMap[userId] = new UserVO(userListSO.data[userId]);
							userList.addItem(userListMap[userId]);
						}
						break;
				}
			}
		}
		[DexterEvent]
		public function getUserByID(id:String):UserVO{
			return userListMap[id];
		}
	}
}