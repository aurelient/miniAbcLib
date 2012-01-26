package extensions.inf.external
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;

	public class NativeServicesControler
	{
		protected var socket:Socket;
		private var port:uint = 13000;
		private var hostName:String = "localhost";
		
		public function NativeServicesControler() {
			try {
				socket = new Socket(); 
				socket.connect(hostName, port);
			}
			catch (e:IOErrorEvent) {
				trace("WindowManager.as: connection to server failed"); 
				trace("native server is probably down");
				trace (e);
			}

		}
		
		
		protected function send(string:String):void {
			if (!socket.connected) return;
			
			try {
				socket.writeUTF(string);
				socket.flush();
			}
			catch (e:IOErrorEvent) {
				trace("Send Native service order expection:\n", e);
			}
		}
		
		protected function disconnect():void {
			if (!socket.connected) return;

			try {
				socket.close();
				closeHandler(null);
			}
			catch (e:IOErrorEvent) {
				trace("Native service disconnect expection:\n", e);
			}
		}      
		

		protected function closeHandler(event:Event):void {
			trace("closeHandler: " + event);
		}
		
		protected function connectHandler(event:Event):void {
			trace("connectHandler: " + event);
		}
		
		protected function dataHandler(event:DataEvent):void {
			trace("dataHandler: " + event);
		}

		protected function dataComingHandler(event:ProgressEvent):void {
			trace("dataComingHandler: " + event);	
		}
	}
}