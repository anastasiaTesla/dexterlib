package models
{
	import flash.events.NetStatusEvent;
	import flash.media.Microphone;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.NetStream;
	
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
		public function StratusConnection()
		{
			super();
			addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
		}
		private function onNetStatus(event:NetStatusEvent):void{
			trace("Stratus:"+event.info.code);
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					sendDexterEvent("StratusConnectSuccess");
					onConnect();
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
				case "NetGroup.Posting.Notify":
					var array:Array = event.info.message as Array;
					array[0] = "$"+array[0];
					DexterEvent.SendEvent.apply(DexterEvent,array);
					break;
			}
		}
		private function onConnect():void{
			groupSpecifier = new GroupSpecifier("gospel/"+localSetting.room);
			groupSpecifier.multicastEnabled = true;
			groupSpecifier.postingEnabled = true;
			groupSpecifier.serverChannelEnabled = true;
			inStream = new NetStream(this,groupSpecifier.groupspecWithAuthorizations());
			inStream.client = this;
			inStream.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
			netGroup = new NetGroup(this,groupSpecifier.groupspecWithAuthorizations());
			netGroup.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		}
		[DexterEvent]
		public function publishOutStream(user:UserVO):void{
			if(user.isSelf){
				publishStream();
			}else{
				playStream(user.id);
			}
		}
		public function playStream(id:String):void{
			inStream.play(id);
			inStream.bufferTime = 1.0;
		}
		public function publishStream():void{
			if(outStream)outStream.close();
			outStream = new NetStream(this,groupSpecifier.groupspecWithAuthorizations());
			outStream.client = this;
			outStream.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
		}
		[DexterEvent]
		public function broadcast(...arg):void{
			netGroup.post(arg);
			arg[0] = "$"+arg[0];
			DexterEvent.SendEvent.apply(DexterEvent,arg);
		}
	}
}