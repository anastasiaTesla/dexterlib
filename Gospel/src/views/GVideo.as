package views
{
	import flash.media.Video;
	
	import mx.core.UIComponent;

	public class GVideo extends UIComponent
	{
		
		public var video:Video = new Video();
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			video.width = unscaledWidth;
			video.height = unscaledHeight;
		}
		public function GVideo()
		{
			super();
			addChild(video);
		}
	}
}