package models
{
	import flash.desktop.Updater;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	import mx.controls.ProgressBarMode;
	
	import views.WaitWindow;

	public class GospelUpdater
	{
		private var version:String;
		private var newFileLoader:URLStream;
		private var file:File = File.applicationStorageDirectory.resolvePath("Gospel.air");
//		private var file:File = File.createTempFile();
//		private var file:File = File.desktopDirectory.resolvePath("Gospel.air");
		private static var instance:GospelUpdater;
		public function GospelUpdater(updateURL:String,version:String)
		{
			instance = this;
			this.version = version;
			var loadUpdateXML:URLLoader = new URLLoader(new URLRequest(updateURL));
			loadUpdateXML.addEventListener(Event.COMPLETE,onUpdateXMLLoaded,false,0,true);
			WaitWindow.wait("检查更新",ProgressBarMode.EVENT,loadUpdateXML);
		}
		private function onUpdateXMLLoaded(event:Event):void{
			var string:String = event.target.data;
			var v:String = string.substring(string.indexOf("<version>")+9,string.indexOf("</version>"));
			var fileURL:String = string.substring(string.indexOf("<url>")+5,string.indexOf("</url>"));
			if(version != v){
				version = v;
				newFileLoader = new URLStream();
				WaitWindow.wait("下载更新",ProgressBarMode.EVENT,newFileLoader);
				newFileLoader.addEventListener(Event.COMPLETE, loaded,false,0,true);
				newFileLoader.load(new URLRequest(fileURL));
			}else{
				instance = null;
				file = null;
				sendDexterEvent("configComplete");
			}
			WaitWindow.waitThingDone("检查更新");
		}
		private function loaded(event:Event):void{
			var fileData:ByteArray = new ByteArray();
			var urlStream:URLStream = event.target as URLStream;
			urlStream.readBytes(fileData);
			var fileStream:FileStream = new FileStream();
			//fileStream.addEventListener(Event.CLOSE, fileClosed,false,0,true);
			var tempFile:File = File.createTempFile();
			fileStream.open(tempFile, FileMode.WRITE);
			fileStream.writeBytes(fileData);
			fileStream.close();
			tempFile.moveTo(file,true);
			new Updater().update(file,version);
		}
		
		private function fileClosed(event:Event):void {
			new Updater().update(file,version);
		}
	}
}