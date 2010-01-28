package controllers
{
	import flash.events.NetStatusEvent;
	import flash.media.Microphone;
	import flash.net.NetStream;
	
	import models.LocalSetting;
	import models.StratusConnection;
	import models.vo.UserVO;
	
	import views.MainVideoWindow;

	[Bindable]
	public class VideoController
	{
		public var inStream:NetStream;
		public var outStream:NetStream;
		public var publishName:String;
		[DexterBinding]
		public var localSetting:LocalSetting;
		[DexterBinding]
		public var stratus:StratusConnection;
		[DexterBinding(model="localSetting",property="bufferTime")]
		public function setBufferTime(v:Number):void{
			if(inStream&&!isNaN(v))inStream.bufferTime = v;
		}
		[DexterBinding(model="localSetting",property="receiveVideo")]
		public function setReceiveVideo(v:Boolean):void{
			if(inStream)inStream.receiveVideo(v);
		}
		[DexterBinding(model="localSetting",property="receiveVideo")]
		public function setVideo(v:Boolean):void{
			if(sendDexterEvent("getMainWindow")){
				activeVideoWindow();
			}
			if(!v)sendDexterEvent("closeVideoWindow");
			if(inStream)inStream.receiveVideo(v);
		}
		private function activeVideoWindow():void{
			if(localSetting.receiveVideo){
				var videoWindow:MainVideoWindow = sendDexterEvent("getMainVideoWindow");
				if(videoWindow){
					videoWindow.orderToFront();
				}else{
					videoWindow = new MainVideoWindow();
					videoWindow.open();
				}
				videoWindow.setUser(sendDexterEvent("getUserByID",publishName));
			}
		}
		[DexterBinding(property="publishName")]
		public function playVideo(id:String):void{
			var videoWindow:MainVideoWindow = sendDexterEvent("getMainVideoWindow");
			if(!id){
				if(videoWindow)	videoWindow.setUser(null);
				return;
			}
			activeVideoWindow();
		}
		[DexterEvent]
		public function stratusInfo(event:NetStatusEvent):void{
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					inStream = new NetStream(stratus,stratus.groupSpecifier.groupspecWithAuthorizations());
					inStream.client = this;
					inStream.bufferTime = localSetting.bufferTime;
					inStream.receiveVideo(localSetting.receiveVideo);
					inStream.addEventListener(NetStatusEvent.NET_STATUS,stratusInfo);
					activeVideoWindow();
					break;
				case "NetStream.Connect.Success":
					if(event.info.stream == outStream){
						outStream.attachCamera(localSetting.cam);
						outStream.attachAudio(Microphone.getMicrophone());
						outStream.publish(UserVO.self.id);
					}
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
		}
		[DexterEvent]
		public function $publishUserVideo(id:String):void{
			publishName = id;
			if(UserVO.self.id == id){
				publishStream();
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
			if(UserVO.self.id != id)inStream.play(id);
		}
		public function publishStream():void{
			if(outStream)outStream.close();
			outStream = new NetStream(stratus,stratus.groupSpecifier.groupspecWithAuthorizations());
			outStream.client = this;
			outStream.addEventListener(NetStatusEvent.NET_STATUS,stratusInfo);
		}
	}
}