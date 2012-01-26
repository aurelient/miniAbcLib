package core.control
{
	import core.abc.Activity;
	import core.abc.ActivityManager;
	import core.abc.EmailResource;
	import core.abc.FileResource;
	import core.abc.ImageResource;
	import core.abc.PdfResource;
	import core.abc.RackResource;
	import core.abc.Resource;
	import core.abc.UrlResource;
	import core.comm.DirectoryHandler;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.InteractiveObject;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	import flash.xml.XMLDocument;
	
	import flashx.textLayout.conversion.TextConverter;
	
	import mx.collections.ArrayList;

	public class ResourceDragDropHandler
	{
		private var _activity:Activity;
		private var _manager:ActivityManager;
		
		public function ResourceDragDropHandler(activity:Activity, activityManager:ActivityManager) {
			this._manager = activityManager;
			this._activity = activity;
			
		}
		
		
		public function onDragEnterResource(event:NativeDragEvent,source:InteractiveObject):void {
			if(event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)) {
				//get the array of files
				var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				
				//make sure only one file is dragged in (i.e. this app doesn't
				//support dragging in multiple files)
				if(files == null) {
					NativeDragManager.acceptDragDrop(source);
				}
				else if(files.length == 1)
				{
					//accept the drag action
					NativeDragManager.acceptDragDrop(source);
				}
			} 
			else if (event.clipboard.hasFormat(ClipboardFormats.URL_FORMAT)) 
			{
				//accept the drag action
				NativeDragManager.acceptDragDrop(source);
			}
		}
		
		public function onDrop(e:NativeDragEvent):ArrayList {
			//trace("Dropped: ",
			//		e.clipboard.hasFormat(ClipboardFormats.HTML_FORMAT),
			//		e.clipboard.hasFormat(ClipboardFormats.RICH_TEXT_FORMAT),
			//		e.clipboard.hasFormat(ClipboardFormats.TEXT_FORMAT),
			//		e.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT),
			//		e.clipboard.hasFormat(ClipboardFormats.URL_FORMAT),
			//		e.clipboard.hasFormat(ClipboardFormats.BITMAP_FORMAT)
			//);
			var resources:ArrayList = new ArrayList();
			if (e.clipboard.hasFormat("resource"))
			{
				trace ("don't do anything - just move it");		
				return null;
			}
			
			if(e.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)) 
			{
				//get the array of files
				var files:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				
				//if there is no files and the os is Windows then it's probably an email 
				if(files == null && Capabilities.os.indexOf("Windows")!=-1) {
					resources.addItem(this.emailDropHandle(e));
				}
				else {
					resources.addAll(this.fileDropHandle(e));
				}
			}
			else if (e.clipboard.hasFormat(ClipboardFormats.URL_FORMAT)) 
			{
				resources.addItem(this.urlDropHandle(e));
			}
			else if (e.clipboard.hasFormat(ClipboardFormats.TEXT_FORMAT)) 
			{
				resources.addItem(this.emailDropHandle(e));
			}
			return resources;
		}
		
		
		/**
		 * Dropped emails handling
		 */
		private function emailDropHandle(e:NativeDragEvent):Resource {
			if(e.clipboard.hasFormat(ClipboardFormats.TEXT_FORMAT)) {
				//trace("Text format");
			} else {
				//trace("No text format");
			}
			
			var content:String = e.clipboard.getData(ClipboardFormats.TEXT_FORMAT) as String;
			try {
				//trace("\n\nEMAIL:", content, "\n\n");
				var message:Array = content.split('ABCdockEmail-Header=')[1].split('ABCdockEmail-Body=');
				var header:String = message[0];
				var id:Number = parseInt(header.split("\nSubject:")[0].split("Id:")[1]);
				var subject:String = header.split("\nSubject:")[1].split("\nTo:")[0];
				var recipients:String = header.split("\nSubject:")[1].split("\nTo:")[1];
				var messageBody:String = message[1];
				//trace("header:", header);
				//trace("email:", id);
				//trace("email:", recipients);
				//trace("email:", subject);
				//trace("email:", messageBody);
				
				
				var dh:DirectoryHandler = new DirectoryHandler();
				var dir:File = dh.getActivityDirectory(_activity);
				var emailFile:File = new File(dir.nativePath + File.separator + id.toString() + '.html');
				
				var fileStream:FileStream = new FileStream();
				fileStream.open(emailFile, FileMode.WRITE);
				fileStream.writeUTFBytes(messageBody);
				fileStream.close();
				
				
				// FIX email upload, 
				var emailResource:EmailResource = new EmailResource(emailFile,id, new Date());
				emailResource.subject = subject;
				emailResource.recipients = recipients;

				_manager.addTo(_activity, emailResource);
				return emailResource;
			} catch (e:Error) {
				//trace (e);
			}			
			return null;
		}
		
		
		/**
		 * Dropped file handling
		 */
		private function fileDropHandle(e:NativeDragEvent):ArrayList {
			//get the array of files being drug into the app
			var arr:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			
			//grab the files file
			var f:File = File(arr[0]);

			var resources:ArrayList = new ArrayList();
			
			for each (var item:File in arr) 
			{
				var res:Resource;
				var fileId:Number = new Date().getTime();
				//trace("file ", item.extension);
				switch (item.extension.toLowerCase()) {
					case RackResource.FILETYPE:
						//trace("Found RackResource");
						
						var id:Number = new Date().getTime();
						
						// Get the rackId
						var fileStream:FileStream = new FileStream();
						fileStream.open(item, FileMode.READ);
						var rawXml:String = fileStream.readUTF();
						fileStream.close();
						
						var xml:XMLDocument = new XMLDocument(rawXml);
						var _type:Number = xml.firstChild.attributes.type as Number
						var _consec:Number = xml.firstChild.attributes.Consecutive as Number
						var _rackId:String = "0x"+ (_type + _consec).toString(16);
						
						res = new RackResource(item,id,_rackId, new Date());
						res.timestamp = new Date();
						
						break;
					case "pdf": 
						res = new PdfResource(item, fileId, new Date());
						res.timestamp = new Date();
						break;
					case "png":
						res = new ImageResource(item, fileId, new Date());
						res.timestamp = new Date();
						break;
					case "jpg":
						res = new ImageResource(item, fileId, new Date());
						res.timestamp = new Date();
						break;
					case "jpeg":
						res = new ImageResource(item, fileId, new Date());
						res.timestamp = new Date();
						break;
					default:
						res = new FileResource(item, fileId, new Date());
						res.timestamp = new Date();
						break;
				}
				
				_manager.addTo(_activity, res);
				resources.addItem(res);
				//trace("file ", item);
				//trace("filename", item.name, "type", item.type);
			}
			return resources;
		}
		
		/**
		 * Dropped URL handling
		 */
		private function urlDropHandle(e:NativeDragEvent):Resource 
		{
			var url:String = e.clipboard.getData(ClipboardFormats.URL_FORMAT) as String;
			
			var type:String = url.split(':')[0]; 
			if (type == 'http' || type == 'https') 
			{
				//trace("url", url);
				var urlId:Number = new Date().getTime();
				var urlResource:UrlResource = new UrlResource(url,urlId,new Date(), "", true);
				_manager.addTo(_activity, urlResource);
				return urlResource;
			}
			else {
				return emailDropHandle(e);
			}
		}
	}
}