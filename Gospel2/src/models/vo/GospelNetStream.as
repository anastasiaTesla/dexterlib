package models.vo
{
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class GospelNetStream extends NetStream
	{
		public function GospelNetStream(connection:NetConnection, peerID:String="connectToFMS")
		{
			super(connection, peerID);
			DexterFramework.registerView(this);
		}
		[DexterBinding(model="localSetting",property="multicastAvailabilitySendToAll")]
		public function setMulticastAvailabilitySendToAll(v:Boolean):void{
			multicastAvailabilitySendToAll = v;
		}
		[DexterBinding(model="localSetting",property="multicastAvailabilityUpdatePeriod")]
		public function setMulticastAvailabilityUpdatePeriod(v:Number):void{
			multicastAvailabilityUpdatePeriod = v;
		}
		[DexterBinding(model="localSetting",property="multicastFetchPeriod")]
		public function setMulticastFetchPeriod(v:Number):void{
			multicastFetchPeriod = v;
		}
		[DexterBinding(model="localSetting",property="multicastWindowDuration")]
		public function setMulticastWindowDuration(v:Number):void{
			multicastWindowDuration = v;
		}
		[DexterBinding(model="localSetting",property="multicastPushNeighborLimit")]
		public function setMulticastPushNeighborLimit(v:Number):void{
			multicastPushNeighborLimit = v;
		}
		[DexterBinding(model="localSetting",property="multicastRelayMarginDuration")]
		public function setMulticastRelayMarginDuration(v:Number):void{
			multicastRelayMarginDuration = v;
		}
		override public function close() : void{
			super.close();
			DexterFramework.unRegister(this);
		}
	}
}