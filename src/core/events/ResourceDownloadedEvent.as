package core.events
{
	import core.abc.Activity;
	import core.abc.Resource;
	
	import flash.events.Event;
	
	public class ResourceDownloadedEvent extends Event
	{	
		public static const COMPLETE:String = "success";
		private var resource:Resource;
		private var activity:Activity;
		
		public function ResourceDownloadedEvent(type:String, bubbles:Boolean, cancelable:Boolean, resource:Resource, activity:Activity)
		{
			super(type, bubbles, cancelable);
			this.resource = resource;
			this.activity = activity;
		}
		
		public function getResource():Resource {
			return resource;
		}
		
		public function getActivity():Activity {
			return activity;
		}
		
		override public function clone() : Event {
			return new ResourceDownloadedEvent(type, bubbles, cancelable, resource, activity);
		}
	}
}