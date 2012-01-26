package extensions.inf.external.windows
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.controls.Image;
	import mx.graphics.codec.PNGEncoder;
	
	import spark.components.BorderContainer;

	public class Window
	{
		private var _name:String;
		private var _application:String;
		private var _position:Point;
		private var _visible:Boolean;
				
		public function Window(name:String,x:int,y:int){
			this.name=name;
			this.application = getApplicationName(name);
			this.position = new Point(x>0?x:150,y>0?y:150);
			this.visible=false;
		}
		
		private function getApplicationName(windowName:String):String 
		{
			var nameElements:Array = windowName.split("-");
			if (nameElements.length < 1)
				return null;
			else 
				return nameElements.pop();
		}
		
		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			_visible = value;
		}

		public function get position():Point
		{
			return _position;
		}

		public function set position(value:Point):void
		{
			_position = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get application():String
		{
			return _application;
		}

		public function set application(value:String):void
		{
			_application = value;
		}


	}
}