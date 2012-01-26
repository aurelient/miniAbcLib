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
	
	public class WindowsListener extends ArrayCollection
	{	
		private var server:ServerSocket;
		private var client:Socket;
		private var state:int=1; // 1=size, 2=width, 3=height, 4=data
		
		private var size:int=0;
		private var width:int=0;
		private var height:int=0;
		
		private var buffer:ByteArray = new ByteArray();
		private var imgBuffer:ByteArray = new ByteArray();
		private var read:int = 0;
		
		private var counter:int = 0;
		
		private var bench:BorderContainer;
		private var image:Image;
		private var window:Window;
		
		/**
		 * Constructor
		 */
		public function WindowsListener()
		{
			openSocket();
		}

		private function openSocket():void {
			try {
				server = new ServerSocket(); 
				server.addEventListener(Event.CONNECT, onServerSocketConnect); 
				server.bind(53440); 
				server.listen();
				trace("Client listenning");
			} catch (e:Error) {
				trace(e);
			}
		}
		
		// handle connection requests
		private function onServerSocketConnect(event:ServerSocketConnectEvent):void{
			// we are only expecting one client connection at a time in this demo so we must clean the reference
			if(client != null){
				client.removeEventListener(ProgressEvent.SOCKET_DATA, onClientSocketData);
			}
			client = event.socket;
			
			client.addEventListener(ProgressEvent.SOCKET_DATA, onClientSocketData, false, 0, true);
			trace("Client Connected: " + Socket(event.socket).remotePort);
		}
		
		// handle incoming data from the client
		private function onClientSocketData(event:ProgressEvent):void{
			// data comes in as a ByteArray so we use Socket.readBytes() to store them in a ByteArray object
			
			var windowInfo:String = client.readUTF();
			trace ("windows info: ", windowInfo);
		}
		
		private function onSendMessageClick(event:Event):void{
			if(client.connected){
				client.writeUTFBytes("This is a message from the server.");
				client.flush();
				trace( "Sending a message to the client");
			}
		}

		/**
		 * Add a window
		 */
		public function add(window:Window):void {
			this.addItem(window);
		}
		
		/**
		 * Remove a window
		 */
		public function remove(window:Window):void {
			this.removeItemAt(this.getItemIndex(window));
		}
	}
}