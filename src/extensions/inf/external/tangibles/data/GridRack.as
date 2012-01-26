package extensions.inf.external.tangibles.data {
	import com.adobe.air.filesystem.FileMonitor;
	import com.googlecode.flexxb.FlexXBEngine;
	import com.googlecode.flexxb.core.FxBEngine;
	import com.googlecode.flexxb.core.IFlexXB;
	import com.googlecode.flexxb.xml.annotation.XmlArray;
	import com.googlecode.flexxb.xml.annotation.XmlAttribute;
	
	import core.comm.Settings;
	
	import extensions.inf.scribbles.Scribble;
	import extensions.inf.scribbles.ScribbleWrapper;
	import extensions.inf.scribbles.Scribbles;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import logging.DeploymentLogger;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.graphics.shaderClasses.ExclusionShader;
	import mx.logging.LogEventLevel;

	[Bindable]
	public class GridRack extends TaggedObject {

		private var rows:uint = 4;
		private var columns:uint = 5;
		private var tubeDiameterPx:uint = 30;

		private var _datafile:File = null;

		private var tubes:ArrayCollection = null;

		//Specifies how much the rack should be scaled up from its origional size
		private var _scale:uint;
		
		public function GridRack(iType:uint = 0, iID:uint = 0) {
			super(iType, iID);
			if (iID != 0 && iID != 10) {
				DeploymentLogger.instance.log(LogEventLevel.ERROR, new Date(), "bench", Settings.getInstance().userName, "marker-code-error", iType, iID);
				throw new ArgumentError("Wrong rack code " + iID, 0);
			}
			loadProperties();
		}

		[XmlAttribute]
		public function get Rows():uint {
			return rows;
		}

		public function set Rows(value:uint):void {
			rows = value;
		}

		[XmlAttribute]
		public function get Columns():uint {
			return columns;
		}

		public function set Columns(value:uint):void {
			columns = value;
		}

		[XmlAttribute]
		public function get TubeDiameterPx():uint {
			return tubeDiameterPx;
		}

		public function set TubeDiameterPx(value:uint):void {
			tubeDiameterPx = value;
		}

		[XmlArray(type="extensions.inf.external.tangibles.data.Tube")]
		public function get Tubes():ArrayCollection {
			return tubes;
		}

		public function set Tubes(value:ArrayCollection):void {
			tubes = value;
		}
		
		public function get Scale():uint {
			return _scale;
		}

		public function set Scale(scale:uint):void {
			_scale = scale;
		}
		
		public function loadProperties():void {
			switch (Type) {
				case TaggedObject.RACKPINKFOAM: //Pink Foam
					Width = 450;
					Height = 260;
					Rows = 3;
					Columns = 5;
					TubeDiameterPx = 60;
					Scale = 2;
					break;
				case TaggedObject.RACKMULTIORANGE: //Multi Orange
					Width = 330;
					Height = 180;
					Rows = 4;
					Columns = 8;
					TubeDiameterPx = 30;
					Scale = 2;
					break;
				case TaggedObject.RACKWIREDBLUE: //Wired Blue
					Width = 300;
					Height = 300;
					Rows = 4;
					Columns = 4;
					TubeDiameterPx = 60;
					Scale = 2;
					break;
				case TaggedObject.RACKBLACK:
					Width = 450;
					Height = 120;
					Rows = 5;
					Columns = 16;
					TubeDiameterPx = 20;
					Scale = 2;
					break;
				case TaggedObject.RACKFORPCR:
				default:
					Width = 270;
					Height = 170;
					Rows = 8;
					Columns = 12;
					TubeDiameterPx = 15;
					Scale = 2;
					break;
			}

			if (Tubes == null || Tubes.length == 0) {
				Tubes = new ArrayCollection();
				var totalTubes:int = Rows * Columns;
				for (var index:int = 0; index < totalTubes; index++)
					Tubes.addItem(new Tube(index, this));
			} else {
				for each (var tube:Tube in Tubes) {
					tube.IsNew = false;
					tube.Rack = this;
				}
			}
		}

		private function ShrinkForStorage():void {
			var notEmpty:Array = tubes.source.filter(function(obj:Object, index:int, arr:Array):Boolean {
				return !(obj as Tube).IsNew;
			});
			Tubes = new ArrayCollection(notEmpty);
		}

		private function ExpandForUI():void {
			loadProperties();
			for each (var tube:Tube in Tubes) {
				var targetIndex:int = tube.PositionInRack;
				var actualIndex:int = Tubes.getItemIndex(tube);
				while (actualIndex < targetIndex) {
					Tubes.addItemAt(new Tube(actualIndex, this), actualIndex);
					actualIndex = Tubes.getItemIndex(tube);
				}
			}

			var totalTubes:int = Rows * Columns;
			for (var index:int = Tubes.length; index < totalTubes; index++)
				Tubes.addItem(new Tube(index, this));
		}

		public static function LoadGridRack(file:File):GridRack {
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var xmlString:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
			fileStream.close();

			var xmlObj:XML = new XML(xmlString);
			FlexXBEngine.instance.processTypes(extensions.inf.external.tangibles.data.GridRack, extensions.inf.external.tangibles.data.Stroke, extensions.inf.external.tangibles.data.StrokePoint, extensions.inf.external.tangibles.data.Tube, extensions.inf.scribbles.Scribble, extensions.inf.scribbles.Scribbles, extensions.inf.scribbles.ScribbleWrapper);
			var engine:IFlexXB = FxBEngine.instance.getXmlSerializer();
			var rack:GridRack = engine.deserialize(xmlObj, extensions.inf.external.tangibles.data.GridRack);
			rack.setDataFile(file);
			rack.ExpandForUI();

			return rack;
		}

		public function getDataFile():File {
			return _datafile;
		}

		public function setDataFile(value:File):void {
			trace("setDataFile");
			_datafile = value;
		}

		public function SaveGridRack(file:File):void {
			if (_datafile == null)
				_datafile = file;

			ShrinkForStorage();

			var engine:IFlexXB = FxBEngine.instance.getXmlSerializer();
			var xmlNBs:XML = engine.serialize(this, true) as XML;

			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);

			fileStream.writeUTFBytes(xmlNBs.toString());
			fileStream.close();

			ExpandForUI();
		}

		/**
		 * For now we ignore rotation and alert the user instead
		 */
		override protected function OnRotationUpdated():void {
			/**
			if (RotationRaw > 90 && RotationRaw < 270) {
				var sort:Sort = new Sort();
				sort.fields = [new SortField("PositionInRack", true, true)];
				tubes.sort = sort;
				tubes.refresh();
			} else {
				tubes.sort = null;
				tubes.refresh();
			}*/
		}

	}

}
