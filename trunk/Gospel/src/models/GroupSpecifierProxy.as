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
			groupSpecifier = new GroupSpecifier(localSetting.room);
		}
	}
}