package models
{
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;

	public class InStreamProxy
	{
		[DexterBinding]
		public var stratus:StratusConnection;
		public var stream:NetStream;
		[DexterEvent]
		public function initInStream(id:String):NetStream{
			stream = new NetStream(stratus,id);
			stream.addEventListener(NetStatusEvent.NET_STATUS,onStatus);
			return stream;
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