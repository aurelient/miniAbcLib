package core.abc
{
	import extensions.inf.notes.*;
	import extensions.inf.position.Position;
	import extensions.inf.scribbles.*;
	import extensions.inf.scroll.ScrollPosition;
	[Bindable]
	public class MachineResource implements Resource
	{
		//Variable shared among resources implementations
		private var _id:Number;
		private var _timestamp:Date;
		private var _localPath:String;
		private var _lastModified:Date;
		private var _name:String;
		private var _notes:Notes;
		private var _scribbles:Scribbles;
		private var _scrollPosition:ScrollPosition;
		private var _position:Position;
		private var _archived:Boolean;
    // Variables specific for this class
    private var _machineId:String;
	
		
		public function MachineResource(name:String, path:String, id:Number, machineId:String, timestamp:Date)
		{
			this._localPath = path;
			this._timestamp = timestamp;
			this._name = name;
			this._id = id;
			//trace(_localPath);
			_scrollPosition = new ScrollPosition();
			_position = new Position();
      		this._machineId = machineId;			
		}
		
		public function equals(object:Object):Boolean {
			var resource:Resource = object as Resource;
			if(resource.id == this.id)
				return true;
			return false;
		}		
		
		/**
		 * Serialize to XML
		 */
		public function toXml():XML {
			var resourceXML:XML = <machine/>;
			resourceXML.@id = id
			resourceXML.@xpos = _position.xPos;
			resourceXML.@ypos = _position.yPos;
			resourceXML.@scrollx = _scrollPosition.horizontalScrollPosition;
			resourceXML.@scrolly = _scrollPosition.verticalScrollPosition;
			resourceXML.name = name;
			resourceXML.timestamp = timestamp;
			resourceXML.path =  localPath;			
			resourceXML.archive = int(_archived);
			var scribbleNode:XML = <scribble/>;
			var noteNode:XML = <note/>;
			resourceXML.appendChild(scribbleNode);
			resourceXML.appendChild(noteNode);
			return resourceXML;
		}
		
    public function get machineId():String
    {
      return this._machineId;
    }
		
		public function get localPath():String {
			return this._localPath;
		}
		
		public function get id():Number{
			return _id;
		}
		
		public function get lastModified():Date{
			return _lastModified;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get timestamp():Date {
			return _timestamp;
		}
		
		public function get notes():Notes {
			return _notes;
		}
		
		public function get scribbles():Scribbles {
			return _scribbles;
		}
		
		public function get verticalScrollPosition():Number {
			return _scrollPosition.verticalScrollPosition;	
		}
		
		public function get horizontalScrollPosition():Number {
			return _scrollPosition.horizontalScrollPosition;
		}
		
		public function get xPos():Number {
			return _position.xPos;
		}
		
		public function get yPos():Number {
			return _position.yPos;
		}
		
		public function set xPos(position:Number):void {
			_position.xPos = position;
		}
		
		public function get archived():Boolean {
			return _archived;
		}
		
		public function set archived(archive:Boolean):void {
			_archived = archive;
		}
		
		public function set yPos(position:Number):void {
			_position.yPos = position;
		}
		
		public function set verticalScrollPosition(position:Number):void {
			_scrollPosition.verticalScrollPosition = position;
		}
		
		public function set horizontalScrollPosition(position:Number):void {
			_scrollPosition.horizontalScrollPosition = position;
		}
		
		public function set notes(notes:Notes):void {
			_notes = notes;
		}
		
		public function set scribbles(scribbles:Scribbles):void {
			_scribbles = scribbles;
		}
		
		public function set timestamp(ts:Date):void {
			_timestamp = ts;
		}
		
		public function set name(name:String):void	{
			_name=name;
		}
		
		public function onCreation():void
		{
			// Do nothing
		}
		
		public function set localPath(path:String):void {
			_localPath = path;
		}
		
	}
	
	
	
	
}