package models.vo
{
	[Bindable]
	public class WaitVO
	{
		public function WaitVO(t:String,s:Object){
			type = t;
			source = s;
		}
		public var type:String;
		public var source:Object;
	}
}