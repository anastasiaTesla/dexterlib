package views
{
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	public class UserListItemAdmin extends UserListItem
	{
		public function UserListItemAdmin()
		{
			super();
			var menu:ContextMenu = new ContextMenu();
			
			var menuItem:ContextMenuItem = new ContextMenuItem("上视频");
			menuItem.addEventListener(Event.SELECT,onDockVideo,false,0,true);
			menu.addItem(menuItem);
			
			menuItem = new ContextMenuItem("踢出此人");
			menuItem.addEventListener(Event.SELECT,onKick,false,0,true);
			menu.addItem(menuItem);
			
			contextMenu = menu;
		}
		private function onDockVideo(event:Event):void{
			sendDexterEvent("publishUserVideo",data);
		}
		private function onKick(event:Event):void{
			sendDexterEvent("kickUser",data);
		}
	}
}