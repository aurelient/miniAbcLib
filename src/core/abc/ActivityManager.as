package core.abc
{
	import core.comm.DirectoryHandler;
	import core.comm.Server;
	import core.comm.Settings;
	import core.events.ActivitiesDownloadedEvent;
	import core.events.ActivityManagerEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.utils.getQualifiedClassName;
	
	import logging.DeploymentLogger;
	
	import mx.logging.Log;
	import mx.logging.LogEventLevel;

	/**
	 * Use this class for manipulating activities
	 */
	public class ActivityManager extends EventDispatcher
	{
		/** List of activities **/
		private var _activities:Activities;
		/** Connection to PHP server **/
		private var _server:Server;
		/** Handler of I/O with local storage **/
		private var _directoryHandler:DirectoryHandler;
		/** Stack **/
		private var _stack:Stack;
				
		public function ActivityManager()
		{
			_server = new Server();
			_directoryHandler = new DirectoryHandler();
			_activities = new Activities();
			_stack = new Stack("Stack");			
			_server.addEventListener(ActivitiesDownloadedEvent.COMPLETE, updated);
		}
		
		/**
		 * Update activities
		 */
		public function updateActivities():void {
			_server.updateActivities(_activities, _stack);
		}
		
		/**
		 * When updated we set the activities and stack and redispatch the event
		 */
		private function updated(event:ActivitiesDownloadedEvent):void {
			if(event.getActivities() != null)
				activities = event.getActivities();
			if(event.getStack() != null)
				_stack = event.getStack() as Stack;
			//Update local XML files
			saveActivities();
			dispatchEvent(event);
		}
		
		/**
		 * Save activites as XML 
		 */
		public function saveActivities():void {
			_directoryHandler.serializeActivities(_activities, _stack);
		}
		
		/**
		 * Create a new activity
		 */
		public function createActivity(name:String):Activity {
			var activity:Activity = new Activity(name);
			_activities.addItem(activity);
			_server.pushActivity(activity);
			return activity;
		}
		
		/**
		 * Asks the server to load a predefined activity into the user's list of activities
		 */
		public function loadPredefinedActivity(activityId:String):void {
			_server.loadPredefinedActivity(activityId);
		}
		
		public function createActivityListener(evt:ActivityManagerEvent):void {
			trace("create activity");
			createActivity(evt.activityName);
		}
		
		
		/**
		 * Get activity by id
		 */
		public function getActivity(id:String):Activity {
			for each (var activity:Activity in _activities) {
				if (id == activity.id) 
					return activity;
			}
			return null;
		}
		
		
		/**
		 * Adds a resource to an activity and uploads it
		 */
		public function addTo(activity:Activity, resource:Resource):void {
			activity.addResource(resource);
			var f:File;
			switch (getQualifiedClassName(resource)) {
				case ResourceType.FILE_RESOURCE: 
					f = (resource as FileResource).file;
					copyIfNew(f,activity,resource);
					break;
				case ResourceType.PDF_RESOURCE: 
					f = (resource as PdfResource).file;
					copyIfNew(f,activity,resource);
					break;
				case ResourceType.IMAGE_RESOURCE: 
					f = (resource as ImageResource).file;
					copyIfNew(f,activity,resource);
					break;
				case ResourceType.EMAIL_RESOURCE: 
					f = (resource as EmailResource).emailFile;
					copyIfNew(f,activity,resource);
					break;
				case ResourceType.RACK_RESOURCE: 
					f = (resource as RackResource).file;
					copyIfNew(f,activity,resource);
					break;
				case ResourceType.MACHINE_RESOURCE: break;
				case ResourceType.URL_RESOURCE: break;
			}
			_server.pushResource(activity, resource);
			
			DeploymentLogger.instance.log(
				mx.logging.LogEventLevel.INFO, new Date(), 
				Settings.getInstance().userName, "dock", "create-resource",
				activity.id, activity.name, 
				resource.id, resource.name);
		}
		
		private function copyIfNew(f:File,activity:Activity,resource:Resource):void {
			// check if the resource file is already in the user's local Activities folder  
			if (f.nativePath.indexOf(getActivitiesFolder().nativePath) < 0) {
				var newLocation:String = getActivityFolder(activity).nativePath + File.separator + resource.name;
				try {
					f.copyTo(new File(newLocation));
					resource.localPath = newLocation;
				} catch(e:Error) {
					
				}
			}
		}
		
		/**
		 * Delete a resource from an activity
		 */
		public function deleteResource(activity:Activity, resource:Resource):void {
			activity.removeResource(resource);
			_directoryHandler.deleteResource(activity,resource);
			_server.deleteResource(activity,resource);
		}
		
		/**
		 * Delete an activity
		 */
		public function deleteActivity(activity:Activity):void {
			_activities.deleteActivity(activity);
			_directoryHandler.deleteActivity(activity);
			_server.deleteActivity(activity);
		}
		
		public function deleteActivityListener(evt:ActivityManagerEvent):void {
			trace("delete activity");
			deleteActivity(evt.activity);
		}
		
		/**
		 * Rename an activity
		 */
		public function renameActivity(activity:Activity, newName:String):void {
			_server.renameActivity(activity, newName);
			_directoryHandler.renameActivity(activity, newName);
			activity.name = newName;
		}
		
		/**
		 * Rename a resource
		 */
		public function renameResource(activity:Activity, resource:Resource):void {
			_server.renameResource(activity, resource);
		}
			
		/**
		 * Uploads a resource to the server
		 */
		public function uploadResource(activity:Activity, resource:Resource):void {
			_server.pushResource(activity, resource);
		}
		
		/**
		 * Copies an activity on the server
		 */
		public function copyActivity(activity:Activity, newActivityId:String):void {
			_server.copyActivity(activity, newActivityId);
		} 
		
		/**
		 * Copies a resource on the server
		 */
		public function copyResource(activity:Activity, resource:Resource, newResourceId:String):void {
			_server.copyResource(activity, resource, newResourceId);
		}

		/**
		 * Get activities
		 */
		[Bindable]
		public function get activities():Activities {
			return _activities;
		}
		
		private function set activities(acts:Activities):void {
			_activities = acts;
		}
		
		/**
		 * Get stack
		 */
		public function get stack():Stack {
			return _stack;
		}
		
		/**
		 * Set stack
		 */
		public function set stack(stack:Stack):void {
			_stack = stack;
		}
		
		/**
		 * Get number of activites
		 */
		public function size():int {
			return _activities.length;
		}
		
		/**
		 * Check if an activity is in list of known activities
		 */
		public function contains(activity:Activity):Boolean {
			for each(var a:Activity in _activities) {
				if(a.equals(activity))
					return true;
			}
			return false;
		}
		
		
		/** 
		 * Returns the Folder where the activities are stored locally 
		 */
		public function getActivitiesFolder():File {
			return _directoryHandler.getDirectory();
		}
		
		/** 
		 * Returns the Folder where this activity is stored locally 
		 */
		public function getActivityFolder(activity:Activity):File {
			return _directoryHandler.getActivityDirectory(activity);
		}

	}
}