package models
{
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	
	public class StratusConnection extends NetConnection
	{
		public function StratusConnection()
		{
			super();
			addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
		}
		public function Connect():void{
			connect("rtmfp://stratus.adobe.com/39eb05e76eabb57deb96b56a-937bc372b0a4/room");
		}
		private function onNetStatus(event:NetStatusEvent):void{
			trace(event.info.code);
		}
	}
}