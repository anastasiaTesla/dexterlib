package models.vo
{
	import flash.net.NetConnection;
	
	public class InStream extends GospelNetStream
	{
		public function InStream(connection:NetConnection, peerID:String="connectToFMS")
		{
			super(connection, peerID);
		}
		[DexterBinding(model="localSetting",property="bufferTime")]
		public function setBufferTime(v:Number):void{
			bufferTime = v;
		}
	}
}