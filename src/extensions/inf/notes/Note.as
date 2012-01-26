/**
 * Class representing a note
 */
package extensions.inf.notes
{
	public class Note
	{
		//Id made public to be able to sort on it
		[Bindable]
		public var _id:Number;
		[Bindable]
		private var _subject:String;
		private var _date:Date;
		private var _text:String;
		//Enable notes to be associated with specific locations within resourecs
		private var _x:Number;
		private var _y:Number;
		
		/**
		 * Constructor
		 */
		public function Note(id:Number=0, subject:String="", date:Date=null, text:String="")
		{
			_id = id;
			_subject = subject;
			_date = date;
			_text = text;
			if(_id == 0) {
				var creationDate:Date = new Date();
				_id = creationDate.getTime();
				_subject = creationDate.toDateString();
			}
			if(_date == null) {
				_date = new Date();
			}
		}
		
		/**
		 * ****************************************************
		 * Getters and setters
		 * ****************************************************
		 */
		[Bindable]
		public function get id():Number {
			return _id;
		}
		[Bindable]
		public function get subject():String {
			return _subject;
		}
		[Bindable]
		public function get date():Date {
			return _date;
		}
		[Bindable]
		public function get text():String {
			return _text;
		}
		
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
		
		public function set id(id:Number):void {
			_id = id;
		}
		
		public function set subject(subject:String):void {
			_subject = subject;
		}
		
		public function set date(date:Date):void {
			_date = date;
		}
		
		public function set text(text:String):void {
			_text = text;
		}
	}
}