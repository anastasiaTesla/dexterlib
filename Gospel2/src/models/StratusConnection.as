package models
{
	import flash.events.NetStatusEvent;
	import flash.media.Microphone;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.NetStream;
	import flash.utils.getTimer;
	
	import models.vo.UserVO;

	[Bindable]
	public class StratusConnection extends NetConnection
	{
		
		public var netGroup:NetGroup;
		[DexterBinding]
		public var localSetting:LocalSetting;
		public var groupSpecifier:GroupSpecifier;
		public var hasConnected:Boolean;
		private var messageCache:Vector.<int> = new Vector.<int>();
		public function StratusConnection()
		{
			super();
			addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
		}
		private function onNetStatus(event:NetStatusEvent):void{
			trace("Stratus:"+event.info.code);
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					UserVO.self.id = nearID;
					onConnect();
					sendDexterEvent("ServerConnectSuccess");
					break;
				case "NetConnection.Connect.Close":
					break;
//				case "NetGroup.Connect.Success":
//					UserVO.self.groupAddress = netGroup.convertPeerIDToGroupAddress(UserVO.self.id);
//					sendToOthers2("userOnline",UserVO.self);
//					break;
				case "NetGroup.Posting.Notify":
				case "NetGroup.SendTo.Notify":
					var array:Array = event.info.message as Array;
					if("trust" in array){
						var answer:Array = ["trustAnswer",array["trust"]];
						answer["t"] = getTimer();
						netGroup.sendToNearest(answer,event.info.from);
						if(messageCache.indexOf(array["trust"]) == -1){
							messageCache.push(array["trust"]);
							array[0] = "$"+array[0];
							DexterEvent.SendEvent.apply(DexterEvent,array);
							if(messageCache.length>10){
								messageCache.shift();
							}
						}
					}else{
						array[0] = "$"+array[0];
						DexterEvent.SendEvent.apply(DexterEvent,array);
					}
					break;
				case "NetGroup.Neighbor.Connect":
					if(hasConnected){
						var user:UserVO = sendDexterEvent("getUserByGroupAddress",event.info.neighbor);
						if(!user){
							array = ["hello",UserVO.self];
							array["t"] = getTimer();
							netGroup.sendToNearest(array,event.info.neighbor);
						}
					}else{
						hasConnected = true;
						UserVO.self.groupAddress = netGroup.convertPeerIDToGroupAddress(UserVO.self.id);
						sendDexterEvent("sendToOthers2","userOnline",UserVO.self.toObject);
					}
					break;
				case "NetGroup.Neighbor.Disconnect":
					sendDexterEvent("broadcast2","userOffline",event.info.neighbor);
					break;
			}
			sendDexterEvent("stratusInfo",event);
		}
		[DexterEvent]
		public function $hello(u:Object):void{
			trace(u);
		}
		private function onConnect():void{
			groupSpecifier = new GroupSpecifier("gospel/"+localSetting.room);
			groupSpecifier.multicastEnabled = true;
			groupSpecifier.postingEnabled = true;
			groupSpecifier.serverChannelEnabled = true;
			groupSpecifier.ipMulticastMemberUpdatesEnabled = true;
			groupSpecifier.objectReplicationEnabled = true;
			groupSpecifier.routingEnabled = true;
			netGroup = new NetGroup(this,groupSpecifier.groupspecWithAuthorizations());
			netGroup.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		}
	}
}