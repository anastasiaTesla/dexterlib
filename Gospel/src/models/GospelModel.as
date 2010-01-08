package models
{
	
	import air.update.ApplicationUpdaterUI;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	
	import models.vo.UserVO;
	
	import mx.collections.XMLListCollection;
	
	import views.WaitWindow;

	[Bindable]
	public class GospelModel
	{
		public const connectUrl:String = "rtmfp://stratus.adobe.com";
		public const developerKey:String = "39eb05e76eabb57deb96b56a-937bc372b0a4";
		public const configURL:String = "http://dexterlib.googlecode.com/files/config.xml";
		public const roomURL:String = "https://connectnow.acrobat.com/langhuihui/";
		public const appDesc:XML = NativeApplication.nativeApplication.applicationDescriptor;
		public const appUpdater:ApplicationUpdaterUI = new ApplicationUpdaterUI();
		public var statusBarText:String;
		public var roomList:XMLListCollection;
		public var selectedRoom:XML;
		public var serverAddr:String;
		public var helpURL:String;
		public function getVersion():String{
			return appDesc.children()[3];
		}
		public function loadConfig():void{
			WaitWindow.wait("加载配置文件");
			new URLLoader(new URLRequest(configURL)).addEventListener(Event.COMPLETE,onConfigLoaded,false,0,true);
		}
		private function onConfigLoaded(event:Event):void{
			var config:XML = new XML(event.target.data);
			roomList = new XMLListCollection(config.roomList[0].children());
			new GospelUpdater(config.updateURL,getVersion());
			serverAddr = config.server;
			helpURL = config.helpURL;
			WaitWindow.waitThingDone("加载配置文件");
		}
		public function lookIp():void{
			WaitWindow.wait("获取IP地址");
			var stream:URLStream = new URLStream();
			stream.addEventListener(Event.COMPLETE, onLoadIP);
			stream.load(new URLRequest("http://www.123cha.com"));
		}
		private function onLoadIP(evt:Event):void{
			var loader:URLStream = evt.target as URLStream;
			var data:String = loader.readMultiByte(loader.bytesAvailable,"gb2312");
			var p:int = data.indexOf("++ 您的ip:[<a");
			var ip:String = data.substring(data.indexOf(">",p)+1,data.indexOf("</a>",p));
			data = data.substr(p);
			var address:String = data.substring(data.indexOf("来自:")+3,data.indexOf(" ++"));
			UserVO.self.ip = ip;
			UserVO.self.address = address.replace("&nbsp;","");
			WaitWindow.waitThingDone("获取IP地址");
		}
	}
}