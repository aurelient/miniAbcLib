package core.comm
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	import mx.collections.ArrayCollection;

	/**
	 * This class holds download objects of files that are in the download process.
	 * Use this class to get information about the download of all new files
	 */
	public class ResourceDownloadList extends EventDispatcher
	{
		private var downloadList:ArrayCollection;
		private var _totalNumberOfDownloads:Number;
		
		public function ResourceDownloadList()
		{
			downloadList = new ArrayCollection();
		}
		
		public function addDownloader(downloader:FileDownloader):void {
			downloadList.addItem(downloader);
			downloader.addEventListener(Event.COMPLETE, onEvent);
			downloader.addEventListener(IOErrorEvent.IO_ERROR, onEvent);
		}
		
		public function get numberOfDownloads():Number {
			return _totalNumberOfDownloads - downloadList.length;
		}
		
		public function setTotalNumberOfDownloads():void {
			_totalNumberOfDownloads = downloadList.length;
		}
		
		public function get totalNumberOfDownloads():Number {
			return _totalNumberOfDownloads;
		}
		
		private function onEvent(event:Event):void {
			downloadList.removeItemAt(downloadList.getItemIndex(event.target));
			dispatchEvent(event);
		}
	}
}