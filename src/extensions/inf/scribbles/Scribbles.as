/**
 * Class representing a collection of scribbles
 */
package extensions.inf.scribbles
{
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;

	public class Scribbles extends ArrayCollection
	{
		private var _x:Number = 0;
		private var _y:Number = 0;
		
		/**
		 * Constructor
		 */
		public function Scribbles(...parameters)
		{
			super(parameters);
		}
		
		/**
		 * Add a scribble
		 */
		public function addScribble(scribble:Scribble):void {
			this.addItem(scribble);
		}
		
		/**
		 * Remove a scribble
		 */
		public function removeScribble(scribble:Scribble):void {
			if(this.getItemIndex(scribble) != -1)
				this.removeItemAt(this.getItemIndex(scribble));
		}

		/**
		 * Serialize to XML
		 */
		public function toXml():XML {
			if(this.length > 0 ) {
				var scribblesNode:XML = <scribbles/>;
				scribblesNode.@x = _x;
				scribblesNode.@y = _y;
				for each(var scribble:Scribble in this) {
					var scribblesXml:XML = scribble.toXml();
					scribblesNode.appendChild(scribblesXml);
				}
				return scribblesNode;
			}
			return null;
		}
		
		
		/**
		 * ****************************************************
		 * Getters and setters
		 * ****************************************************
		 */
		public function get x():Number {
			return _x;
		}
		
		public function get y():Number {
			return _y;
		}
		
		public function set x(x:Number):void {
			_x = x;
		}
		
		public function set y(y:Number):void {
			_y = y;
		}
	}
}