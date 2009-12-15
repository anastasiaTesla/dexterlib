package views
{
	import flash.events.ContextMenuEvent;
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
			contextMenu = menu;
		}
		private function onDockVideo(event:Event):void{
			sendDexterEvent("publishUserVideo",data);
		}
	}
}