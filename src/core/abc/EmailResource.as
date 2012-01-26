package core.abc
{	
	import extensions.inf.notes.Notes;
	import extensions.inf.position.Position;
	import extensions.inf.scribbles.Scribbles;
	import extensions.inf.scroll.ScrollPosition;
	
	import flash.filesystem.File;

	public class EmailResource implements Resource
	{
		//Variable shared among resources implementations
		private var _id:Number;
		private var _timestamp:Date = new Date();
		private var _localPath:String;
		private var _lastModified:Date;
		private var _notes:Notes;
		private var _scribbles:Scribbles;
		private var _scrollPosition:ScrollPosition;
		private var _position:Position;
		private var _archived:Boolean;
		/** subject */
		private var _name:String;
		
		//Variable specific to this class
		private var _emailRecipients:String;
		private var _emailFile:File;
						

		public function EmailResource(emFile:File, id:Number, timestamp:Date)
		{
			this._id = id;
			this._emailFile = emFile;
			this._timestamp = timestamp;
			this._localPath = emFile.nativePath;
			this._name = emFile.name;
			_scrollPosition = new ScrollPosition();
			_position = new Position();
			onCreation();
		}
		
		public function onCreation():void {
			
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
			var resourceXML:XML = <email />;
			resourceXML.@id = _id;
			resourceXML.@xpos = _position.xPos;
			resourceXML.@ypos = _position.yPos;
			resourceXML.@scrollx = _scrollPosition.horizontalScrollPosition;
			resourceXML.@scrolly = _scrollPosition.verticalScrollPosition;
			resourceXML.name = _name;
			resourceXML.timestamp = _timestamp;
			resourceXML.subject = _name;
			resourceXML.recipients = recipients;
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
		
		public function get recipients():String {
			return _emailRecipients;
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
		
		public function set verticalScrollPosition(position:Number):void {
			_scrollPosition.verticalScrollPosition = position;
		}
		
		public function set horizontalScrollPosition(position:Number):void {
			_scrollPosition.horizontalScrollPosition = position;
		}
		
		public function set recipients(recipients:String):void {
			_emailRecipients=recipients	
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

		public function get emailFile():File
		{
			return _emailFile;
		}

		public function set emailFile(value:File):void
		{
			_emailFile = value;
		}
		
		public function set localPath(path:String):void {
			_localPath = path;
		}

	}
}