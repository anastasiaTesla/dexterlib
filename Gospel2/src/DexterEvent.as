package
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import mx.core.IMXMLObject;

	public class DexterEvent implements IMXMLObject
	{
		private static var eventMap:Object = {};
		private static var objectMap:Dictionary = new Dictionary(true);
		public function initialized(document:Object,id:String):void
		{
			JoinDexterEvent(document);
			if(document != this) document[id] = null;
		}
		public static function SendEvent(name:String,...arg):*{
			var result0:Array = [];
			var result1:Array = [];
			if(!eventMap[name])return null;
			var array:Array = eventMap[name].concat();
			for each(var target:Object in array){
				var result:* = target[name].apply(target,arg);
				if(result!=null){
					result0.push(result);
					result1.push(target);
				}
			}
			if(result0.length == 1){
				return result0[0];
			}else if(result0.length>1){
				return [result0,result1];
			}else{
				return null;
			}
		}
		public static function GetDexterResult(name:String,...arg):Array{
			var result0:Array = [];
			for each(var target:Object in eventMap[name]){
				var result:* = target[name].apply(target,arg);
				if(result!=null)result0.push(result);
			}
			return result0;
		}
		public static function JoinDexterEvent(object:Object,xml:XML = null):void{
			if(objectMap[object]) return;
			xml||=describeType(object);
			var xmlList:XMLList = xml.method.(children().(attribute("name") == "DexterEvent").length());
			objectMap[object] = xmlList.length();
			for each(var method:XML in xmlList){
				eventMap[method.@name] ||= [];
				if(eventMap[method.@name].indexOf(object)==-1)eventMap[method.@name].push(object);
			}
		}
		public static function DetachDexterEvent(object:Object):void{
			delete objectMap[object];
			for each(var array:Array in eventMap){
				var i:int = array.indexOf(object);
				if(i!=-1)array.splice(i,1);
			}
		}
	}
}
