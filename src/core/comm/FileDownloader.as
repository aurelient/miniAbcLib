package core.comm
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	/**
	 * Use this class to download files from the server
	 */
	public class FileDownloader extends EventDispatcher
	{
		private var stream:URLStream;
		private var urlRequest:URLRequest;
		private var file:File;
		
		private static var pullActivityPath:String = "recieveActivity.php";
		
		public function FileDownloader(path:String)
		{
			file = new File(path);
			var variables:URLVariables = new URLVariables();
			try {
				if(file.exists)
					file.deleteFile();
			} catch(error:Error) {
				trace("Error deleting file");
			}
			variables.username = Settings.getInstance().userName;
			variables.filename = file.name;
			urlRequest = new URLRequest(Settings.getInstance().serverAddress + pullActivityPath);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = variables;
		}
		
		public function download():void {
			try {
				stream = new URLStream();
				stream.addEventListener(Event.COMPLETE, downloadComplete);
				stream.addEventListener(IOErrorEvent.IO_ERROR, downloadFailed);
				stream.load(urlRequest);
			} catch(error:Error) {
				trace("Error loading request");
			}
		}
		
		private function downloadComplete(event:Event):void {
			try {
				var fileData:ByteArray = new ByteArray();
				stream.readBytes(fileData, 0, stream.bytesAvailable);
				var myFileStream:FileStream = new FileStream();
				myFileStream.open(file, FileMode.WRITE);
				myFileStream.writeBytes(fileData, 0, fileData.length);
				myFileStream.close();
				stream.close();
			} catch(error:Error) {
				trace("Error writing file");
			}
			dispatchEvent(event);
		}
		
		private function downloadFailed(event:IOErrorEvent):void {
			dispatchEvent(event);
		}
	}
}