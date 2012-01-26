package extensions.inf.external.tangibles.data {
	import com.googlecode.flexxb.xml.annotation.XmlArray;
	import com.googlecode.flexxb.xml.annotation.XmlAttribute;
	import com.googlecode.flexxb.xml.annotation.XmlElement;
	
	import extensions.inf.external.tangibles.events.ScribbleEvent;
	import extensions.inf.scribbles.ScribbleWrapper;
	import extensions.inf.scribbles.Scribbles;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class Tube extends EventDispatcher {
		private var id:uint = 0;
		private var rack:GridRack = null;
		private var positionInRack:uint = 0;
		private var isNew:Boolean = true;

		private var lidMarker:ArrayCollection = null;
		private var markerColors:ArrayCollection = null;

		private var dateCreated:Date = null;
		private var name:String = "";
		private var lidScribble:ScribbleWrapper = new ScribbleWrapper();;
		private var notes:String = "";

		public function Tube(iPos:uint = 0, iRack:GridRack = null) {
			positionInRack = iPos;
			rack = iRack;
			dateCreated = new Date();
			lidMarker = new ArrayCollection();
			markerColors = new ArrayCollection();
		}

		public function set LidMarker(iLines:ArrayCollection):void {
			lidMarker = iLines;
		}

		[XmlArray(type="extensions.inf.external.tangibles.data.Stroke")]
		public function get LidMarker():ArrayCollection {
			return lidMarker;
		}

		public function get IsNew():Boolean {
			return isNew;
		}

		public function set IsNew(value:Boolean):void {
			isNew = value;
		}

		public function get Rack():GridRack {
			return rack;
		}

		public function set Rack(value:GridRack):void {
			rack = value;
		}

		[XmlElement]
		public function get LidScribble():ScribbleWrapper {
			return lidScribble;
		}
		
		public function set LidScribble(value:ScribbleWrapper):void {
			lidScribble = value;
			if(value && value.scribbles != null) {
				dispatchEvent(new ScribbleEvent(ScribbleEvent.SCRIBBLE_CHANGED, value.scaleX, value.scaleY, true, false));
				IsNew = false;
			}
		}

		[XmlArray(type="uint")]
		public function get MarkerColors():ArrayCollection {
			return markerColors;
		}

		public function set MarkerColors(value:ArrayCollection):void {
			markerColors = value;
		}

		[XmlAttribute]
		public function get Name():String {
			return name;
		}


		public function set Name(value:String):void {
			trace(value);
			name = value;
			if(value != "")
				IsNew = false;
		}

		[XmlAttribute]
		public function get DateCreated():Date {
			return dateCreated;
		}

		public function set DateCreated(value:Date):void {
			dateCreated = value;
		}

		[XmlElement]
		public function get Notes():String {
			return notes;
		}

		public function set Notes(iNotes:String):void {
			notes = iNotes;
		}

		[XmlAttribute]
		public function get PositionInRack():uint {
			return positionInRack;
		}

		public function set PositionInRack(value:uint):void {
			positionInRack = value;
		}
		
		public function setNew():void {
			this.lidScribble = new ScribbleWrapper();
			this.DateCreated = null;
			this.id = 0;
			this.isNew = true;
			this.lidMarker = null;
			this.markerColors = null;
			this.name = "";
			this.notes = null;
		}
		
		public function clone():Tube {
			var tube:Tube = new Tube(this.positionInRack, this.rack);
			tube.DateCreated = this.dateCreated;
			tube.id = this.id;
			tube.lidScribble = this.lidScribble;
			tube.isNew = this.isNew;
			tube.lidMarker = this.lidMarker;
			tube.markerColors = this.markerColors;
			tube.name = this.name;
			tube.notes = this.notes;
			return tube;
		}
		
		public function copyTo(tube:Tube):void {
			this.positionInRack = tube.PositionInRack;
			this.rack = tube.Rack;
			this.lidScribble = tube.LidScribble;
			this.DateCreated = tube.dateCreated;
			this.id = tube.id;
			this.isNew = tube.isNew;
			this.lidMarker = tube.lidMarker;
			this.markerColors = tube.markerColors;
			this.name = tube.name;
			this.notes = tube.notes;
		}

	}

}
