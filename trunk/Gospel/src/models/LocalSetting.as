package models
{
	import flash.media.Camera;
	import flash.net.SharedObject;

	[Bindable]
	public class LocalSetting
	{
		public var so:SharedObject = SharedObject.getLocal("localSetting");
		public function set userName(v:String):void{
			setValue("userName",v);
		}
		public function get userName():String{
			return so.data["userName"];
		}
		public function set pwd(v:String):void{
			setValue("pwd",v);
		}
		public function get pwd():String{
			return so.data["pwd"];
		}
		public function set room(v:String):void{
			setValue("room",v);
		}
		public function get room():String{
			return so.data["room"];
		}
		public function set autoLogin(v:Boolean):void{
			setValue("autoLogin",v);
		}
		public function get autoLogin():Boolean{
			return so.data["autoLogin"];
		}
		public function get role():int{
			return so.data["role"];
		}
		public function set role(v:int):void{
			setValue("role",v);
		}
		public function get camera():int{
			return so.data["camera"];
		}
		public function set camera(v:int):void{
			setValue("camera",v);
		}
		public function get cameraSize():int{
			return so.data["cameraSize"];
		}
		public function set cameraSize(v:int):void{
			setValue("cameraSize",v);
			setMode();
		}
		private function setValue(name:String,value:Object):void{
			so.data[name] = value;
			try{
				so.flush();
			}catch(e:Error){
				
			}
		}
		public function get cam():Camera{
			if(camera < Camera.names.length){
				return Camera.getCamera(camera.toString());
			}else{
				return Camera.getCamera();
			}
		}
		public function setMode():void{
			if(cam)
			switch(cameraSize){
				case 0:
					cam.setMode(160,120,15);
					break;
				case 1:
					cam.setMode(320,240,15);
					break;
				case 2:
					cam.setMode(640,480,15);
					break;
			}
		}
	}
}