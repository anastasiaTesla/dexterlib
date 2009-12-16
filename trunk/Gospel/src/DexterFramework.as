package
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.IMXMLObject;
	
	public class DexterFramework implements IMXMLObject
	{
		public static var singletons:Object = {};
		public static var waitList:Object = {};
		public static var bindings:Dictionary = new Dictionary(true);
		private var _document:Object;
		public function detach():void{
			DexterEvent.DetachDexterEvent(_document);
			if(bindings[_document]){
				while(bindings[_document].length){
					bindings[_document].pop().unwatch();
				}
				delete 	bindings[_document];
			}
			_document = null;
		}
		public static function registerView(document:Object):void{
			var xml:XML = describeType(document);
			DexterEvent.JoinDexterEvent(document,xml);
			var xmlList:XMLList = xml.method + xml.variable + xml.accessor.(@access!="readonly");
			xmlList = xmlList.(children().(attribute("name") == "DexterBinding").length());
			for each(xml in xmlList){
				var argList:XMLList = xml.metadata.(@name == "DexterBinding")[0].arg;
				var name:String = argList.(@key == "model").length()?argList.(@key == "model")[0].@value:null;
				var property:String = argList.(@key == "property").length()?argList.(@key == "property")[0].@value:null;
				var waitBinding:WaitBinding = new WaitBinding(document,xml.@name,property);
				if(property && !name){
					waitBinding.WaitEnd(document);
				}else{
					if(!name)name = xml.@name;
					if(singletons[name]){
						waitBinding.WaitEnd(singletons[name]);
					}else{
						waitList[name] ||= [];
						waitList[name].push(waitBinding);
					}
				}
			}
		}
		public static function register(document:Object,id:String):void{
			registerView(document);
			if(waitList[id]){
				while(waitList[id].length){
					waitList[id].pop().WaitEnd(document);
				}
				delete waitList[id];
			}
			singletons[id] = document;
		}
		public function initialized(document:Object, id:String):void
		{
			if(getDefinitionByName(getQualifiedClassName(this)) != DexterFramework){
				register(this,id);
				_document = this;
			}else{
				registerView(document);
				_document = document;
			}
		}
	}
}
import mx.binding.utils.BindingUtils;

class WaitBinding{
	public var site:Object;
	public var prop:String;
	public var chain:String;
	public function WaitBinding(s:Object,p:String,c:String = null){
		site = s;
		prop = p;
		chain = c;
	}
	public function WaitEnd(target:Object):void{
		var isFunction:Boolean;
		try{
			if(site[prop] is Function)
				isFunction = true;
		}catch(e:Error){
		}
		if(chain){
			DexterFramework.bindings[site] ||= [];
			if(isFunction){
				DexterFramework.bindings[site].push(BindingUtils.bindSetter(site[prop],target,chain.split(".")));
			}else{
				DexterFramework.bindings[site].push(BindingUtils.bindProperty(site,prop,target,chain.split(".")));
			}
		}else{
			if(isFunction){
				site[prop](target);
			}else{
				site[prop] = target;
			}
		}
	}
}