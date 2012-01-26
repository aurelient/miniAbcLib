package core.events
{
	import core.abc.Activities;
	import core.abc.Activity;
	import core.comm.ResourceDownloadList;
	
	import flash.events.Event;
	
	public class ActivitiesDownloadedEvent extends Event
	{	
		public static const COMPLETE:String = "success";
		private var activities:Activities;
		private var stack:Activity;
		private var resourceDownloadList:ResourceDownloadList;
		
		public function ActivitiesDownloadedEvent(type:String, bubbles:Boolean, cancelable:Boolean, activities:Activities, stack:Activity, resourceDownloadList:ResourceDownloadList)
		{
			super(type, bubbles, cancelable);
			this.resourceDownloadList = resourceDownloadList;
			this.activities = activities;
			this.stack = stack;
		}
		
		public function getActivities():Activities {
			return activities;
		}
		
		public function getStack():Activity {
			return stack;
		}
		
		public function getResourceDownloadList():ResourceDownloadList {
			return resourceDownloadList;
		}
		
		override public function clone() : Event {
			return new ActivitiesDownloadedEvent(type, bubbles, cancelable, activities, stack, resourceDownloadList);
		}
	}
}