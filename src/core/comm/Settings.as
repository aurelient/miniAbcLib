package core.comm {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class Settings {
		private static var _instance:Settings;
		private var _serverAddress:String;
		private var _userName:String;
		private var _activitiesFolder:File;

		public function Settings(sf:SingletonEnforcer, username:String) {
			_userName = username;
			loadSettings();
		}

		public static function getInstance(username:String = null):Settings {
			if (!_instance) {
				_instance = new Settings(new SingletonEnforcer, username);
			}
			return _instance;
		}

		public static function releaseSettings():void {
			if (_instance)
				_instance = null;
		}

		/**
		 * Load the settings from settings file
		 * If the file does not exist then throw exception
		 */
		public function loadSettings():void {
			var file:File;
			if (!_userName || _userName == "") {
				_activitiesFolder = File.userDirectory.resolvePath("Activities");
				file = File.userDirectory.resolvePath("Activities" + File.separator + "settings.txt");
			} else {
				_activitiesFolder = File.userDirectory.resolvePath("Activities" + File.separator + _userName);
				file = File.userDirectory.resolvePath("Activities" + File.separator + _userName + File.separator + "settings.txt");
			}
			if (file && file.exists) {
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				var content:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
				setStrings(content);
			} else {
				throw new Error();
			}
		}

		/**
		 * Process the loaded string and set parameters
		 */
		private function setStrings(content:String):void {
			var set:Array = content.replace(/\r/, "").split(/\n/);
			for each (var s:String in set) {
				var type:String = s.split("=")[0];
				switch (type) {
					case "user":
						if (!_userName || _userName == "")
							_userName = s.split("=")[1];
						break;
					case "server":
						_serverAddress = s.split("=")[1] + "/";
						break;
				}
			}
		}

		/************************************************
		 * 					Getters					    *
		 ************************************************/

		public function get serverAddress():String {
			return _serverAddress;
		}

		public function get userName():String {
			return _userName;
		}

		public function get activitiesFolder():File {
			return _activitiesFolder;
		}
	}
}

class SingletonEnforcer {
}
