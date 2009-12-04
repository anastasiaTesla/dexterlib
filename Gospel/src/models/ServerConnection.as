package models
{
	import flash.net.NetConnection;
	import flash.events.NetStatusEvent;
	public class ServerConnection extends NetConnection
	{
		public function ServerConnection()
		{
			super();
			addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
		}
		public function Connect():void{
			connect("rtmp://www.finosstudio.com/mylive/room");
		}
		private function onNetStatus(event:NetStatusEvent):void{
			trace(event.info.code);
		}
		public function  ncInit():void{
			
		}
	}
}