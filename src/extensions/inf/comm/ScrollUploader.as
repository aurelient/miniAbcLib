package extensions.inf.comm
{
	import core.abc.Activity;
	import core.abc.Resource;
	import core.comm.Settings;
	import core.comm.uploaders.IUploadable;
	
	import extensions.inf.scroll.ScrollPosition;
	
	import flash.errors.IOError;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	
	public class ScrollUploader implements IUploadable
	{
		private var _resource:Resource;
		private var _activity:Activity;
		
		//private static var serverAddress:String = "http://pit.itu.dk/~mortenq/saveScroll.php";
		private static var serverAddress:String = Settings.getInstance().serverAddress +  "saveScroll.php";
		
		public function ScrollUploader(resource:Resource, activity:Activity)
		{
			_resource = resource;
			_activity = activity;
		}
		
		public function upload():void {
			var req:URLRequest = new URLRequest(serverAddress);
			req.method = URLRequestMethod.POST;
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.username = Settings.getInstance().userName;
			urlVariables.activity = _activity.id;
			urlVariables.resourceid = _resource.id;
			urlVariables.scrollx = _resource.horizontalScrollPosition;
			urlVariables.scrolly = _resource.verticalScrollPosition;
			req.data = urlVariables;
			try {
				var stream:URLStream = new URLStream();
			} catch(e:IOError) {
				trace(e);
			}
			try {
				stream.load(req);
			} catch(e:Error) {
				trace(e);
			}
		}
	}
}