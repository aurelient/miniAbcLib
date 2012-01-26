package extensions.inf.external.windows
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.geom.Rectangle;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.sampler.NewObjectSample;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Image;
	
	import spark.components.BorderContainer;
	
	public class Windows extends ArrayCollection
	{	
		
		/**
		 * Constructor
		 */
		public function Windows()
		{

		}

		public function clear():void {
			this.removeAll();
		}
		
		/**
		 * Add a window
		 */
		public function add(window:Window):void 
		{
			this.addItem(window);
		}
		
		/**
		 * Remove a window
		 */
		public function remove(window:Window):void 
		{
			this.removeItemAt(this.getItemIndex(window));
		}
		
		public function getWindowByName(name:String):Window 
		{
			var i:int = 0;
			while  (i<this.length) {
				var win:Window = this.getItemIndex(i) as Window;
				if (win.name == name)
					return win;
				else i++;
			}
			return null;
		}
		
		/**
		 * Gets the first window have a name containing n
		 */
		public function getWindowContaining(name:String):Window
		{
			var i:int = 0 ;
			while  (i<this.length) {
				var win:Window = this.getItemAt(i) as Window;
				if (win.name.indexOf(name) != -1)
					return win;
				i++;
			}
			return null;
		}
		
		/**
		 * Gets the list of windows of application name
		 */
		public function getWindowsByApplication(name:String):Array
		{
			var windows:Array= new Array();
			var i:int = 0 ;
			while  (i<this.length) {
				var win:Window = this.getItemIndex(i) as Window;
				if (win.application == name)
					 windows.add(win);
				else i++;
			}
			return windows;
		}
	}
}