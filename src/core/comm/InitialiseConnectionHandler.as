package core.comm {
	import air.net.URLMonitor;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.security.CertificateStatus;

	/**
	 * This class will check if a user exists, if the needed folders are in place
	 * or if they need to be created ect.
	 */
	public class InitialiseConnectionHandler extends EventDispatcher {

		private var userName:String;

		public function InitialiseConnectionHandler() {
		}

		/**
		 * Check if activities folder and settings file exist
		 * If no user is set return false
		 */
		public function initConnection(user:String = null):Boolean {
			userName = user;
			//Check if activities folder exists
			if (!checkActivityFolderExists()) {
				createActivitiesFolder();
			}

			//Check if settings file exists
			if (!checkSettingsExist()) {
				if (userName && userName != "") {
					setSettings(userName);
				} else {
					dispatchEvent(new Event("RequestUserName"));
					return false;
				}
			}

			//Check if username is set
			if (!checkUserName()) {
				dispatchEvent(new Event("RequestUserName"));
				return false;
			}
			return true;
		}

		/**
		 * Create settings file and user
		 */
		public function setSettings(user:String):Boolean {
			var s1:Boolean = createUser(user);
			var s2:Boolean = createSettingsFile(user);
			return s1 && s2;
		}

		/**
		 * Check if activity folder exists in the default location
		 */
		private function checkActivityFolderExists():Boolean {
			var folder:File = File.userDirectory.resolvePath("Activities");
			if (folder.exists)
				return true;
			return false;
		}

		/**
		 * Check if the settings file exist in the default location
		 */
		private function checkSettingsExist():Boolean {
			try {
				var settings:Settings = Settings.getInstance(userName);
			} catch (error:Error) {
				return false;
			}
			return true;
		}

		/**
		 * Check if the username is set correctly in the settings file
		 */
		private function checkUserName():Boolean {
			if (this.userName && this.userName != "") {
				var settings:Settings = Settings.getInstance(this.userName);
				return true;
			}
			var user:String = Settings.getInstance().userName;
			if (user && user != "")
				return true;
			return false;
		}

		/**
		 * Check if server address is set correctly in the settings file
		 */
		private function checkServerAddress():Boolean {
			var serverAddress:String = Settings.getInstance().serverAddress;
			if (serverAddress && serverAddress != "")
				return true;
			return false;
		}

		/**
		 * Create activity folder on local drive
		 */
		private function createActivitiesFolder():void {
			var folder:File = File.userDirectory.resolvePath("Activities");
			folder.createDirectory();
		}

		/**
		 * Create settings file
		 */
		private function createSettingsFile(user:String):Boolean {
			try {
				var settings:File;
				if(userName && userName != "") {
					settings = File.userDirectory.resolvePath("Activities" + File.separator + userName + File.separator + "settings.txt");
				} else {
					settings = File.userDirectory.resolvePath("Activities" + File.separator + "settings.txt");
				}
				var fs:FileStream = new FileStream();
				var info:String = "user=" + user + "\r\nserver=http://pit.itu.dk/eLabBench";
				fs.open(settings, FileMode.WRITE);
				fs.writeUTFBytes(info);
				fs.close();
			} catch (e:Error) {
				return false;
			}
			return true;
		}

		private function createUser(user:String):Boolean {
			try {
				var req:URLRequest = new URLRequest("http://pit.itu.dk/eLabBench/userRequest.php");
				var variables:URLVariables = new URLVariables();
				variables.request = "createuser";
				variables.username = user;
				req.method = URLRequestMethod.POST;
				req.data = variables;
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.load(req);
			} catch(e:Error) {
				trace("User request error");
			}
			return true;
		}
	}
}