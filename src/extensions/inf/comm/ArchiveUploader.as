package extensions.inf.comm {
	import core.abc.Activity;
	import core.abc.Resource;
	import core.comm.Settings;
	import core.comm.uploaders.IUploadable;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;

	public class ArchiveUploader implements IUploadable {
		private var _resource:Resource;
		private var _activity:Activity;

		private static var serverAddress:String = Settings.getInstance().serverAddress + "archiveResource.php";

		public function ArchiveUploader(resource:Resource, activity:Activity) {
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
			var archive:int = 0;
			if(_resource.archived) {
				archive = 1;
			}
			urlVariables.archive = archive;
			req.data = urlVariables;
			var stream:URLStream = new URLStream();
			try {
				stream.load(req);
			} catch(e:Error) {
				
			}
		}
	}
}