package core.comm.uploaders {
	import core.abc.Activity;
	import core.abc.MachineResource;
	import core.abc.Resource;

	public class MachineResourceUploader extends ResourceUploader {
		public function MachineResourceUploader(activity:Activity, res:Resource) {
			super(activity, res);
			urlLoader.addVariable("path", res.localPath);
			var machRes:MachineResource = res as MachineResource;
			urlLoader.addVariable("machineId", machRes.machineId);
		}
	}
}
