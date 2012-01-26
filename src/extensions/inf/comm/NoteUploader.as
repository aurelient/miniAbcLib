/**
 * Class for uloading notes
 */
package extensions.inf.comm
{
	import core.abc.Activity;
	import core.abc.Resource;
	import core.comm.Settings;
	import core.comm.uploaders.IUploadable;
	
	import extensions.inf.notes.Note;
	
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;

	public class NoteUploader implements IUploadable
	{
		private var _note:Note;
		private var _resource:Resource;
		private var _activity:Activity;
		
		//private static var serverAddress:String = "http://pit.itu.dk/~mortenq/saveNotes.php";
		private static var serverAddress:String = Settings.getInstance().serverAddress +  "saveNotes.php";
		
		/**
		 * Constructor
		 */
		public function NoteUploader(note:Note) {
			_note = note;
		}
		
		/**
		 * Upload notes to the server
		 */
		public function upload():void {
			var req:URLRequest = new URLRequest(serverAddress);
			req.method = URLRequestMethod.POST;
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.username = Settings.getInstance().userName;
			urlVariables.activity = _activity.id;
			urlVariables.resource = _resource.id;
			urlVariables.id = _note.id;
			urlVariables.subject = _note.subject;
			urlVariables.data = _note.text;
			req.data = urlVariables;
			var stream:URLStream = new URLStream();
			try {
				stream.load(req);
			} catch(e:Error) {
				trace("upload note error");
			} catch(e:IOError) {
				trace("upload note error");
			}
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