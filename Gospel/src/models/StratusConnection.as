package models
{
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Microphone;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
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
		private var keepAlive:Timer = new Timer(4000);
		public function StratusConnection()
		{
			super();
			addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
			keepAlive.addEventListener(TimerEvent.TIMER,onTimer);
		}
		private function onTimer(event:TimerEvent):void{
			sendToOthers("stillAlive",UserVO.self);
			sendDexterEvent("checkUserAlive");
		}
		private function onNetStatus(event:NetStatusEvent):void{
			trace("Stratus:"+event.info.code);
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					UserVO.self.id = nearID;
					sendDexterEvent("ServerConnectSuccess");
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
				case "NetGroup.Connect.Success":
					setTimeout(onTimer,1000,null);
					keepAlive.start();
					break;
				case "NetGroup.Posting.Notify":
					var array:Array = event.info.message as Array;
					array.pop();
					array[0] = "$"+array[0];
					DexterEvent.SendEvent.apply(DexterEvent,array);
					break;
				case "NetGroup.MulticastStream.PublishNotify":
					playStream(event.info.name);
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
		public function playStream(id:String):void{
			publishName = id;
			sendDexterEvent("setVideo",id);
			sendDexterEvent("tip_dockVideo",id);
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
			try{
				netGroup.post(arg.concat(Math.random()*100>>0));
				arg[0] = "$"+arg[0];
				DexterEvent.SendEvent.apply(DexterEvent,arg);
			}catch(e:Error){
			}
		}
		[DexterEvent]
		public function sendToOthers(...arg):void{
			try{
				netGroup.post(arg.concat(Math.random()*100>>0));
			}catch(e:Error){
			}
		}
	}
}