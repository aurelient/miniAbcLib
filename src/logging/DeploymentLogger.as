package logging
{
	import core.comm.Settings;
	
	import flash.filesystem.File;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	
	public final class DeploymentLogger
	{
		private static var _logger:mx.logging.ILogger;
		private var logFile:File;
		private var logTarget:LogTarget;
		
		/** SINGLETON  **/           
		protected static var _instance:DeploymentLogger=null;          
		
		public static function get instance():DeploymentLogger {       
			if (_instance == null)            
			{                   
				_instance = new DeploymentLogger();                       
			}      
			return _instance;          
		} 
		
		/**
		 * Singleton use DeploymentLogger.instance instead
		 */
		public function DeploymentLogger() 
		{
			// You can't get a private constructor in AS3.
			if (_instance != null)
			{
				throw new Error("DeploymentLogger can only be accessed through DeploymentLogger.instance");
			}
			else {
			
				// Create log file
				logFile = new File(Settings.getInstance().activitiesFolder.nativePath + 
					File.separator + "logs" + File.separator + "events.log");
								
				//Create target and set it to log to the file
				logTarget = new LogTarget(logFile);
				
				// Log only messages for the classes in the packages listed.
				logTarget.filters=["application.*","core.abc.*"];
				
				// Set the log levels.
				logTarget.level = LogEventLevel.DEBUG;
				
				// Add date, time, category, and log level to the output.
				logTarget.includeDate = true;
				logTarget.includeTime = true;
				logTarget.includeCategory = true;
				logTarget.includeLevel = true;
				
				// Begin logging.
				_logger = Log.getLogger("DeploymentLogger");
				logTarget.addLogger(_logger);
				

			}
		} 
		
		public function get logger():mx.logging.ILogger
		{
			return _logger;
		}
		
		/**
		 * Utility function for logging the eLabBench deployment:
		 * @param level The log level (INFO, DEBUG...), get it from mx.logging.LogEventLevel. 
		 * @param timestamp The timestamp of the log pass the current Date, 
		 * @param location Where the log line comes from, should be dock or bench.
		 * @param user User name get it from Settings.getInstance().userName
		 * @param event The type of event logged (ex: create-resource)
		 * @param parameters the actual info related to the event 
		 */
		public function log(level:int,
							timestamp:Date,
							location:String,
							user:String,
							event:String,
							...parameters):void {
			var line:String = ";" + timestamp.time + ";" + user + ";" + event + ";";
			for each (var parameter:String in parameters)
			{
				line += parameter + ";";
			}
			_logger.log(level,line);
		}
	}
}