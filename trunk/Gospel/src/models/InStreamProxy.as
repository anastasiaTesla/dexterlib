package models
{
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetStream;

	public class InStreamProxy
	{
		[DexterBinding]
		public var stratus:StratusConnection;
		[DexterBinding(model="groupSpecifierProxy",property="groupSpecifier")]
		public var groupSpecifier:GroupSpecifier;
		public var stream:NetStream;
		[DexterEvent]
		public function initInStream(id:String):NetStream{
			if(stream)stream.close();
			stream = new NetStream(stratus,groupSpecifier.groupspecWithAuthorizations());
//			stream.multicastAvailabilitySendToAll = true;
//			stream.multicastAvailabilityUpdatePeriod = 5;
//			stream.multicastPushNeighborLimit = 10;
//			stream.multicastFetchPeriod = 5;
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