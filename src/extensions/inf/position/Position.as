package extensions.inf.position
{
	public class Position
	{
		private var _xPos:Number;
		private var _yPos:Number;
		
		public function Position(xPos:Number = 0, yPos:Number = 0)
		{
			_xPos = xPos;
			_yPos = yPos;
		}
		
		/**
		 * *********************************
		 * Getters and setters
		 * *********************************
		 */
		public function set xPos(x:Number):void {
			if(x > -1) {
				_xPos = x;
			} else {
				_xPos = 0;
			}
		}
		
		public function set yPos(y:Number):void {
			if(y > -1) {
				_yPos = y;
			} else {
				_yPos = 0;
			}
		}
		
		public function get xPos():Number {
			return _xPos;
		}
		
		public function get yPos():Number {
			return _yPos;
		}
	}
}