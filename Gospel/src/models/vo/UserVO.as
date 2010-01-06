package models.vo
{
	[Bindable]
	public class UserVO
	{
		public static const ADMIN:int = 100;
		public static const GUEST:int = 0;
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
		public static var self:UserVO = new UserVO();
		public function get isSelf():Boolean{
			return id == self.id;
		}
	}
}