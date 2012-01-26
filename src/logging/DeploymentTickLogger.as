package logging
{
	
	import core.comm.Settings;
	
	import flash.filesystem.File;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	
	public class DeploymentTickLogger
	{
		
		private static var _logger:mx.logging.ILogger;
		private var logFile:File;
		private var logTarget:LogTarget;
		
		/** SINGLETON  **/           
		protected static var _instance:DeploymentTickLogger=null;          
		
		public static function get instance():DeploymentTickLogger {       
			if (_instance == null)            
			{                   
				_instance = new DeploymentTickLogger();                       
			}      
			return _instance;          
		} 
		
		/**
		 * Singleton use DeploymentLogger.instance instead
		 */
		public function DeploymentTickLogger() 
		{
			// You can't get a private constructor in AS3.
			if (_instance != null)
			{
				throw new Error("DeploymentLogger can only be accessed through DeploymentLogger.instance");
			}
			else {
				
				// Create log file
				logFile = new File(Settings.getInstance().activitiesFolder.nativePath + 
									File.separator + "logs" + File.separator + "ticks.log");
				
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
				_logger = Log.getLogger("DeploymentTickLogger");
				logTarget.addLogger(_logger);
				
				
			}
		} 
		
		public function get logger():mx.logging.ILogger
		{
			return _logger;
		}
	}
}