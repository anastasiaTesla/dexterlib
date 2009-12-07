package models.vo
{
	[Bindable]
	public class UserVO
	{
		public var id:String;
		public var name:String;
		public var ip:String;
		public var role:int;
		public function UserVO(o:Object=null)
		{
			for(var i:String in o){
				this[i] = o[i];
			}
		}
	}
}