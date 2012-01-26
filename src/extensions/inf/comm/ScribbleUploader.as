/**
 * Class for uploading scribbless
 */
package extensions.inf.comm
{
	import core.abc.Activities;
	import core.abc.Activity;
	import core.abc.Resource;
	import core.comm.Settings;
	import core.comm.uploaders.IUploadable;
	
	import extensions.inf.scribbles.Scribble;
	import extensions.inf.scribbles.Scribbles;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;

	public class ScribbleUploader implements IUploadable
	{
		private var _scribbles:Scribbles;
		private var _resource:Resource;
		private var _activity:Activity;
		
		//private static var serverAddress:String = "http://pit.itu.dk/~mortenq/saveScribble.php";
		private static var serverAddress:String = Settings.getInstance().serverAddress + "saveScribble.php";
		
		/**
		 * Constructor
		 */
		public function ScribbleUploader(scribbles:Scribbles)
		{
			_scribbles = scribbles;
		}
		
		/**
		 * Upload notes to the server
		 */
		public function upload():void {
			if(_scribbles.length != 0) {
				if(_resource)
					_resource.scribbles = _scribbles;
				var scribbleXml:XML = prepareXml();
				var req:URLRequest = new URLRequest(serverAddress);
				req.method = URLRequestMethod.POST;
				var urlVariables:URLVariables = new URLVariables();
				urlVariables.username = Settings.getInstance().userName;
				urlVariables.activity = _activity.id;
				if(_resource) {
					urlVariables.resource = _resource.id;
				} else {
					urlVariables.resource = 0;
				}
				urlVariables.data = scribbleXml;
				req.data = urlVariables;
				var stream:URLStream = new URLStream();
				try {
					stream.load(req);
				} catch(e:Error) {
					//trace("Scribble upload error");
				}
			}
		}
		
		/**
		 * Serialize XML
		 */
		private function prepareXml():XML {
			var scribbleXml:XML = <scribbles/>;
			scribbleXml.addNamespace('<?xml version="1.0" encoding="utf-8"?>\n');
			scribbleXml.@x = _scribbles.x;
			scribbleXml.@y = _scribbles.y;
			for each(var scribble:Scribble in _scribbles) {
				scribbleXml.appendChild(scribble.toXml());
			}
			return scribbleXml;
		}
		
		/**
		 * *******************************************************
		 * Setters
		 * *******************************************************
		 */
		
		public function set activity(activity:Activity):void {
			_activity = activity;
		}
		
		public function set resource(resource:Resource):void {
			_resource = resource;
		}
	}
}