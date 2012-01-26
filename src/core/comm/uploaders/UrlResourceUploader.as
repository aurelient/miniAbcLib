package core.comm.uploaders
{
	import core.abc.Activity;
	import core.abc.Resource;

	public class UrlResourceUploader extends ResourceUploader
	{
		public function UrlResourceUploader(activity:Activity, urlResource:Resource)
		{
			super(activity, urlResource);
			urlLoader.addVariable("path", urlResource.localPath);
		}
	}
}