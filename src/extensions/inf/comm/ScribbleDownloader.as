package extensions.inf.comm
{
	import core.abc.Activity;
	import core.abc.Resource;
	import core.comm.Settings;
	
	import extensions.inf.scribbles.Scribble;
	import extensions.inf.scribbles.Scribbles;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	
	public class ScribbleDownloader
	{
		// private static var serverAddress:String = "http://pit.itu.dk/~mortenq/getScribble.php";
		private static var serverAddress:String = Settings.getInstance().serverAddress +  "getScribble.php";
		private var scribblesAddress:String;
		private var resource:Resource;
		private var activity:Activity;
		
		public function ScribbleDownloader(xml:XML, resource:Resource = null, activity:Activity = null)
		{
			if(resource) {
				scribblesAddress = xml.child("scribble").path;
			} else if(activity) {
				scribblesAddress = xml.child("scribbles").path;
			}
			this.resource = resource;
			this.activity = activity;
		}
		
		public function download():void {
			if(scribblesAddress != null && scribblesAddress != "") {
				var req:URLRequest = new URLRequest(serverAddress);
				req.method = URLRequestMethod.POST;
				var urlVariables:URLVariables = new URLVariables();
				urlVariables.scribbleName = scribblesAddress;
				req.data = urlVariables;
				try {
					var stream:URLStream = new URLStream();
					stream.addEventListener(Event.COMPLETE, function writeXml():void {
						var scribbleXml:XML = XML(stream.readUTFBytes(stream.bytesAvailable));
						processScribble(scribbleXml);
					});
					
					stream.load(req);
				} 
				catch(e:Error) {
					trace("Scribble download error");
				}
				catch (ioe:IOError) {
					trace("Scribble download error:", ioe);
				}
			}
		}
		
		private function processScribble(scribbleXml:XML):void {
			var scribbles:Scribbles = new Scribbles();
			scribbles.x = scribbleXml.@x;
			scribbles.y = scribbleXml.@y;
			for each(var scribbleEntry:XML in scribbleXml.scribble) {
				var scribble:Scribble = new Scribble(scribbleEntry.data, scribbleEntry.color);
				scribbles.addScribble(scribble);
			}
			if(resource) {
				resource.scribbles = scribbles;
			} else if(activity) {
				activity.scribbles = scribbles;
			}
		}
	}
}