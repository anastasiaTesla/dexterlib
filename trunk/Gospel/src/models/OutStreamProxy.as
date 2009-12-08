package models
{
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;

	public class OutStreamProxy
	{
		[DexterBinding]
		public var stratus:StratusConnection;
		public var stream:NetStream;
		[DexterEvent]
		public function initOutStream():NetStream{
			stream = new NetStream(stratus,NetStream.DIRECT_CONNECTIONS);
			stream.addEventListener(NetStatusEvent.NET_STATUS,onStatus);
			return stream;
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