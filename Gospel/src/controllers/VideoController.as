package controllers
{
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	
	import models.LocalSetting;
	import models.vo.UserVO;

	public class VideoController
	{
		[DexterBinding(model="server",property="initSO")]
		public var initSO:SharedObject;
		[DexterBinding(model="connectionController",property="self")]
		public var self:UserVO;
		[DexterBinding]
		public var localSetting:LocalSetting;
		[DexterEvent]
		public function publishUserVideo(user:UserVO):void{
			if(user.id == initSO.data["publisher"]){
				
			}else{
//				initSO.data["publisher"] = user.id;
				initSO.setProperty("publisher",user.id);
			}
		}
		[DexterEvent]
		public function initSOchange_publisher(id:String):void{
			var inStream:NetStream = sendDexterEvent("getInStream") as NetStream;
			if(inStream)inStream.close();
			if(id == self.id){
				var outStream:NetStream = sendDexterEvent("initOutStream") as NetStream;
				outStream.attachCamera(localSetting.cam);
				outStream.attachAudio(Microphone.getMicrophone());
				outStream.publish("media");
				sendDexterEvent("playMediaCamera");
			}else{
				inStream = sendDexterEvent("initInStream",id) as NetStream;
				inStream.play("media");
				sendDexterEvent("playMediaStream");
			}
		}
	}
}