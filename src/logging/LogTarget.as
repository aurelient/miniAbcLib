package logging {
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.core.mx_internal;
	import mx.formatters.DateFormatter;
	import mx.logging.targets.LineFormattedTarget;
	
	use namespace mx_internal;

	public class LogTarget extends LineFormattedTarget {
		private const DEFAULT_LOG_PATH:String = "app-storage:/application.log";
		
		private var log:File;
		private var currentDay:Date = new Date();
		
		private var logLines:String;
		private var linesCount:int=0; 
		private var lastLog:Number;
		
		public var isThisReadable:Boolean = true; 
		
		public function LogTarget(logFile:File = null) {
			if(logFile != null)
			{
				log = logFile;
			}
			else
			{
				log = new File(DEFAULT_LOG_PATH);
			}
			// Creates the array containing the lines to log to files.
			logLines = new String();
			lastLog = new Date().time;

		}
		
		public function get logURI():String {
			return log.url;
		}
		
		mx_internal override function internalLog(message:String):void {
			write(message);
		}
		
		private function write(msg:String):void {
			if (rollingRequiredByDate) {
				rollLogFileByDate();
			}
			if (rollingRequiredBySize) {
				rollLogFileBySize();
			}
			
			var currentTime:Number = new Date().time;
			logLines += msg + File.lineEnding;
			linesCount++;

			// Before recording to disk, we check that it is worth it:
			// we have at least 1000 lines to dump 
			// or significant time passed between two events: 30000 ms
			// or the user logged out 
			if ((linesCount > 1000) || (lastLog < (currentTime - 30000))  || (msg.indexOf("logout;") != -1)) {
				//fs.writeUTFBytes(msg + File.lineEnding);
				var fs:FileStream = new FileStream();
				fs.open(log, FileMode.APPEND);
				fs.writeUTFBytes(logLines);
				fs.close();
				
				logLines = "";
				linesCount = 0;
				lastLog = currentTime;
			}
		}
		
		public function clear():void {
			var path:String = (log.nativePath);
			log.deleteFile();
			log = new File(path);
			
//			var fs:FileStream = new FileStream();
//			fs.open(log, FileMode.WRITE);
//			fs.writeUTFBytes("");
//			fs.close();
		}
		
		
		
		//
		// Code below copyrighted and modified from Hervé Labas, 
		// can be removed or rewritten contact auta@itu.dk
		// source:
		// https://github.com/hlabas/as3corelib/blob/master/src/com/adobe/air/logging/RollingFileTarget.as
		//
		/**
		 * Maximum weight of a log file in bytes.
		 * Defaults to approx 1Mb
		 * @see rollingRequiredBySize
		 */
		public var maxLogFileWeight:Number = 1000000;
		
		/**
		 * Creates a backup file using rolling interval configuration
		 */
		protected function rollLogFileByDate():void
		{
			// Use date to determine the backup file name
			var df:DateFormatter = new DateFormatter();
			df.formatString = "YYYY-MM-DD";
			var today:Date = new Date();
			today.date--;
			
			// Create backup of current log file
			var backupFileName:String = log.parent.nativePath + File.separator + df.format(today) + "-" + log.name;
			var backupFile:File = new File(backupFileName);
			log.copyTo(backupFile, true);
			
			// Clean the log now we have a backup
			clear();
			
		}
		
		/**
		 * Tells wether a file roll must be done
		 * @return true if a backup must be created, false otherwise
		 */
		protected function get rollingRequiredByDate():Boolean
		{
			if (!log.exists) {
				return false;
			}
			var df:DateFormatter = new DateFormatter();
			df.formatString = "YYMMDD";
			var logModificationDate:String = df.format(log.creationDate);
			var today:String = df.format(new Date());

			return !(today == logModificationDate);
		}
		
		/**
		 * Creates a backup file when the current log file's size reached its size limit
		 */
		protected function rollLogFileBySize():void
		{
			var index:Number = 1;
			while (index != 0)
			{
				var backupFileName:String = log.parent.nativePath + File.separator + log.name + "." + index;
				var backupFile:File = new File(backupFileName);
				if (backupFile.exists)
				{
					index++;
				}
				else
				{
					log.copyTo(backupFile, true);
					clear();
					index = 0;
				}
			}
		}
		
		/**
		 * Tells whether a backup file should be created by checking the file size
		 * @return true if a backup file must be created, false otherwise
		 */
		protected function get rollingRequiredBySize():Boolean
		{
			if (!log.exists || maxLogFileWeight == 0) {
				return false;
			}
			return (log.size > maxLogFileWeight);
		}
	} 
}