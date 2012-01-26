package core.comm.uploaders {
	import core.abc.Activity;
	import core.abc.Resource;
	import core.comm.MultipartURLLoader;
	import core.comm.Settings;
	import core.events.MultipartURLLoaderEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	/**
	 * Super-class for uplosders
	 */
	public class ResourceUploader extends EventDispatcher implements IUploadable {
		protected var urlLoader:MultipartURLLoader
		//protected static var serverAddress:String = "http://pit.itu.dk/~mortenq/";
		protected static var serverAddress:String = Settings.getInstance().serverAddress;
		protected static var uploadResourcePath:String = "saveActivity.php";
		protected static var uploadStackResourcePath:String = "saveStack.php";
		private var path:String;

		public function ResourceUploader(activity:Activity, resource:Resource) {
			if (activity.id == "stack") {
				path = uploadStackResourcePath;
			} else {
				path = uploadResourcePath;
			}
			urlLoader = new MultipartURLLoader();
			urlLoader.addVariable("username", Settings.getInstance().userName);
			urlLoader.addVariable("id", activity.id);
			urlLoader.addVariable("activityname", activity.name);
			urlLoader.addVariable("type", getQualifiedClassName(resource));
			urlLoader.addVariable("resourceid", resource.id);
			urlLoader.addVariable("resourcename", resource.name);
			urlLoader.addVariable("timestamp", resource.timestamp);
			//Save scroll position aswell
			urlLoader.addVariable("scrollx", resource.horizontalScrollPosition);
			urlLoader.addVariable("scrolly", resource.verticalScrollPosition);
			urlLoader.addVariable("xpos", resource.xPos);
			urlLoader.addVariable("ypos", resource.yPos);
		}

		/**
		 * Upload resource async
		 */
		public function upload():void {
			try {
				urlLoader.addEventListener(Event.COMPLETE, onComplete);
				urlLoader.load(serverAddress + path);
			} catch (e:Error) {
				dispatchEvent(new Event("Error"));
			}
		}
		
		private function onComplete(event:Event):void {
			dispatchEvent(event);
		}

		/**
		 * Convert file to bytearray
		 */
		protected function readFile(file:File, data:ByteArray):ByteArray {
			try {
				var inStream:FileStream = new FileStream();
				inStream.open(file, FileMode.READ);
				inStream.readBytes(data, 0, data.bytesAvailable);
				inStream.close();
			} catch (e:Error) {

			}
			return data;
		}
	}
}