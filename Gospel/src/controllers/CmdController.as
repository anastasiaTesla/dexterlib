package controllers
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import models.LocalSetting;
	import models.vo.UserVO;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	public class CmdController
	{
		[DexterBinding]
		public var localSetting:LocalSetting;
		[DexterBinding(model="userListController",property="userList")]
		public var userList:ArrayCollection;
		[DexterEvent]
		public function cmd(str:String):void{
			var array:Array = str.split(" ");
			var name:String = array.shift();
			try{
				this[name].apply(this,array);
			}catch(e:ReferenceError){
				sendDexterEvent("cmdOutput","无该命令");
			}catch(e:ArgumentError){
				sendDexterEvent("cmdOutput","命令参数有误："+e.message);
			}catch(e:Error){
				sendDexterEvent("cmdOutput",e.name+":"+e.message);
			}
		}
		private function sendNsConfig(...arg):void{
			var o:Object = {};
			if(arg.length){
				for each(var s:String in arg){
					try{
						o[s] = localSetting[s];
					}catch(e:ReferenceError){
						throw new ArgumentError();
					}
				}
			}else{
				o.multicastAvailabilitySendToAll = localSetting.multicastAvailabilitySendToAll;
				o.multicastAvailabilityUpdatePeriod = localSetting.multicastAvailabilityUpdatePeriod;
				o.multicastFetchPeriod = localSetting.multicastFetchPeriod;
				o.multicastPushNeighborLimit = localSetting.multicastPushNeighborLimit;
				o.multicastRelayMarginDuration = localSetting.multicastRelayMarginDuration;
				o.multicastWindowDuration = localSetting.multicastWindowDuration;
			}
			sendDexterEvent("sendToOthers","cmdNsConfig",o);
		}
		private function listUser(u:String = null):void{
			for(var i:int;i<userList.length;i++){
				var user:UserVO = userList.getItemAt(i) as UserVO;
				if(!u||user.name.indexOf(u)!=-1){
					sendDexterEvent("cmdOutput","("+user.id+")"+user.name+" "+user.ip+" "+user.address);
				}
			}
		}
		[DexterEvent]
		public function $cmdNsConfig(o:Object):void{
			for(var i:String in o){
				localSetting[i] = o[i];
			}
		}
	}
}