package views
{
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import models.vo.UserVO;

	public class UserListItemAdmin extends UserListItem
	{
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value != UserVO.all){
				contextMenu = new ContextMenu();
				var addItem:Function = function(a:String,b:String):void{
					var menuItem:ContextMenuItem = new ContextMenuItem(a);
					var f:Function = function(event:Event):void{
						sendDexterEvent(b,data);
					};
					menuItem.addEventListener(Event.SELECT,f,false,0,true);
					contextMenu.addItem(menuItem);
				};
				if(value.av.charAt(0)=='1'||value.av.charAt(1)=='1')
					addItem("发布视频","publishUserVideo");
				if(value != UserVO.self){
					addItem("修改其昵称","changeNick");
					addItem("踢出此人","kickUser");
				}
			}
		}
	}
}