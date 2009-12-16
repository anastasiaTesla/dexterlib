package models
{
	import flash.media.Camera;
	import flash.net.SharedObject;

	[Bindable]
	public class LocalSetting
	{
		public var so:SharedObject = SharedObject.getLocal("localSetting");
		public function set userName(v:String):void{
			so.data["userName"] = v;
			so.flush();
		}
		public function get userName():String{
			return so.data["userName"];
		}
		public function set pwd(v:String):void{
			so.data["pwd"] = v;
			so.flush();
		}
		public function get pwd():String{
			return so.data["pwd"];
		}
		public function set room(v:String):void{
			so.data["room"] = v;
			so.flush();
		}
		public function get room():String{
			return so.data["room"];
		}
		public function set autoLogin(v:Boolean):void{
			so.data["autoLogin"] = v;
			so.flush();
		}
		public function get autoLogin():Boolean{
			return so.data["autoLogin"];
		}
		public function get role():int{
			return so.data["role"];
		}
		public function set role(v:int):void{
			so.data["role"]=v;
			so.flush();
		}
		public function get camera():int{
			return so.data["camera"];
		}
		public function set camera(v:int):void{
			so.data["camera"]=v;
			so.flush();
		}
		public function get cameraSize():int{
			return so.data["cameraSize"];
		}
		public function set cameraSize(v:int):void{
			so.data["cameraSize"]=v;
			so.flush();
		}
		public function get cam():Camera{
			if(camera < Camera.names.length){
				return Camera.getCamera(camera.toString());
			}else{
				return Camera.getCamera();
			}
		}
	}
}