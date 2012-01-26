package core.comm {
	import core.abc.Activities;
	import core.abc.Activity;
	import core.abc.Resource;
	import core.abc.ResourceType;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.getQualifiedClassName;

	public class DirectoryHandler {
		private static var directory:String = "Activities";
		private static var directoryXMLName:String = "";

		public function DirectoryHandler() {
		}

		/**
		 * Get working directory
		 */
		public function getDirectory():File {
			return Settings.getInstance().activitiesFolder;
		}

		/**
		 * Get an activity directory
		 * Bit tricky since folders are named with id's + the original activity name
		 */
		public function getActivityDirectory(activity:Activity):File {
			var dir:File;
			var activityDir:File = getDirectory();
			var contents:Array = activityDir.getDirectoryListing();
			for (var i:int = 0; i < contents.length; i++) {
				if ((contents[i] as File).name.indexOf(activity.id.toString()) != -1)
					dir = contents[i];
			}
			if (dir == null)
				dir = new File(activityDir.nativePath + File.separator + activity.id + "-" + activity.name + File.separator);
			return dir;
			//var dir:File = new File(File.userDirectory.nativePath + File.separator + directory + File.separator + activity.id + File.separator);
			//return dir;
		}

		/**
		 * Serialize all activities to XML
		 * Each activity folder will contain an activity.xml describing the activity and resources
		 * The activity root folder will contain activities.xml describing all activities
		 */
		public function serializeActivities(activities:Activities, stack:Activity = null):void {
			var fs:FileStream;
			var xmlString:String;
			for each (var activity:Activity in activities) {
				var fileName:String = getActivityDirectory(activity).nativePath + File.separator + "activity.xml"
				var xmlFile:File = new File(fileName);
				xmlString = '<?xml version="1.0" encoding="utf-8"?>\n';
				xmlString += activity.toXML().toXMLString();
				fs = new FileStream();
				fs.open(xmlFile, FileMode.WRITE);
				fs.writeUTFBytes(xmlString);
				fs.close();
			}
			fileName = getDirectory().nativePath + File.separator + "activities.xml"
			xmlFile = new File(fileName);
			xmlString = '<?xml version="1.0" encoding="utf-8"?>\n';
			xmlString += activities.toXML().toXMLString();
			//Ugly hack to also insert stack into the activities
			var sa:Array = xmlString.split("<activities>");
			var stackString:String = "<activities>\n";
			if (stack != null && sa.length > 1) {
				stackString += stack.toXML().toXMLString();
				xmlString = sa[0] + stackString + sa[1];
			}
			try {
				fs = new FileStream();
				fs.open(xmlFile, FileMode.WRITE);
				fs.writeUTFBytes(xmlString);
				fs.close();
			} catch (e:Error) {
				trace("Serialize activities error");
			}

		}


		/**
		 * While this function does work it may return true if a file is found in the activity-xml
		 * but is not on the file system or corrupted due to error when downloading. However we keep this method
		 * if we need to use it in conjunction with the new method
		 *
		 * Check is a file exists in an activity directory by looking in the activity xml
		 * Can be extended to also check timestamps for different file vesions
		 * TODO: Use ID's instead of names
		public function checkFileExists(activity:Activity, fileName:String):Boolean {
			var dir:File = getActivityDirectory(activity);
			if(dir.exists) {
				var activityXml:XML = readActivityXml(activity);
				if(activityXml != null) {
					if(activityXml.resources.file.(getResourceName(path) == getResourceName(fileName))[0] != null)
						return true;
					if(activityXml.resources.email.(getResourceName(path) == getResourceName(fileName))[0] != null)
						return true;
				}
			}
			return false;
		}
		 *
		 */

		/**
		 * Check if a file exists in an activity directory by comparing file names
		 */
		public function checkFileExists(activity:Activity, fileName:String):Boolean {
			var dir:File = getActivityDirectory(activity);
			if (dir.exists) {
				var contents:Array = dir.getDirectoryListing();
				for each (var file:File in contents) {
					if (file.name == fileName) {
						return true;
					}
				}
			}
			return false;
		}

		/**
		 * Get the name of a resource (use only on files)
		 * Splits on path
		 */
		public function getResourceName(path:String):String {
			var regEx:RegExp = new RegExp(/\\|\//);
			var fileNameArray:Array = path.split(regEx);
			var fileName:String = fileNameArray[fileNameArray.length - 1];
			return fileName;
		}

		/**
		 * Deletes a resource from an activity
		 * TODO: Delete based on ID's
		 */
		public function deleteResource(activity:Activity, resource:Resource):void {
			var activityDir:File = getActivityDirectory(activity);
			var activityXml:XML = readActivityXml(activity);
			var resourceType:String = getQualifiedClassName(resource);
			//Only delete file if the activity does not
			//contain other resources poiting to that file
			var deleteFile:Boolean = true;
			if (resourceType == ResourceType.PDF_RESOURCE || resourceType == ResourceType.FILE_RESOURCE || resourceType == ResourceType.IMAGE_RESOURCE ) {
				for each (var res:Resource in activity.resources) {
					if (res.localPath == resource.localPath) {
						deleteFile = false;
					}
				}
			}
			switch (resourceType) {
				case ResourceType.PDF_RESOURCE:
					var pdf:File = new File(activityDir.nativePath + File.separator + resource.name);
					var swf:File = new File((activityDir.nativePath + File.separator + resource.name).replace(".pdf", ".swf"));
					if (deleteFile) {
						if (pdf.exists)
							pdf.deleteFile();
						if (swf.exists)
							swf.deleteFile();
					}
					if (activityXml != null)
						delete activityXml.file.(path == resource.localPath)[0];
					break;
				case ResourceType.URL_RESOURCE:
					if (activityXml != null)
						delete activityXml.url.(path == resource.localPath)[0];
					break;
				case ResourceType.EMAIL_RESOURCE:
					//FIXME
					if (activityXml != null)
						delete activityXml.email.(path == resource.localPath)[0];
					break;
				case ResourceType.FILE_RESOURCE:
					var file:File = new File(activityDir.nativePath + File.separator + resource.name);
					if (deleteFile && file.exists)
						file.deleteFile();
					if (activityXml != null)
						delete activityXml.file.(path == resource.localPath)[0];
					break;
				case ResourceType.IMAGE_RESOURCE:
					var image:File = new File(activityDir.nativePath + File.separator + resource.name);
					if (deleteFile && image.exists)
						image.deleteFile();
					if (activityXml != null)
						delete activityXml.image.(@id == resource.id)[0];
					break;
				case ResourceType.RACK_RESOURCE:
//          trace("Deleting rack resource");
					var rack:File = new File(resource.localPath);
//          trace(rack.nativePath);
					if (rack.exists) {
//            trace("file exists, so deleting");
						rack.deleteFile();
					}
					if (activityXml != null)
						delete activityXml.file.(path == resource.localPath)[0];
					break;
			}
		}

		/**
		 * Delete an activity from the local file system
		 */
		public function deleteActivity(activity:Activity):void {
			var dir:File = getActivityDirectory(activity);
			var activitiesXml:XML = readActivitiesXml();
			if (dir.exists)
				dir.deleteDirectory(true);
			if (activitiesXml != null)
				delete activitiesXml.activity.(id = activity.id)[0];
		}

		/**
		 * Rename an activity
		 */
		public function renameActivity(activity:Activity, newName:String):void {
			var dir:File = getActivityDirectory(activity);
			if (dir.exists) {
				try {
					var newDir:File = getDirectory().resolvePath(File.separator + newName + File.separator);
					dir.moveTo(newDir, true);
				} catch (e:Error) {
					//trace("error");
				}
			}
		}

		/**
		 * Reads and returns the xml of an activity
		 */
		private function readActivityXml(activity:Activity):XML {
			var xmlFile:File = new File(getActivityDirectory(activity).nativePath + File.separator + "activity.xml");
			var activityXml:XML = new XML();
			if (xmlFile.exists) {
				try {
					var fs:FileStream = new FileStream();
					fs.open(xmlFile, FileMode.READ);
					activityXml = XML(fs.readUTFBytes(fs.bytesAvailable));
					fs.close();
				} catch (e:Error) {

				}
			}
			return activityXml;
		}

		/**
		 * Reads and returns the xml of all activities
		 */
		private function readActivitiesXml():XML {
			var xmlFile:File = new File(getDirectory().nativePath + File.separator + "activities.xml");
			var activityXml:XML = new XML();
			if (xmlFile.exists) {
				try {
					var fs:FileStream = new FileStream();
					fs.open(xmlFile, FileMode.READ);
					activityXml = XML(fs.readUTFBytes(fs.bytesAvailable));
					fs.close();
				} catch (e:Error) {

				}
			}
			return activityXml;
		}
	}
}
