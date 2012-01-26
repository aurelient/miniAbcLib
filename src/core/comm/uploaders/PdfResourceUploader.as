package core.comm.uploaders
{
	import core.abc.Activity;
	import core.abc.Resource;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	/**
	 * FileResource specific uploader
	 */
	public class PdfResourceUploader extends ResourceUploader
	{
		public function PdfResourceUploader(activity:Activity, pdfResource:Resource) 
		{
			super(activity, pdfResource);
			var file:File = new File(pdfResource.localPath);
			urlLoader.addFile(readFile(file, new ByteArray()), file.name, "Filedata");
		}
	}
}