package core.abc
{
	import extensions.inf.notes.Note;
	import extensions.inf.notes.Notes;
	import extensions.inf.scribbles.Scribbles;
	
	import flash.events.IEventDispatcher;

	[Bindable]
	public interface Resource //extends IEventDispatcher
	{
		/**
		 * localPath 
		 * lastModified
		 * id
		 */		
		
		/**
		 * Should be fired when a new resource is created
		 * to backup the resource on the personal hard drive 
		 * and on the server. 
		 */
		function onCreation():void;
		
//		TODO 
//		function update(res:Object):void;
		
		/**
		 * define getters and setters
		 */
		function get id():Number;
		function get lastModified():Date;
		function get localPath():String;
		function get name():String;
		function get timestamp():Date;
		function get notes():Notes;
		function get scribbles():Scribbles;
		function get archived():Boolean;
		function set archived(archive:Boolean):void;
		function set name(string:String):void;
		function set timestamp(date:Date):void;
		function set notes(notes:Notes):void;
		function set scribbles(scribbles:Scribbles):void;
		function set localPath(path:String):void;
		
		/**
		 * Get and set scrollposition
		 */
		function get verticalScrollPosition():Number;
		function get horizontalScrollPosition():Number;
		function set verticalScrollPosition(position:Number):void;
		function set horizontalScrollPosition(position:Number):void;
		/**
		 * Get and set position
		 */
		function get xPos():Number;
		function get yPos():Number;
		function set xPos(position:Number):void;
		function set yPos(position:Number):void;
		/**
		 * Define comparison method
		 */
		function equals(object:Object):Boolean;
		
		/**
		 * Serialize to XML
		 */
		function toXml():XML;
		
	}
}