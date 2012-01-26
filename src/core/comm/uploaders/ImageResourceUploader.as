package core.comm.uploaders
{
	import core.abc.Activity;
	import core.abc.Resource;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class ImageResourceUploader extends ResourceUploader
	{
		public function ImageResourceUploader(activity:Activity, imageResource:Resource)
		{
			super(activity, imageResource);
			var image:File = new File(imageResource.localPath);
			urlLoader.addFile(readFile(image, new ByteArray()), image.name, "Filedata");
		}
	}
}