package models
{
	
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	
	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.XMLListCollection;
	import mx.controls.Alert;

	public class GospelModel
	{
		public const connectUrl:String = "rtmfp://stratus.adobe.com";
		public const developerKey:String = "39eb05e76eabb57deb96b56a-937bc372b0a4";
		public const configURL:String = "http://dexterlib.googlecode.com/files/config.xml";
		public const roomURL:String = "https://connectnow.acrobat.com/langhuihui/";
		public const appDesc:XML = NativeApplication.nativeApplication.applicationDescriptor;
		public const appUpdater:ApplicationUpdaterUI = new ApplicationUpdaterUI();
		[Bindable]
		public var statusBarText:String;
		[Bindable]
		public var roomList:XMLListCollection;
		public var serverAddr:String;
//		public var version:String;
		public function getVersion():String{
			return appDesc.children()[3];
		}
		public function loadConfig():void{
			new URLLoader(new URLRequest(configURL)).addEventListener(Event.COMPLETE,onConfigLoaded,false,0,true);
		}
		private function onConfigLoaded(event:Event):void{
			var config:XML = new XML(event.target.data);
			roomList = new XMLListCollection(config.roomList[0].children());
//			version = config.version;
			appUpdater.updateURL = config.updateURL;
			appUpdater.isCheckForUpdateVisible = false;
			appUpdater.isDownloadUpdateVisible = false;
			appUpdater.addEventListener(UpdateEvent.INITIALIZED, onUpdate);
			appUpdater.addEventListener(UpdateEvent.CHECK_FOR_UPDATE,onUpdate);
			appUpdater.addEventListener(ErrorEvent.ERROR, onError);
			appUpdater.isNewerVersionFunction = function(currentVersion:String, updateVersion:String):Boolean{
				if(currentVersion == updateVersion){
					sendDexterEvent("configComplete");
				}
				return currentVersion != updateVersion;
			};
			appUpdater.initialize();
			serverAddr = config.server;
		}
		private function onError(event:ErrorEvent):void {  
			Alert.show(event.toString());
		}  
		private function onUpdate(event:UpdateEvent):void {
			switch(event.type){
				case UpdateEvent.INITIALIZED:
					appUpdater.checkNow();
					break;
				case UpdateEvent.CHECK_FOR_UPDATE:
					break;
			}
		}
	}
}