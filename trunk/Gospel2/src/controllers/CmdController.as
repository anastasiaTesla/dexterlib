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
		private function listUser(u:String = null):void{
			for(var i:int;i<userList.length;i++){
				var user:UserVO = userList.getItemAt(i) as UserVO;
				if(!u||user.name.indexOf(u)!=-1){
					sendDexterEvent("cmdOutput","("+user.id+")"+user.name+" "+user.ip+" "+user.address);
				}
			}
		}
	}
}