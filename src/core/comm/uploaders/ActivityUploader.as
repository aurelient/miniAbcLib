	package core.comm.uploaders
{
	import core.abc.Activity;
	import core.comm.MultipartURLLoader;
	import core.comm.Settings;

	/**
	 * Upload a newly created activity that does not contain any resources
	 */
	public class ActivityUploader implements IUploadable
	{
		protected var urlLoader:MultipartURLLoader;
		//protected static var serverAddress:String = "http://pit.itu.dk/~mortenq/";
		protected static var serverAddress:String = Settings.getInstance().serverAddress;
		protected static var uploadResourcePath:String = "saveActivity.php";
		
		public function ActivityUploader(activity:Activity)
		{
			urlLoader = new MultipartURLLoader();
			urlLoader.addVariable("username", Settings.getInstance().userName);
			urlLoader.addVariable("id", activity.id);
			urlLoader.addVariable("activityname", activity.name);
		}
		
		public function upload():void
		{
			try {
				urlLoader.load(serverAddress + uploadResourcePath);
			} catch(e:Error) {
				
			}
		}
	}
}