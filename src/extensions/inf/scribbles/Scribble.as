/**
 * Class representing one scribble line
 */package extensions.inf.scribbles
{
    [XmlClass]
	public class Scribble
	{
		private var _data:String;
		private var _color:uint;

		/**
		 * Constructor
		 * If no color is set red is set to default
		 */
		public function Scribble(data:String = "", color:uint = 0xFF0000 )
		{
			_data = data;
			if(color != 0) {
				_color = color;
			} else {
				_color = 0xFF0000;
			}
		}
		
		/**
		 * Serialize to XML
		 */
		public function toXml():XML {
			var scribbleXml:XML = <scribble/>;
			scribbleXml.data = _data;
			scribbleXml.color = _color;
			return scribbleXml;
		}
		
		/**
		 * ****************************************************
		 * Getters and setters
		 * ****************************************************
		 */
		[Bindable]
		public function get scribbleColor():uint {
			return _color;
		}
		
		public function set scribbleColor(c:uint):void {
			_color = c;
		}
		
		[Bindable]
		[XmlElement]
		public function get data():String {
			return _data;
		}
		
		public function set data(data:String):void {
			_data = data;
		}
	}
}