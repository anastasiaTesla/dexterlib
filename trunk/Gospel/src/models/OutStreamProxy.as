package models
{
	import flash.events.NetStatusEvent;
	import flash.media.Microphone;
	import flash.net.GroupSpecifier;
	import flash.net.NetStream;
	
	import models.vo.UserVO;
	
	import mx.controls.Alert;

	public class OutStreamProxy
	{
		[DexterBinding]
		public var stratus:StratusConnection;
		[DexterBinding(model="groupSpecifierProxy",property="groupSpecifier")]
		public var groupSpecifier:GroupSpecifier;
		public var stream:NetStream;
		[DexterBinding]
		public var localSetting:LocalSetting;
		[DexterEvent]
		public function initOutStream():NetStream{
			stratus.streamConnectType = "out";
			stream = new NetStream(stratus,groupSpecifier.groupspecWithAuthorizations());
			stream.client = this;
			stream.addEventListener(NetStatusEvent.NET_STATUS,onStatus);
			return stream;
		}
		public function onPeerConnect(subscriber:NetStream):Boolean {
			Alert.show(subscriber.info.toString(),subscriber.farID);
			return true;
		}
		[DexterEvent]
		public function outStreamConnect():void{
			stream.attachCamera(localSetting.cam);
			stream.attachAudio(Microphone.getMicrophone());
			stream.publish("media");
			sendDexterEvent("setVideo",UserVO.self.id);
			sendDexterEvent("tip_dockVideo",UserVO.self.id);
		}
		private function onStatus(event:NetStatusEvent):void{
			trace(event.info.code);
		}
		[DexterEvent]
		public function getOutStream():NetStream{
			return stream;
		}
	}
}