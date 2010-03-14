package models.vo
{
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;

	public class ChatMsgVO
	{
		public var content:String;
		public var time:String;
		public var name:String;
		public static const IMGSPLIT:String = "¶";
		public function ChatMsgVO(o:Object = null)
		{
			for(var i:String in o){
				this[i] = o[i];
			}
		}
		public function toFlowElement(self:Boolean = false):Array{
			var p:ParagraphElement = new ParagraphElement();
			var head:SpanElement = new SpanElement();
			head.color = self?0x008800:0x000088;
			head.text = name+"  "+new Date().toLocaleTimeString();
			var array:Array = [];
			var str:String = content;
			var num:int = str.indexOf(IMGSPLIT);
			p.addChild(head);
			array.push(p);
			p = new ParagraphElement();
			while(num != -1){
				var se:SpanElement = new SpanElement();
				se.text = str.substr(0,num);
				if(se.text){
//					array.push(se);
					p.addChild(se);
				}
				var img:InlineGraphicElement = new InlineGraphicElement();
				img.source = str.substring(num+1,str.indexOf(IMGSPLIT,num+1));
//				array.push(img);
				p.addChild(img);
				str = str.substr(str.indexOf(IMGSPLIT,num+1)+1);
				num = str.indexOf(IMGSPLIT);
			}
			if(str){
				se = new SpanElement();
				se.text = str;
//				array.push(se);
				p.addChild(se);
			}
			p.paragraphStartIndent = 15;
			array.push(p);
			return array;
		}
	}
}