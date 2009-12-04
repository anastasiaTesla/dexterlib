package models
{
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.SharedObject;

	[Bindable]
	public class StratusConnection extends NetConnection
	{
		private var so:SharedObject;
		public function StratusConnection()
		{
			super();
			addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
		}
		public function Connect():void{
			connect("rtmfp://stratus.adobe.com/39eb05e76eabb57deb96b56a-937bc372b0a4/room");
		}
		private function onNetStatus(event:NetStatusEvent):void{
			trace("Stratus:"+event.info.code);
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					sendDexterEvent("StratusConnectSuccess");
					break;
			}
		}
	}
}