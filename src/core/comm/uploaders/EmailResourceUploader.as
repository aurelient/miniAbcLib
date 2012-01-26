package core.comm.uploaders
{
	import core.abc.Activity;
	import core.abc.EmailResource;
	import core.abc.Resource;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class EmailResourceUploader extends ResourceUploader
	{
		public function EmailResourceUploader(activity:Activity, resource:Resource)
		{
			super(activity, resource);
			var emailResource:EmailResource = resource as EmailResource;
			var email:File = new File(resource.localPath);
			urlLoader.addFile(readFile(email, new ByteArray()), email.name, "Filedata");
			urlLoader.addVariable("subject", emailResource.subject);
			urlLoader.addVariable("recipients", emailResource.recipients);
		}
	}
}