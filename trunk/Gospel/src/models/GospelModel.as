package models
{
	
	import air.update.ApplicationUpdaterUI;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.html.HTMLLoader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
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
		private var html:HTMLLoader = new HTMLLoader();
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
			html.addEventListener(Event.COMPLETE,onLoadIP);
			html.load(new URLRequest("http://www.ip.cn"));
		}
		private function onLoadIP(evt:Event):void{
			UserVO.self.ip = html.window.document.getElementById("locaIp").firstChild.innerHTML;
			UserVO.self.address = html.window.document.getElementById("locaIp").lastChild.data.substr(5);
			WaitWindow.waitThingDone("获取IP地址");
		}
	}
}