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
			contextMenu = new ContextMenu();;
			addItem("上/下视频","publishUserVideo");
			addItem("修改其昵称","changeNick");
			addItem("踢出此人","kickUser");
		}
		private function addItem(a:String,b:String):void{
			var menuItem:ContextMenuItem = new ContextMenuItem(a);
			var f:Function = function(event:Event):void{
				sendDexterEvent(b,data);
			};
			menuItem.addEventListener(Event.SELECT,f,false,0,true);
			contextMenu.addItem(menuItem);
		}
	}
}