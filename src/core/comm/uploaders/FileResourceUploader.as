package core.comm.uploaders
{
	import core.abc.Activity;
	import core.abc.Resource;
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class FileResourceUploader extends ResourceUploader
	{
		public function FileResourceUploader(activity:Activity, fileResource:Resource)
		{
			super(activity, fileResource);
			var file:File = new File(fileResource.localPath);
			urlLoader.addFile(readFile(file, new ByteArray()), file.name, "Filedata");
		}
	}
}