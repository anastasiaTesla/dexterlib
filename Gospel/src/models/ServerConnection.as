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
		private var initSO:SharedObject;
		private var userListSO:SharedObject;
		private var userListMap:Object = {};
		public var userList:ArrayCollection = new ArrayCollection();
		public function ServerConnection()
		{
			super();
			addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
		}
		public function Connect(id:String):void{
			connect("rtmp://www.finosstudio.com/mylive/room",id,{name:"dexter"});
			initSO = SharedObject.getRemote("initObject",uri,true);
			userListSO = SharedObject.getRemote("userList",uri,false);
			initSO.addEventListener(SyncEvent.SYNC,onSync);
			userListSO.addEventListener(SyncEvent.SYNC,onUserListSync);
			userListSO.connect(this);
			initSO.connect(this);
		}
		private function onNetStatus(event:NetStatusEvent):void{
			trace("Server:"+event.info.code);
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					break;
			}
		}
		private function onSync(event:SyncEvent):void{
			for each(var o:Object in event.changeList){
				trace(o.code);
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