package controllers
{
	import flash.desktop.SystemTrayIcon;
	import flash.display.NativeMenu;
	import flash.events.Event;
	import flash.events.ScreenMouseEvent;
	import flash.ui.ContextMenuItem;
	
	import mx.core.FlexGlobals;

	public class TrayIconController
	{
		private var myTray:SystemTrayIcon = FlexGlobals.topLevelApplication.nativeApplication.icon as SystemTrayIcon;
		[Embed(source="icon/16.png")]
		private var icon:Class;
		public function TrayIconController(){
			myTray.bitmaps = [new icon().bitmapData];
			myTray.menu = new NativeMenu();
			addItem("退出","quit");
			myTray.tooltip = "福音天使";
			myTray.addEventListener(ScreenMouseEvent.CLICK,onClick);
		}
		private function onClick(event:ScreenMouseEvent):void{
			sendDexterEvent("trayClick");
		}
		private function addItem(a:String,b:String):void{
			var menuItem:ContextMenuItem = new ContextMenuItem(a);
			var f:Function = function(event:Event):void{
				sendDexterEvent(b);
			};
			menuItem.addEventListener(Event.SELECT,f);
			myTray.menu.addItem(menuItem);
		}
	}
}