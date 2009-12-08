package models
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	dynamic public class SOProxy extends Proxy
	{
		flash_proxy override function getProperty(name:*) : *{
			return function(...arg):void{
				arg.unshift(name);
				DexterEvent.SendEvent.apply(DexterEvent,arg);
			};
		}
	}
}