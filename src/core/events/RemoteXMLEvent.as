package core.events
{
	import flash.events.*;
	
	/**
	 * CustomEvent is a ValueObject 
	 * Working and using custom events with custom constants
	 *
	 * @author Filippo Lughi
	 * @version Actionscript 3.0
	 * source: http://englishblog.flepstudio.org/tutorials/flex-4/flex-4-combobox-mxml-and-external-xml/
	 */
	public class RemoteXMLEvent extends Event
	{
		private var _data:*;
		public static const ONLOADED:String="OnLoaded";
		
		/**
		 * Construct a new CustomEvent instance
		 *
		 * @param        .type                String
		 * @param        .data                *Universal
		 */
		public function RemoteXMLEvent (type:String,data:*)
		{
			this.data=data;
			super(type);
		}
		
		/**
		 * The data of the CustomEvent
		 */
		public function get data():*
		{
			return _data;
		}
		
		public function set data(d:*):void
		{
			_data=d;
		}
	}
}