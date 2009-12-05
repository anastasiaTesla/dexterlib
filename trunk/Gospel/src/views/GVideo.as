package views
{
	import flash.media.Video;
	
	import mx.containers.Canvas;

	public class GVideo extends Canvas
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
			rawChildren.addChild(video);
		}
	}
}