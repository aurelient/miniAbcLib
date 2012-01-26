package core.comm {
	import core.abc.Activities;
	import core.abc.Activity;
	import core.abc.EmailResource;
	import core.abc.FileResource;
	import core.abc.ImageResource;
	import core.abc.MachineResource;
	import core.abc.PdfResource;
	import core.abc.RackResource;
	import core.abc.Resource;
	import core.abc.ResourceType;
	import core.abc.Stack;
	import core.abc.UrlResource;
	import core.comm.uploaders.ActivityUploader;
	import core.comm.uploaders.ResourceUploader;
	import core.comm.uploaders.UploaderFactory;
	import core.events.ActivitiesDownloadedEvent;

	import extensions.inf.comm.NoteDownloader;
	import extensions.inf.comm.ScribbleDownloader;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.*;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	import mx.logging.Log;
	import mx.messaging.channels.StreamingAMFChannel;

	/**
	 * Class handling loading and save activities and resources
	 */
	public class Server extends EventDispatcher {
		private var _directoryHandler:DirectoryHandler;

		private static var pushActivityPath:String = "saveActivity.php";
		private static var pullActivityPath:String = "recieveActivity.php";
		private static var loadPredefinedActivityPath:String = "loadPredefinedActivity.php";
		private static var getActivitiesPath:String = "getActivities.php";
		private static var deleteResourcePath:String = "deleteResource.php";
		private static var deleteActivityPath:String = "deleteActivity.php";
		private static var renameActivityPath:String = "changeActivityName.php";
		private static var renameResourcePath:String = "changeResourceName.php";
		private static var copyActivityPath:String = "copyActivity.php";
		private static var copyResourcePath:String = "copyResource.php";

		private var activities:Activities;
		private var newActivities:Activities;
		private var stack:Activity;
		private var newStack:Activity;
		private var isStack:Boolean;
		private var activitiesXML:XML;
		private var numActivities:Number;
		private var currentActivityNumber:Number;
		private var firstDownload:Boolean;
		private var activitiesChanged:Boolean;
		private var resourceUploaderFactory:UploaderFactory;
		private var settings:Settings;
		private var updateTime:Date;
		private var isBusy:Boolean;
		private var resourceDownloadList:ResourceDownloadList;

		public function Server() {
			resourceUploaderFactory = new UploaderFactory();
			_directoryHandler = new DirectoryHandler();
			settings = Settings.getInstance();
			firstDownload = true;
			isBusy = false;
		}

		/**
		 * Updates all activities, the stack and their resources.
		 * Fires ActivitiesDownloadedEvent when done
		 */
		public function updateActivities(activities:Activities, stack:Stack):void {
			if (isBusy)
				return;
			this.activities = activities;
			this.stack = stack;
			activitiesChanged = false;
			var req:URLRequest = new URLRequest(settings.serverAddress + getActivitiesPath);
			var urlVariables:URLVariables = new URLVariables();
			req.method = URLRequestMethod.POST;
			urlVariables.username = settings.userName;
			req.data = urlVariables;
			var stream:URLStream = new URLStream();
			stream.addEventListener(Event.COMPLETE, function writeXML(evt:Event):void {
				try {
					//trace(stream.readUTFBytes(stream.bytesAvailable));
					activitiesXML = XML(stream.readUTFBytes(stream.bytesAvailable));
					initDownload();
					firstDownload = false;
					stream.close();
				} catch (e:Error) {
					//trace(e.message, e.getStackTrace());
					//trace("parse activity xml error");
				}
			});
			//If offline on startup load activities from local file
			stream.addEventListener(IOErrorEvent.IO_ERROR, function loadLocalXml(evt:Event):void {
				if (firstDownload) {
					try {
						var xmlFile:File = new File(_directoryHandler.getDirectory().nativePath + File.separator + "activities.xml");
						var fs:FileStream = new FileStream();
						fs.open(xmlFile, FileMode.READ);
						activitiesXML = XML(fs.readUTFBytes(fs.bytesAvailable));
						fs.close();
						initDownload();
						firstDownload = false;
					} catch (e:Error) {
						trace("Offline problem");
					}
				}
			});
			try {
				stream.load(req);
			} catch (e:Error) {
				trace("load activities error");
			}
		}

		/**
		 * Upload a resource
		 */
		public function pushResource(activity:Activity, resource:Resource):void {
			isBusy = true;
			var resourceUploader:ResourceUploader = resourceUploaderFactory.getResourceUploader(activity, resource);
			resourceUploader.addEventListener(Event.COMPLETE, onComplete);
			resourceUploader.addEventListener("Error", onError);
			resourceUploader.upload();
		}

		/**
		 * Copy an activity
		 */
		public function copyActivity(activity:Activity, newActivityId:String):void {
			var req:URLRequest = new URLRequest(settings.serverAddress + copyActivityPath);
			req.method = URLRequestMethod.POST;
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.username = settings.userName;
			urlVariables.activityid = activity.id;
			urlVariables.newactivityid = newActivityId;
			req.data = urlVariables;
			var stream:URLStream = new URLStream();
			try {
				stream.load(req);
			} catch (e:Error) {
				//trace("delete resource error");
			}
		}

		/**
		 * Copy a resource
		 */
		public function copyResource(activity:Activity, resource:Resource, newResourceId:String):void {
			var req:URLRequest = new URLRequest(settings.serverAddress + copyResourcePath);
			req.method = URLRequestMethod.POST;
			var urlVariable:URLVariables = new URLVariables();
			urlVariable.username = settings.userName;
			urlVariable.activityid = activity.id;
			urlVariable.resourcecid = resource.id;
			urlVariable.newResourceId = newResourceId;
			req.data = urlVariable;
			var stream:URLStream = new URLStream();
			try {
				stream.load(req);
			} catch (error:Error) {

			}
		}

		/**
		 * Called when a resource is uploaded. Server is set to active again
		 */
		private function onComplete(event:Event):void {
			isBusy = false;
		}

		/**
		 * Called when an upload fails. Server is set to active again
		 */
		private function onError(event:Event):void {
			isBusy = false;
		}

		/**
		 * Upload an activity
		 */
		public function pushActivity(activity:Activity):void {
			var activityUploader:ActivityUploader = resourceUploaderFactory.getActivityUploader(activity);
			activityUploader.upload();
		}
		
		/**
		 * Adds a predefined activity into the user's list of activities
		 */
		public function loadPredefinedActivity(activityId:String):void {
			var req:URLRequest = new URLRequest(settings.serverAddress + loadPredefinedActivityPath);
			req.method = URLRequestMethod.POST;
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.username = settings.userName;
			urlVariables.id = activityId;
			req.data = urlVariables;
			var stream:URLStream = new URLStream();
			try {
				stream.load(req);
			} catch (e:Error) {
				//trace("rename error");
			}
		}
		
		/**
		 * Delete a resource from the server
		 */
		public function deleteResource(activity:Activity, resource:Resource):void {
			isBusy = true;
			var req:URLRequest = new URLRequest(settings.serverAddress + deleteResourcePath);
			req.method = URLRequestMethod.POST;
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.username = settings.userName;
			urlVariables.id = activity.id;
			urlVariables.resourcetype = getQualifiedClassName(resource);
			urlVariables.resource = resource.id;
			req.data = urlVariables;
			var stream:URLStream = new URLStream();
			stream.addEventListener(Event.COMPLETE, onComplete);
			stream.addEventListener(IOErrorEvent.IO_ERROR, onError);
			try {
				stream.load(req);
			} catch (e:Error) {
				//trace("delete resource error");
			}
		}

		/**
		 * Delete an activity from the server
		 */
		public function deleteActivity(activity:Activity):void {
			trace("Rename resource");
			var req:URLRequest = new URLRequest(settings.serverAddress + deleteActivityPath);
			req.method = URLRequestMethod.POST;
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.username = settings.userName;
			urlVariables.id = activity.id;
			req.data = urlVariables;
			var stream:URLStream = new URLStream();
			try {
				stream.load(req);
			} catch (e:Error) {
				//trace("delete resource error");
			}
		}

		/**
		 * Rename an activity
		 */
		public function renameActivity(activity:Activity, newName:String):void {
			var req:URLRequest = new URLRequest(settings.serverAddress + renameActivityPath);
			req.method = URLRequestMethod.POST;
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.username = settings.userName;
			urlVariables.id = activity.id;
			urlVariables.newname = newName;
			req.data = urlVariables;
			var stream:URLStream = new URLStream();
			try {
				stream.load(req);
			} catch (e:Error) {
				//trace("rename error");
			}
		}

		/**
		 * Rename a resource (assume that the resource has already been assigned a new name)
		 */
		public function renameResource(activity:Activity, resource:Resource):void {
			var req:URLRequest = new URLRequest(settings.serverAddress + renameResourcePath);
			req.method = URLRequestMethod.POST;
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.username = settings.userName;
			urlVariables.activity = activity.id;
			urlVariables.resource = resource.id;
			urlVariables.name = resource.name;
			req.data = urlVariables;
			var stream:URLStream = new URLStream();
			try {
				stream.load(req);
			} catch (e:Error) {
				//trace("rename error");
			}
		}

		/**
		 * Initiates download of resources
		 */
		private function initDownload():void {
			if (isBusy)
				return;
			updateTime = new Date();
			resourceDownloadList = new ResourceDownloadList();
			numActivities = activitiesXML.elements("activity").length();
			newActivities = new Activities();
			currentActivityNumber = 0;
			downloadActivity(activitiesXML);
		}

		/**
		 * Go through the xml describing activities and create activity-objects which are
		 * saved in a new collection to be compared to the previous activities
		 */
		private function downloadActivity(aXml:XML):void {
			for each (var xml:XML in aXml.activity) {
				var activityId:String = xml.@id;
				var activityName:String = xml.@name;
				if (activityName == null || activityName == "" || activityId == null || activityId == "")
					continue;
				var activity:Activity;
				if (activityId == "stack") {
					if (stack != null) {
						activity = new Stack(activityName);
						isStack = true;
					} else {
						activity = newStack;
						isStack = true;
					}
				} else {
					activity = new Activity(activityName, activityId);
					newActivities.addItem(activity);
					isStack = false;
				}
				for each (var pdf:XML in xml.resources.pdf) {
					var pdfPath:String = _directoryHandler.getActivityDirectory(activity).nativePath + File.separator + _directoryHandler.getResourceName(pdf.path);
					var p:File = new File(pdfPath);
					var pdfResource:PdfResource = new PdfResource(p, pdf.@id, new Date(Date.parse(pdf.timestamp)));
					pdfResource.name = pdf.name;
					pdfResource.xPos = pdf.@xpos;
					pdfResource.yPos = pdf.@ypos;
					pdfResource.archived = Boolean(int(pdf.archive));
					pdfResource.horizontalScrollPosition = pdf.@scrollx;
					pdfResource.verticalScrollPosition = pdf.@scrolly;
					addNotesAndScribbles(pdf, pdfResource);
					activity.addResource(pdfResource);
				}

				for each (var url:XML in xml.resources.url) {
					var urlResource:UrlResource = new UrlResource(url.path, url.@id, new Date(Date.parse(url.timestamp)), "", firstDownload);
					urlResource.name = url.name;
					urlResource.xPos = url.@xpos;
					urlResource.yPos = url.@ypos;
					urlResource.archived = Boolean(int(url.archive));
					urlResource.horizontalScrollPosition = url.@scrollx;
					urlResource.verticalScrollPosition = url.@scrolly;
					addNotesAndScribbles(url, urlResource);
					activity.addResource(urlResource);
				}

				for each (var machine:XML in xml.resources.machine) {
					var machineResource:MachineResource = new MachineResource(machine.name, machine.path, machine.@id, machine.@machineId, new Date(Date.parse(machine.timestamp)));
					machineResource.name = machine.name;
					machineResource.xPos = machine.@xpos;
					machineResource.yPos = machine.@ypos;
					machineResource.archived = Boolean(int(machine.archive));
					machineResource.horizontalScrollPosition = machine.@scrollx;
					machineResource.verticalScrollPosition = machine.@scrolly;
					addNotesAndScribbles(machine, machineResource);
					activity.addResource(machineResource);
				}


				for each (var email:XML in xml.resources.email) {
					var emailPath:String = _directoryHandler.getActivityDirectory(activity).nativePath + File.separator + _directoryHandler.getResourceName(email.path);
					var emailFile:File = new File(emailPath);
					var emailResource:EmailResource = new EmailResource(emailFile, email.@id, new Date(Date.parse(email.timestamp)));
					emailResource.name = email.name;
					emailResource.subject = email.subject;
					emailResource.recipients = email.recipients;
					emailResource.xPos = email.@xpos;
					emailResource.yPos = email.@ypos;
					emailResource.archived = Boolean(int(email.archive));
					emailResource.horizontalScrollPosition = email.@scrollx;
					emailResource.verticalScrollPosition = email.@scrolly;
					addNotesAndScribbles(email, emailResource);
					activity.addResource(emailResource);
				}
				for each (var file:XML in xml.resources.file) {
					var filePath:String = _directoryHandler.getActivityDirectory(activity).nativePath + File.separator + _directoryHandler.getResourceName(file.path);
					var f:File = new File(filePath);
					var fileResource:FileResource = new FileResource(f, file.@id, new Date(Date.parse(file.timestamp)));
					fileResource.name = file.name;
					fileResource.xPos = file.@xpos;
					fileResource.yPos = file.@ypos;
					fileResource.archived = Boolean(int(file.archive));
					fileResource.horizontalScrollPosition = file.@scrollx;
					fileResource.verticalScrollPosition = file.@scrolly;
					addNotesAndScribbles(file, fileResource);
					activity.addResource(fileResource);
				}
				for each (var image:XML in xml.resources.image) {
					var imagePath:String = _directoryHandler.getActivityDirectory(activity).nativePath + File.separator + _directoryHandler.getResourceName(image.path);
					var i:File = new File(imagePath);
					var imageResource:ImageResource = new ImageResource(i, image.@id, new Date(Date.parse(image.timestamp)));
					imageResource.name = image.name;
					imageResource.xPos = image.@xpos;
					imageResource.yPos = image.@ypos;
					imageResource.archived = Boolean(int(image.archive));
					imageResource.horizontalScrollPosition = image.@scrollx;
					imageResource.verticalScrollPosition = image.@scrolly;
					addNotesAndScribbles(image, imageResource);
					activity.addResource(imageResource);
				}

				for each (var rack:XML in xml.resources.rack) {
					var rackPath:String = _directoryHandler.getActivityDirectory(activity).nativePath + File.separator + _directoryHandler.getResourceName(rack.path);
					var rf:File = new File(rackPath);
					var rackResource:RackResource = new RackResource(rf, rack.@id, rack.@rackId, new Date(Date.parse(rack.timestamp)));
					rackResource.name = rack.name;
					rackResource.xPos = rack.@xpos;
					rackResource.yPos = rack.@ypos;
					rackResource.archived = Boolean(int(rack.archive));
					rackResource.horizontalScrollPosition = rack.@scrollx;
					rackResource.verticalScrollPosition = rack.@scrolly;
					addNotesAndScribbles(rack, rackResource);
					activity.addResource(rackResource);
				}

				if (isStack) {
					removeOldResources(activity, stack);
					addNewResources(activity, stack);
					newStack = activity;
				}
				addActivityScribbles(xml, activity);
			}
			removeOldActivities();
			addNewActivities();
			if (activitiesChanged) {
				resourceDownloadList.setTotalNumberOfDownloads();
				dispatchEvent(new ActivitiesDownloadedEvent(ActivitiesDownloadedEvent.COMPLETE, true, false, activities, newStack, resourceDownloadList));
			}
		}

		/**
		 * Add notes and scribbles to a resource
		 */
		private function addNotesAndScribbles(resourceXml:XML, resource:Resource):void {
			var scribbleDownloader:ScribbleDownloader = new ScribbleDownloader(resourceXml, resource, null);
			scribbleDownloader.download();
			var notesDownloader:NoteDownloader = new NoteDownloader(resourceXml, resource);
			notesDownloader.createNotes();
		}

		/**
		 * Add scribbles to an activity
		 */
		private function addActivityScribbles(activityXml:XML, activity:Activity):void {
			var scribbleDownloader:ScribbleDownloader = new ScribbleDownloader(activityXml, null, activity);
			scribbleDownloader.download();
		}

		/**
		 * Removes activities that has been deleted
		 */
		private function removeOldActivities():void {
			for each (var a1:Activity in activities) {
				if (!newActivities.containsActivity(a1)) {
					var itemIndex:int = activities.getItemIndex(a1);
					activities.removeItemAt(itemIndex);
					activitiesChanged = true;
				} else {
					var newActivtity:Activity = newActivities.getActivity(a1.id);
					for each (var resource:Resource in a1.resources) {
						if (!newActivtity.contains(resource)) {
							if (resource.timestamp.time < updateTime.time) {
								a1.removeResource(resource);
								activitiesChanged = true;
							}
						}
					}
				}
			}
		}

		/**
		 * Adds new activities and resources that have been downloaded,
		 * and download new files
		 */
		private function addNewActivities():void {
			for each (var newActivity:Activity in newActivities) {
				var activity:Activity = activities.getActivity(newActivity.id);
				if (activity == null) {
					activities.addItem(newActivity);
					addNewResources(newActivity, null);
					activitiesChanged = true;
				} else if (newActivity.name != activity.name) {
					//If renamed
					activity.name = newActivity.name;
					//Add new resources
					addNewResources(newActivity, activity);
					activitiesChanged = true;
				} else {
					//Add new resources
					addNewResources(newActivity, activity);
				}
			}
		}

		/**
		 * Remove deleted resources from an activity
		 */
		private function removeOldResources(newActivity:Activity, oldActivity:Activity):void {
			for each (var resource:Resource in oldActivity.resources) {
				if (!newActivity.contains(resource) && resource.timestamp.time < updateTime.time) {
					oldActivity.removeResource(resource);
					activitiesChanged = true;
				}
			}
		}

		/**
		 * Add new resources to an activity
		 */
		private function addNewResources(newActivity:Activity, oldActivity:Activity):void {
			if (oldActivity == null) {
				for each (var newResource:Resource in newActivity.resources) {
					activitiesChanged = true;
					var newResourceType:String = getQualifiedClassName(newResource);
					if (newResourceType == ResourceType.EMAIL_RESOURCE || newResourceType == ResourceType.PDF_RESOURCE || newResourceType == ResourceType.FILE_RESOURCE || newResourceType == ResourceType.RACK_RESOURCE || newResourceType == ResourceType.IMAGE_RESOURCE) {
						if (!_directoryHandler.checkFileExists(newActivity, _directoryHandler.getResourceName(newResource.localPath))) {
							downloadFile(newResource.localPath);
						}
					}
					if (newResourceType == ResourceType.PDF_RESOURCE) {
						if (!_directoryHandler.checkFileExists(newActivity, _directoryHandler.getResourceName(getSwfFilePath(newResource.localPath)))) {
							downloadSwf(newResource.localPath);
						}
					}
				}
			} else {
				for each (var resource:Resource in newActivity.resources) {
					var resourceType:String = getQualifiedClassName(resource);
					if (!oldActivity.contains(resource)) {
						oldActivity.addResource(resource);
						activitiesChanged = true;
						if (resourceType == ResourceType.EMAIL_RESOURCE || resourceType == ResourceType.PDF_RESOURCE || resourceType == ResourceType.FILE_RESOURCE || resourceType == ResourceType.RACK_RESOURCE || newResourceType == ResourceType.IMAGE_RESOURCE) {
							if (!_directoryHandler.checkFileExists(newActivity, _directoryHandler.getResourceName(resource.localPath))) {
								downloadFile(resource.localPath);
							}
						}
						if (resourceType == ResourceType.PDF_RESOURCE) {
							if (!_directoryHandler.checkFileExists(newActivity, _directoryHandler.getResourceName(getSwfFilePath(resource.localPath)))) {
								downloadSwf(resource.localPath);
							}
						}
					} else {
						var oldResource:Resource;
						for each (var r:Resource in oldActivity.resources) {
							if (r.id == resource.id) {
								oldResource = r;
							}
						}
						//If rack resource has been updated
						if (resourceType == ResourceType.RACK_RESOURCE) {
							if (resource.timestamp.time > oldResource.timestamp.time) {
								oldResource.timestamp = resource.timestamp;
								downloadFile(resource.localPath);
							}
						}
						//If pdf resource exists but .swf has not been downloaded
						if (resourceType == ResourceType.PDF_RESOURCE) {
							if (!_directoryHandler.checkFileExists(oldActivity, _directoryHandler.getResourceName(getSwfFilePath(resource.localPath)))) {
								downloadSwf(resource.localPath);
							}
						}
						//If resource has been renamed (quick fixed to compensate for URL resources being automatically
						//re-named when loaded)
						if (oldResource.name != resource.name && resource.name.indexOf("http://") == -1) {
							oldResource.name = resource.name;
						}
					}
				}
			}
		}


		/**
		 * Downloads a file from the server

		private function downloadFile(path:String):void {
			if (path != "" && path != null) {
				var file:File = new File(path);
				var variables:URLVariables = new URLVariables();
				try {
					if(file.exists)
						file.deleteFile();
					variables.username = settings.userName;
					variables.filename = file.name;
					var req:URLRequest = new URLRequest(settings.serverAddress + pullActivityPath);
					req.method = URLRequestMethod.POST;
					req.data = variables;
					var stream:URLStream = new URLStream();
					stream.addEventListener(Event.COMPLETE, function saveFile(evt:Event):void {
						var fileData:ByteArray = new ByteArray();
						stream.readBytes(fileData, 0, stream.bytesAvailable);
						var myFileStream:FileStream = new FileStream();
						myFileStream.open(file, FileMode.WRITE);
						myFileStream.writeBytes(fileData, 0, fileData.length);
						myFileStream.close();
						stream.close();
					});
					stream.load(req);
				} catch (e:Error) {
					trace(e.getStackTrace());
				}
			}
		}*/


		private function downloadFile(path:String):void {
			var fd:FileDownloader = new FileDownloader(path);
			resourceDownloadList.addDownloader(fd);
			fd.download();
		}

		/**
		 * Get swf file name
		 */
		private function getSwfFilePath(path:String):String {
			var newPath:String = path.replace(".pdf", ".swf");
			return newPath;
		}

		/**
		 * Downloads the SWF created from a PDF
		 */
		private function downloadSwf(path:String):void {
			var newPath:String = getSwfFilePath(path);
			downloadFile(newPath);
		}

		/**
		 * Convert file to bytearray
		 */
		private function readFile(file:File, data:ByteArray):ByteArray {
			var inStream:FileStream = new FileStream();
			try {
				inStream.open(file, FileMode.READ);
				inStream.readBytes(data, 0, data.bytesAvailable);
				inStream.close();
			} catch (e:Error) {
				trace("error reading file");
			}
			return data;
		}
	}
}
