package models
{
	import flash.net.GroupSpecifier;
	[Bindable]
	public class GroupSpecifierProxy
	{
		[DexterBinding]
		public var localSetting:LocalSetting;
		public var groupSpecifier:GroupSpecifier;
		[DexterEvent]
		public function initGroupSpecifier():void{
			groupSpecifier = new GroupSpecifier("gospel/"+localSetting.room);
			groupSpecifier.serverChannelEnabled = true;
//			groupSpecifier.ipMulticastMemberUpdatesEnabled = true;
//			groupSpecifier.multicastEnabled = true;
		}
	}
}