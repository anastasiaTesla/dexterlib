package controllers
{
	import flash.net.NetGroup;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import models.vo.UserVO;

	public class MessageController
	{
		[DexterBinding(model="stratus",property="netGroup")]
		public var netGroup:NetGroup;
//		private var trustMessages:Vector.<Array> = new Vector.<Array>();
		private var timers:Object = {};
		[DexterEvent]
		public function broadcast2(...arg):void{
			try{
				netGroup.post(arg);
			}catch(e:Error){
			}
			arg[0] = "$"+arg[0];
			DexterEvent.SendEvent.apply(DexterEvent,arg);
		}
		[DexterEvent]
		public function sendToOthers2(...arg):void{
			try{
				netGroup.post(arg);
			}catch(e:Error){
			}
		}
		[DexterEvent]
		public function broadcast(...arg):void{
			arg["t"] = getTimer();
			try{
				netGroup.post(arg);
			}catch(e:Error){
			}
			arg[0] = "$"+arg[0];
			DexterEvent.SendEvent.apply(DexterEvent,arg);
		}
		[DexterEvent]
		public function sendToOthers(...arg):void{
			arg["t"] = getTimer();
			try{
				netGroup.post(arg);
			}catch(e:Error){
			}
		}
		[DexterEvent]
		public function sendToUser(...arg):void{
			var user:UserVO = arg.shift() as UserVO;
			arg["t"] = getTimer();
			netGroup.sendToNearest(arg,user.groupAddress);
		}
		[DexterEvent]
		public function sendToUserTrust(...arg):void{
			arg["trust"] = getTimer();
//			trustMessages.push(arg);
			timers[arg["trust"].toString()] = setInterval(_sendToUserTrust,5000,arg);
			_sendToUserTrust(arg);
		}
		private function _sendToUserTrust(arg:Array):void{
			var user:UserVO = arg.shift() as UserVO;
			arg["t"] = getTimer();
			netGroup.sendToNearest(arg,user.groupAddress);
			arg.unshift(user);
		}
		[DexterEvent]
		public function trustAnswer(str:String):void{
			if(timers[str])
				clearInterval(timers[str]);
		}
	}
}