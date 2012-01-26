package core.abc
{
	import mx.collections.ArrayCollection;
	/**
	 * Collection for holding activities
	 */
	public class Activities extends ArrayCollection
	{
		public function Activities(...parameters)
		{
			super(parameters);
		}
		
		/**
		 * Create an activity and add it to the list
		 */
		public function createActivity(name:String):Activity {
			var activity:Activity = new Activity(name);
			this.addItem(activity);
			return activity;
		}
		
		/**
		 * Get an activity based on id
		 */
		public function getActivity(id:String):Activity {
			for each(var activity:Activity in this) {
				if(activity.id == id)
					return activity;
			}
			return null;
		}
		
		/**
		 * Serialize all activities to XML
		 */
		public function toXML():XML {
			var activitiesXML:XML = <activities />;
			for each(var activity:Activity in this) {
				activitiesXML.appendChild(activity.toXML());
			}
			return activitiesXML;
		}
		
		/**
		 * Check if an activity is in list of known activities
		 */
		public function containsActivity(activity:Activity):Boolean {
			for each(var a:Activity in this) {
				if(a.equals(activity))
					return true;
			}
			return false;
		}
		
		/**
		 * Delete an activity 
		 */
		public function deleteActivity(activity:Activity):void {
			for each(var a:Activity in this) {
				if(a.equals(activity)) {
					var itemIndex:int = this.getItemIndex(a);
					this.removeItemAt(itemIndex);
				}	
			}
		}
	}
}