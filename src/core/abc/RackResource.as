package core.abc
{
	import extensions.inf.notes.Notes;
	import extensions.inf.position.Position;
	import extensions.inf.scribbles.Scribbles;
	import extensions.inf.scroll.ScrollPosition;
	
	import flash.filesystem.File;
	
	[Bindable]	
	public class RackResource implements Resource
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
		//Variable specific to this class
		private var _rackId:String;
		private var _file:File;
		public static var FILETYPE:String = ".rxml";
		
		
		public function RackResource(file:File, id:Number,rackId:String, timestamp:Date)
		{
			this._id = id;
			this._timestamp = timestamp;
			this._file = file;
			this._name = file.name;
			this._localPath = _file.nativePath;
			_scrollPosition = new ScrollPosition();
			_position = new Position();
			this.rackId = rackId;
			onCreation();
		}
		
		public function onCreation():void
		{
		}
		
		/**
		 * Compare two resources
		 */
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
			var resourceXML:XML = <rack />;
			resourceXML.@id = _id;
			resourceXML.@rackId = this._rackId;
			resourceXML.@xpos = _position.xPos;
			resourceXML.@ypos = _position.yPos;
			resourceXML.@scrollx = _scrollPosition.horizontalScrollPosition;
			resourceXML.@scrolly = _scrollPosition.verticalScrollPosition;
			resourceXML.name = _name;
			resourceXML.timestamp = _timestamp;
			resourceXML.path = _localPath;
			resourceXML.archive = int(_archived);
			return resourceXML;
		}
		
		/******************************************************************
		 * Getters and setters
		 *****************************************************************/
		public function get subject():String {
			return _name;	
		}
		
		public function get verticalScrollPosition():Number {
			return _scrollPosition.verticalScrollPosition;	
		}
		
		public function get horizontalScrollPosition():Number {
			return _scrollPosition.horizontalScrollPosition;
		}
		
		public function get file():File {
			return _file;
		}
		
		public function get name():String
		{
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
		
		public function get localPath():String {
			return this._localPath;
		}
		
		public function get id():Number{
			return _id;
		}
		
		public function get lastModified():Date{
			return _lastModified;
		}
		
		public function get rackId():String
		{
		return _rackId;	
		}
		
		public function get xPos():Number {
			return _position.xPos;
		}
		
		public function get yPos():Number {
			return _position.yPos;
		}
		
		public function get archived():Boolean {
			return _archived;
		}
		
		public function set archived(archive:Boolean):void {
			_archived = archive;
		}
		
		public function set xPos(position:Number):void {
			_position.xPos = position;
		}
		
		public function set yPos(position:Number):void {
			_position.yPos = position;
		}
		
		public function set localPath(path:String):void {
			_localPath = path;
		}
		
		public function set verticalScrollPosition(position:Number):void {
			_scrollPosition.verticalScrollPosition = position;
		}
		
		public function set horizontalScrollPosition(position:Number):void {
			_scrollPosition.horizontalScrollPosition = position;
		}
		
		public function set file(file:File):void {
			_file = file;	
		}
		
		public function set subject(subject:String):void {
			_name = subject;
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
		
		public function set name(name:String):void {
			_name=name;
		}
		
		public function set rackId(value:String):void 
		{
			_rackId = value;		
		}
	}
}