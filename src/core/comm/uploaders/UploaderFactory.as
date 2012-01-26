package core.comm.uploaders
{
	import core.abc.Activity;
	import core.abc.RackResource;
	import core.abc.Resource;
	import core.abc.ResourceType;
	
	import flash.utils.getQualifiedClassName;

	/**
	 * Factory responsible for creatin activity- and resource uploaders
	 */
	public class UploaderFactory
	{
		private var resourceUploader:ResourceUploader;
		
		public function UploaderFactory()
		{
		}
		
		public function getResourceUploader(activity:Activity, resource:Resource):ResourceUploader {
			var type:String = getQualifiedClassName(resource);
			switch(type) {
				case ResourceType.PDF_RESOURCE:
					resourceUploader = new PdfResourceUploader(activity, resource);
					break;
				case ResourceType.EMAIL_RESOURCE:
					resourceUploader = new EmailResourceUploader(activity, resource);
					break;
				case ResourceType.URL_RESOURCE:
					resourceUploader = new UrlResourceUploader(activity, resource);
					break;
				case ResourceType.FILE_RESOURCE:
					resourceUploader = new FileResourceUploader(activity, resource);
					break;
				case ResourceType.RACK_RESOURCE:
					resourceUploader = new RackResourceUploader(activity, resource);
					break;
				case ResourceType.MACHINE_RESOURCE:
					resourceUploader = new MachineResourceUploader(activity, resource);
					break;
				case ResourceType.IMAGE_RESOURCE:
					resourceUploader = new ImageResourceUploader(activity, resource);
			}
			return resourceUploader;
		}
		
		public function getActivityUploader(activity:Activity):ActivityUploader {
			return new ActivityUploader(activity);
		}
	}
}