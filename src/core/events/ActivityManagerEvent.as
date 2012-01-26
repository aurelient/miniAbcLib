package core.events
{
	import core.abc.Activity;
	
	import flash.events.Event;
	
	public class ActivityManagerEvent extends Event
	{
		private var _name:String=null;
		private var _activity:Activity=null;
		
		public static const NEW_ACTIVITY:String= "newActivity";
		public static const DEL_ACTIVITY:String= "deleteActivity";
		
		public function ActivityManagerEvent(type:String=null, bubbles:Boolean=false, cancelable:Boolean=false, name:String=null, activity:Activity=null)
		{
			super(type, bubbles, cancelable);
			_activity=activity;
			if (name!=null) 
			{
				_name=name;
			} else {
				_name = activity.name;
			}
		}
		
		override public function clone():Event
		{
			return new ActivityManagerEvent(type, bubbles, cancelable, activityName);
		}
		
		
		public function get activityName():String 
		{
			return _name;
		}
		
		public function get activity():Activity
		{
			return _activity;
		}
	}
}