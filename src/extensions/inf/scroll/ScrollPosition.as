/**
 * Save scroll position of a resource
 */
package extensions.inf.scroll
{
	public class ScrollPosition
	{
		private var _verticalScrollPosition:Number;
		private var _horizontalScrollPosition:Number;
		/**
		 * Constructor
		 */
		public function ScrollPosition(verticalScrollPosition:Number = 0, horizontalScrollPosition:Number = 0)
		{
			_verticalScrollPosition = verticalScrollPosition;
			_horizontalScrollPosition = horizontalScrollPosition;
		}
		
		/**
		 * Serialize to XML
		 */
		public function toXml():XML {
			var scrollXml:XML = <scrollPosition/>;
			var ver:XML = <vertical/>;
			ver.value = _verticalScrollPosition;
			var hor:XML = <horizontal/>;
			hor.value = _horizontalScrollPosition;
			scrollXml.appendChild(ver);
			scrollXml.appendChild(hor);
			return scrollXml;
		}
		
		/**
		 * *********************************
		 * Getters and setters
		 * *********************************
		 */
		public function set verticalScrollPosition(verticalScrollPosition:Number):void {
			_verticalScrollPosition = verticalScrollPosition;
		}
		
		public function set horizontalScrollPosition(horizontalScrollPosition:Number):void {
			_horizontalScrollPosition = horizontalScrollPosition;
		}
		
		public function get verticalScrollPosition():Number {
			return _verticalScrollPosition;
		}
		
		public function get horizontalScrollPosition():Number {
			return _horizontalScrollPosition;
		}
	}
}