package
{
	import flash.utils.describeType;
	
	import mx.core.IMXMLObject;
	
	public class DexterBeanLoader implements IMXMLObject
	{
		public function DexterBeanLoader()
		{
			
		}
		
		public function initialized(document:Object, id:String):void
		{
			var xmlList:XMLList = describeType(this).accessor;
			for each(var xml:XML in xmlList){
				DexterFramework.register(this[xml.@name],xml.@name);
			}
			document[id] = null;
		}
	}
}