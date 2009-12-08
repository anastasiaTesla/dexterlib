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
			connect("rtmp://"+gospelModel.serverAddr+"/mylive/"+localSetting.room,user);
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
				switch(o.code){
					case "change":
						sendDexterEvent("initSOchange_"+o.name,initSO.data[o.name]);
						break;
					case "delete":
						sendDexterEvent("initSOdelete_"+o.name);
						break;
				}
			}
		}
		private function onUserListSync(event:SyncEvent):void{
			for each(var o:Object in event.changeList){
				switch(o.code){
					case "change":
						userListMap[o.name] = new UserVO(userListSO.data[o.name]);
						userList.addItem(userListMap[o.name]);
						break;
					case "delete":
						userList.removeItemAt(userList.getItemIndex(userListMap[o.name]));
						delete userListMap[o.name];
						break;
					case "clear":
						userList.removeAll();
						userListMap = {};
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