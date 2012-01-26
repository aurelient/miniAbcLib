package extensions.inf.external.tangibles.events
{
	import flash.events.Event;

	public class ScribbleEvent extends Event
	{
		public static const SCRIBBLE_CHANGED:String = "extensions.inf.external.tangibles.events.ScribbleEvent.SCRIBBLE_CHANGED";
		
		//Used to calculate the scaling of scribbles from tube menu to tube cap representation
		private var _scribbleCanvasWidth:uint;
		private var _scribbleCanvasHeight:uint;
		
		public function ScribbleEvent(type:String, scribbleCanvasWidth:uint, scribbleCanvasHeight:uint, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_scribbleCanvasHeight = scribbleCanvasHeight;
			_scribbleCanvasWidth = scribbleCanvasWidth;	
		}
		
		public function get scribbleCanvasHeight():uint {
			return _scribbleCanvasHeight;
		}
		
		public function get scribbleCanvasWidth():uint {
			return _scribbleCanvasWidth;
		}
	}
}