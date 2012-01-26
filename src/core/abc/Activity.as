package core.abc
{
	import extensions.inf.scribbles.Scribbles;
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;

	/**
	 * Class that represents an activity
	 */
	[Bindable]
	public class Activity extends Object
	{
		private var _name:String;
		private var _id:String;
		private var _creation:Date;
		private var _lastModification:Date;	
		private var _resources:ArrayCollection;
		private var _scribbles:Scribbles;
		
		public function Activity(name:String, id:String = null)
		{
			_resources = new ArrayCollection();
			this._name = name;
			this._id = id;
			if(id == null )
				this._id = new Date().time.toString(); //generate ID
			this._creation = new Date();
		}
		
	
		/**
		 * Add a resource to the activity
		 */
		public function addResource(resource:Resource):void {
			_resources.addItem(resource);
		}
	
		/**
		 * Create and add a PdfResource
		 */
		public function addPdfResource(file:File,id:Number, timestamp:Date):PdfResource {
			var resource:PdfResource = new PdfResource(file,id,timestamp);		
			_resources.addItem(resource);
			return resource;
		}

		/**
		 * Create and add an ImageResource
		 */
		public function addImageResource(file:File,id:Number, timestamp:Date):ImageResource {
			var resource:ImageResource = new ImageResource(file,id,timestamp);		
			_resources.addItem(resource);
			return resource;
		}
		
		/**
		 * Create and add a FileResource
		 */
		public function addFileResource(file:File,id:Number, timestamp:Date):FileResource {
			var resource:FileResource = new FileResource(file,id,timestamp);		
			_resources.addItem(resource);
			return resource;
		}
		
		/**
		 * Create and add a RackResource
		 */
		public function addRackResource(file:File,id:Number, rackId:String, timestamp:Date):RackResource {
			var resource:RackResource = new RackResource(file,id,rackId, timestamp);		
			_resources.addItem(resource);
			return resource;
		}
		
		/**
		 * Create and add a UrlResource
		 */
		public function addUrlResource(url:String, id:Number, timestamp:Date):UrlResource {
			var resource:UrlResource = new UrlResource(url, id, timestamp, "", true);
			_resources.addItem(resource);
			return resource;
		}
		
		/**
		 * Create and add a MachineResource
		 */
		public function addMachineResource(name:String, url:String, id:Number, machineId:String, timestamp:Date):MachineResource {
			var resource:MachineResource = new MachineResource(name, url, id, machineId, timestamp);
			_resources.addItem(resource);
			return resource;
		}
		
		
		/**
		 * Create and add an EmailResource
		 */
		public function addEmailResource(file:File,id:Number, timestamp:Date):EmailResource {
			var resource:EmailResource = new EmailResource(file,id,timestamp);
			_resources.addItem(resource);
			return resource;
		}


		
		/**
		* Delete the resource based on its id
		* return: true if the deletion was succesful
		*/
		public function removeResource(res:Resource):Boolean {
			var i:int=0;
			for each(var resource:Resource in _resources) {
				if(resource.equals(res)) {
					_resources.removeItemAt(i);
					return true;
				}
				i++;
			}
			return false;
		}
		
		/**
		 * Check if activity contains a resource
		 */
		public function contains(res:Resource):Boolean {
			for each(var resource:Resource in _resources) {
				if(resource.equals(res))
					return true;
			}
			return false;
		}
		
		/**
		 * Compare two activities
		 */
		public function equals(object:Object):Boolean {
			var a:Activity = object as Activity;
			if(a.id == this._id)
				return true;
			return false;
		}
		
		public function get name():String {
			return _name;
		}

		public function set name(n:String):void {
			this._name = n;
		}
		
		public function get resources():ArrayCollection {
			return _resources;
		}
		
		public function set resources(res:ArrayCollection):void {
			_resources = res;
		}
		
		public function get id():String {
			return _id;
		}
		
		public function get scribbles():Scribbles {
			return _scribbles;
		}
		
		public function set scribbles(scribbles:Scribbles):void {
			_scribbles = scribbles;
		}
		
		/**
		 * Serialize to XML
		 */
		public function toXML():XML {
			var activityXML:XML = <activity/>;
			activityXML.@id = _id;
			activityXML.@name = _name;
			var resourcesXML:XML = <resources/>;
			activityXML.appendChild(resourcesXML);
			for each(var resource:Resource in _resources) {
				var resourceXML:XML = resource.toXml();
				resourcesXML.appendChild(resourceXML);
			}
			return activityXML;
		}
	}
}