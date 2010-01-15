package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="complete", type="flash.events.Event")]
	public class DexterBindingSetter extends EventDispatcher
	{
		private var _target:Object;
		public var ignore:Boolean = true;
//		public function DexterBindingSetter()
//		{
//		}
//		[Bindable]
//		public function get target():Object
//		{
//			return _target;
//		}

		public function set target(value:Object):void
		{
//			_target = value;
			if(value || ignore == false){
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}

	}
}