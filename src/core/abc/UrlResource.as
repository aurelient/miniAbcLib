package core.abc
{
	import extensions.inf.notes.Notes;
	import extensions.inf.position.Position;
	import extensions.inf.scribbles.Scribbles;
	import extensions.inf.scroll.ScrollPosition;
	
	import flash.display.Sprite;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	[Bindable]	
	public class UrlResource implements Resource
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
		private var _grabTitle:Boolean;
		//Variable specific to this resource
		private var service:HTTPService;
		
		public function UrlResource(path:String, id:Number, timestamp:Date, name:String="", grabTitle:Boolean = false)
		{
			this._localPath = path;
			this._timestamp = timestamp;
			if (name != "")
				this._name = name;
			else 
				this._name = path;
			this._id = id;
			this._grabTitle = grabTitle;
			//trace(_localPath);
			_scrollPosition = new ScrollPosition();
			_position = new Position();
			onCreation();
		}
		
		private function getTitle():void {
			service = new HTTPService();
			service.url = _localPath;
			service.resultFormat = "text";
			service.method = "GET";
			service.addEventListener("result", httpResult);
			service.addEventListener("fault", httpFault);
			//trace("Before send");
			service.send();
			//trace("After send");
		}
		
		private function httpResult(e:ResultEvent):void {
			var myPTitle:String = "";

			var tptitle:String = e.result.toString().match(/(?<=title>)[^><]+?(?=<\/title)/i);
			if (tptitle != null)
				myPTitle = tptitle.toString().replace(/^\s+|\s+$/g,"");
			else 
				return;

			// trace("HTTP result " + myPTitle);
			// var tTitle:TextField = new TextField(); tTitle.htmlText = myPTitle;
			//var test:String = new XMLDocument( myPTitle).firstChild.nodeValue;	
			myPTitle = entitiesConvert(myPTitle);
			this.name = myPTitle;
			//Upload new name
			var urlVariables:URLVariables = new URLVariables();
			//trace("HTTP result " + _name);
		}
		
		private function httpFault(event:FaultEvent):void {
			//trace("HTTP fault " + event.fault.faultString);
		}
		
		public function onCreation():void {
			// checks if the resource has a name or not
			if (this._name == this._localPath && _grabTitle)
				this.getTitle();
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
			var resourceXML:XML = <url/>;
			resourceXML.@id = _id;
			resourceXML.@xpos = _position.xPos;
			resourceXML.@ypos = _position.yPos;
			resourceXML.@scrollx = _scrollPosition.horizontalScrollPosition;
			resourceXML.@scrolly = _scrollPosition.verticalScrollPosition;
			resourceXML.name = _name;
			resourceXML.timestamp = _timestamp;
			resourceXML.path = _localPath;
			resourceXML.archive = int(_archived);
			var scribbleNode:XML = <scribble/>;
			var noteNode:XML = <note/>;
			resourceXML.appendChild(scribbleNode);
			resourceXML.appendChild(noteNode);
			return resourceXML;
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
		
		public function set localPath(path:String):void {
			_localPath = path;
		}
		
		// add fast replace method to string class         
		String.prototype.replace = function(f:String, r:String):String {             
			return this.split(f).join(r);	
		}
		// create the entity mapping array      
		// which allows decoding html entities into their unicode equivalents         
		private function entitiesConvert(str:String):String {
			var aryEntities:Object = new Object();
			aryEntities["&nbsp;"]   = "\u00A0"; // non-breaking space
			aryEntities["&iexcl;"]  = "\u00A1"; // inverted exclamation mark
			aryEntities["&cent;"]   = "\u00A2"; // cent sign
			aryEntities["&pound;"]  = "\u00A3"; // pound sign
			aryEntities["&curren;"] = "\u00A4"; // currency sign
			aryEntities["&yen;"]    = "\u00A5"; // yen sign
			aryEntities["&brvbar;"] = "\u00A6"; // broken vertical bar (|)
			aryEntities["&sect;"]   = "\u00A7"; // section sign
			aryEntities["&uml;"]    = "\u00A8"; // diaeresis
			aryEntities["&copy;"]   = "\u00A9"; // copyright sign
			aryEntities["&reg;"]    = "\u00AE"; // registered sign
			aryEntities["&deg;"]    = "\u00B0"; // degree sign
			aryEntities["&plusmn;"] = "\u00B1"; // plus-minus sign
			aryEntities["&sup1;"]   = "\u00B9"; // superscript one
			aryEntities["&sup2;"]   = "\u00B2"; // superscript two
			aryEntities["&sup3;"]   = "\u00B3"; // superscript three
			aryEntities["&acute;"]  = "\u00B4"; // acute accent
			aryEntities["&amp;"]    = "\u0026"; // ampersand
			aryEntities["&micro;"]  = "\u00B5"; // micro sign
			aryEntities["&frac14;"] = "\u00BC"; // vulgar fraction one quarter
			aryEntities["&frac12;"] = "\u00BD"; // vulgar fraction one half
			aryEntities["&frac34;"] = "\u00BE"; // vulgar fraction three quarters
			aryEntities["&iquest;"] = "\u00BF"; // inverted question mark
			aryEntities["&Agrave;"] = "\u00C0"; // Latin capital letter A with grave
			aryEntities["&Aacute;"] = "\u00C1"; // Latin capital letter A with acute
			aryEntities["&Acirc;"]  = "\u00C2"; // Latin capital letter A with circumflex
			aryEntities["&Atilde;"] = "\u00C3"; // Latin capital letter A with tilde
			aryEntities["&Auml;"]   = "\u00C4"; // Latin capital letter A with diaeresis
			aryEntities["&Aring;"]  = "\u00C5"; // Latin capital letter A with ring above
			aryEntities["&AElig;"]  = "\u00C6"; // Latin capital letter AE
			aryEntities["&Ccedil;"] = "\u00C7"; // Latin capital letter C with cedilla
			aryEntities["&Egrave;"] = "\u00C8"; // Latin capital letter E with grave
			aryEntities["&Eacute;"] = "\u00C9"; // Latin capital letter E with acute
			aryEntities["&Ecirc;"]  = "\u00CA"; // Latin capital letter E with circumflex
			aryEntities["&Euml;"]   = "\u00CB"; // Latin capital letter E with diaeresis
			aryEntities["&Igrave;"] = "\u00CC"; // Latin capital letter I with grave
			aryEntities["&Iacute;"] = "\u00CD"; // Latin capital letter I with acute
			aryEntities["&Icirc;"]  = "\u00CE"; // Latin capital letter I with circumflex
			aryEntities["&Iuml;"]   = "\u00CF"; // Latin capital letter I with diaeresis
			aryEntities["&ETH;"]    = "\u00D0"; // Latin capital letter ETH
			aryEntities["&Ntilde;"] = "\u00D1"; // Latin capital letter N with tilde
			aryEntities["&Ograve;"] = "\u00D2"; // Latin capital letter O with grave
			aryEntities["&Oacute;"] = "\u00D3"; // Latin capital letter O with acute
			aryEntities["&Ocirc;"]  = "\u00D4"; // Latin capital letter O with circumflex
			aryEntities["&Otilde;"] = "\u00D5"; // Latin capital letter O with tilde
			aryEntities["&Ouml;"]   = "\u00D6"; // Latin capital letter O with diaeresis
			aryEntities["&Oslash;"] = "\u00D8"; // Latin capital letter O with stroke
			aryEntities["&Ugrave;"] = "\u00D9"; // Latin capital letter U with grave
			aryEntities["&Uacute;"] = "\u00DA"; // Latin capital letter U with acute
			aryEntities["&Ucirc;"]  = "\u00DB"; // Latin capital letter U with circumflex
			aryEntities["&Uuml;"]   = "\u00DC"; // Latin capital letter U with diaeresis
			aryEntities["&Yacute;"] = "\u00DD"; // Latin capital letter Y with acute
			aryEntities["&THORN;"]  = "\u00DE"; // Latin capital letter THORN
			aryEntities["&szlig;"]  = "\u00DF"; // Latin small letter sharp s = ess-zed
			aryEntities["&agrave;"] = "\u00E0"; // Latin small letter a with grave
			aryEntities["&aacute;"] = "\u00E1"; // Latin small letter a with acute
			aryEntities["&acirc;"]  = "\u00E2"; // Latin small letter a with circumflex
			aryEntities["&atilde;"] = "\u00E3"; // Latin small letter a with tilde
			aryEntities["&auml;"]   = "\u00E4"; // Latin small letter a with diaeresis
			aryEntities["&aring;"]  = "\u00E5"; // Latin small letter a with ring above
			aryEntities["&aelig;"]  = "\u00E6"; // Latin small letter ae
			aryEntities["&ccedil;"] = "\u00E7"; // Latin small letter c with cedilla
			aryEntities["&egrave;"] = "\u00E8"; // Latin small letter e with grave
			aryEntities["&eacute;"] = "\u00E9"; // Latin small letter e with acute
			aryEntities["&ecirc;"]  = "\u00EA"; // Latin small letter e with circumflex
			aryEntities["&euml;"]   = "\u00EB"; // Latin small letter e with diaeresis
			aryEntities["&igrave;"] = "\u00EC"; // Latin small letter i with grave
			aryEntities["&iacute;"] = "\u00ED"; // Latin small letter i with acute
			aryEntities["&icirc;"]  = "\u00EE"; // Latin small letter i with circumflex
			aryEntities["&iuml;"]   = "\u00EF"; // Latin small letter i with diaeresis
			aryEntities["&eth;"]    = "\u00F0"; // Latin small letter eth
			aryEntities["&ntilde;"] = "\u00F1"; // Latin small letter n with tilde
			aryEntities["&ograve;"] = "\u00F2"; // Latin small letter o with grave
			aryEntities["&oacute;"] = "\u00F3"; // Latin small letter o with acute
			aryEntities["&ocirc;"]  = "\u00F4"; // Latin small letter o with circumflex
			aryEntities["&otilde;"] = "\u00F5"; // Latin small letter o with tilde
			aryEntities["&ouml;"]   = "\u00F6"; // Latin small letter o with diaeresis
			aryEntities["&oslash;"] = "\u00F8"; // Latin small letter o with stroke
			aryEntities["&ugrave;"] = "\u00F9"; // Latin small letter u with grave
			aryEntities["&uacute;"] = "\u00FA"; // Latin small letter u with acute
			aryEntities["&ucirc;"]  = "\u00FB"; // Latin small letter u with circumflex
			aryEntities["&uuml;"]   = "\u00FC"; // Latin small letter u with diaeresis
			aryEntities["&yacute;"] = "\u00FD"; // Latin small letter y with acute
			aryEntities["&thorn;"]  = "\u00FE"; // Latin small letter thorn
			aryEntities["&yuml;"]   = "\u00FF"; // Latin small letter y with diaeresis
			aryEntities["&raquo;"]	= "»";	
			//return aryEntities;
			
			
			
			for(var entity:String in aryEntities){
				var myPattern:RegExp = new RegExp(entity,"g");
				str =  str.replace(myPattern, aryEntities[entity]);
			}
			

			
			return str;
			
		}
	}
}