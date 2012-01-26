package core.comm.uploaders
{
	import core.abc.Activity;
	import core.abc.RackResource;
	import core.abc.Resource;
	
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;

	public class RackResourceUploader extends ResourceUploader
	{
		public function RackResourceUploader(activity:Activity, rackResource:Resource)
		{
			super(activity, rackResource);
			var file:File = new File(rackResource.localPath);
			trace("RackResourceUploader", "adding file to urlLoader", file.name);
			urlLoader.addFile(readFile(file, new ByteArray()), file.name, "Filedata");
			urlLoader.addVariable("rackId", (rackResource as RackResource).rackId);			
			
		}
	}
}