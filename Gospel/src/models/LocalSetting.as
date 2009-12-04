package models
{
	import flash.net.SharedObject;
	[Bindable]
	public class LocalSetting
	{
		public var so:SharedObject = SharedObject.getLocal("localSetting");
		public function set userName(v:String):void{
			so.data["userName"] = v;
		}
		public function get userName():String{
			return so.data["userName"];
		}
		public function set pwd(v:String):void{
			so.data["pwd"] = v;
		}
		public function get pwd():String{
			return so.data["pwd"];
		}
		public function set room(v:String):void{
			so.data["room"] = v;
		}
		public function get room():String{
			return so.data["room"];
		}
		public function set autoLogin(v:Boolean):void{
			so.data["autoLogin"] = v;
		}
		public function get autoLogin():Boolean{
			return so.data["autoLogin"];
		}
	}
}