package models
{
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetStream;
	
	import mx.controls.Alert;

	public class InStreamProxy
	{
		[DexterBinding]
		public var stratus:StratusConnection;
		[DexterBinding(model="groupSpecifierProxy",property="groupSpecifier")]
		public var groupSpecifier:GroupSpecifier;
		public var stream:NetStream;
		public var peerId:String;
		[DexterEvent]
		public function initInStream(id:String):NetStream{
			if(stream)stream.close();
			stratus.streamConnectType = "in";
			peerId = id;
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
		public function inStreamConnect():void{
			stream.play("media");
			stream.bufferTime = 1.0;
			sendDexterEvent("setVideo",peerId);
			sendDexterEvent("tip_dockVideo",peerId);
		}
		private function onStatus(event:NetStatusEvent):void{
			trace(event.info.code);
		}
		[DexterEvent]
		public function getInStream():NetStream{
			return stream;
		}
	}
}