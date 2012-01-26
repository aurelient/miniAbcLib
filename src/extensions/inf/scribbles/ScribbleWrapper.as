package extensions.inf.scribbles {

	[XmlClass]
	public class ScribbleWrapper {
		private var _scribbles:Scribbles;
		private var _scaleX:uint = 80;
		private var  _scaleY:uint = 80;

		public function ScribbleWrapper(scribbles:Scribbles = null) {
			_scribbles = scribbles;

		}

		[Bindable]
		[XmlArray(type="extensions.inf.scribbles.Scribble")]
		public function get scribbles():Scribbles {
			return _scribbles;
		}

		public function set scribbles(scribbles:Scribbles):void {
			_scribbles = scribbles;
		}
		
		public function set scaleX(scaleX:uint):void {
			_scaleX = scaleX;
		}
		
		[XmlElement]
		public function get scaleX():uint {
			return _scaleX;
		}
		
		public function set scaleY(scaleY:uint):void {
			_scaleY = scaleY;
		}
		
		[XmlElement]
		public function get scaleY():uint {
			return _scaleY;
		}
	}
}
