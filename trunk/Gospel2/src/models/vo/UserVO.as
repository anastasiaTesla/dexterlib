package models.vo
{
	import flash.media.Camera;
	import flash.media.Microphone;

	[Bindable]
	public class UserVO
	{
		public static var self:UserVO = new UserVO({av:(Camera.names.length?'1':'0')+(Microphone.names.length?'1':'0')});
		public static const ADMIN:int = 100;
		public static const GUEST:int = 0;
		public var id:String;
		public var name:String;
		public var ip:String;
		public var address:String;
		public var role:int;
		public var groupAddress:String;
		public var av:String;
		public function UserVO(o:Object=null)
		{
			for(var i:String in o){
				this[i] = o[i];
			}
		}
		public function get isSelf():Boolean{
			return id == self.id;
		}
	}
}