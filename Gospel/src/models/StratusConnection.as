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
		public var inStream:NetStream;
		public var outStream:NetStream;
		public var streamStatus:String;
		public var netGroup:NetGroup;
		[DexterBinding]
		public var localSetting:LocalSetting;
		public static const IN:String = "in";
		public static const OUT:String = "out";
		private var groupSpecifier:GroupSpecifier;
		private var publishName:String;
		private var hasConnected:Boolean;
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
					sendDexterEvent("ServerConnectSuccess");
					onConnect();
					break;
				case "NetConnection.Connect.Close":
					break;
				case "NetStream.Connect.Closed":
					break;
				case "NetStream.Connect.Success":
					if(event.info.stream == outStream){
						outStream.attachCamera(localSetting.cam);
						outStream.attachAudio(Microphone.getMicrophone());
						outStream.publish(UserVO.self.id);
					}
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
						sendDexterEvent("sendToOthers2","userOnline",UserVO.self);
					}
					break;
				case "NetGroup.Neighbor.Disconnect":
					sendDexterEvent("broadcast2","userOffline",event.info.neighbor);
					break;
				case "NetGroup.MulticastStream.PublishNotify":
					if(sendDexterEvent("getUserByID",event.info.name))
						playStream(event.info.name);
					else
						publishName = event.info.name;
					break;
			}
		}
		[DexterEvent]
		public function ipDone():void{
			if(hasConnected){
				sendDexterEvent("broadcast2","updateIp",UserVO.self);
			}else{
				sendDexterEvent("updateIp",UserVO.self);
			}
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
			inStream = new NetStream(this,groupSpecifier.groupspecWithAuthorizations());
			inStream.bufferTime = 0.1;
			inStream.client = this;
			inStream.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
			netGroup = new NetGroup(this,groupSpecifier.groupspecWithAuthorizations());
			netGroup.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		}
		[DexterEvent]
		public function publishUserVideo(user:UserVO):void{
			if(user.id == publishName)
				sendDexterEvent("broadcast","unPublishUserVideo",user.id);
			else
				sendDexterEvent("broadcast","publishUserVideo",user.id);
		}
		[DexterEvent]
		public function $unPublishUserVideo(id:String):void{
			publishName = null;
			if(id == UserVO.self.id){
				outStream.close();
			}
			sendDexterEvent("setVideo",null);
		}
		[DexterEvent]
		public function $publishUserVideo(id:String):void{
			publishName = id;
			if(UserVO.self.id == id){
				publishStream();
				sendDexterEvent("setVideo",id);
				sendDexterEvent("tip_dockVideo",id);
			}
		}
		[DexterEvent]
		public function alreadyOnline(user:UserVO):void{
			if(user.id == publishName){
				playStream(publishName);
			}
		}
		public function playStream(id:String):void{
			publishName = id;
			sendDexterEvent("setVideo",id);
			sendDexterEvent("tip_dockVideo",id);
			if(UserVO.self.id != id)inStream.play(id);
		}
		public function publishStream():void{
			if(outStream)outStream.close();
			outStream = new NetStream(this,groupSpecifier.groupspecWithAuthorizations());
			outStream.client = this;
			outStream.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
		}
	}
}