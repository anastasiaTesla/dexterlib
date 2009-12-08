package models
{
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.SharedObject;

	[Bindable]
	public class StratusConnection extends NetConnection
	{
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
					break;
			}
		}
	}
}