package extensions.inf.external.tangibles.data
{
	import core.comm.Settings;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import logging.DeploymentLogger;
	
	import mx.logging.LogEventLevel;
	
	public class MachineTag extends TaggedObject
	{
		
		private var machineURL:String = "";
		private var _machineName:String ="";
		
		public function MachineTag(iType:uint = 0, iCons:uint = 0, iMachineURL:String = "")
		{
			super(iType, iCons);
			if(iCons  > 81)
			{
				DeploymentLogger.instance.log(LogEventLevel.ERROR, new Date(), "bench", Settings.getInstance().userName, "marker-code-error", iType, iCons);
				throw new ArgumentError("Wrong machine tag code " + iCons, 0);
			}
			
			machineURL = iMachineURL;
			
			//This are fix values defined by the size of the machine tags 
			Width = 200;
			Height = 200;
		}
		
		public function get MachineName():String
		{
			return _machineName;
		}
		
		[Bindable]
		public function get MachineURL():String
		{
			return machineURL;
		}
		
		public function set MachineURL(value:String):void
		{
			machineURL = value;
		}
		
		public function LoadFromDB(dbFile:File):void
		{
			//      trace("MachineTag", "LoadFromDB. MachineId:" + this.ID);
			var fileStream:FileStream = new FileStream();
			fileStream.open(dbFile, FileMode.READ);
			var xmlString:String = fileStream.readUTFBytes(dbFile.size);
			fileStream.close();
			
			var xmlObj:XML = new XML(xmlString);
			for(var index:int = 0 ; index < xmlObj.tag.length() ; index++)
			{
				var xmlTag:XML = xmlObj.tag[index];
				var tagType:int = parseInt(xmlTag.type);
				var tagCons:int = parseInt(xmlTag.consecutive);
				if(Type != tagType || Consecutive != tagCons)
					continue;
				
				machineURL = xmlTag.url;
				_machineName = xmlTag.name;
				//        trace("MachineTag", "LoadFromDB. Found macth. Name:" + _machineName + " Url:" + machineURL);
				break;
			}
		}
		
	}
}