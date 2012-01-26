/**
 * Class for downloading notes
 */
package extensions.inf.comm
{
	import core.abc.Activity;
	import core.abc.Resource;
	import core.comm.Settings;
	
	import extensions.inf.notes.Note;
	import extensions.inf.notes.Notes;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	
	public class NoteDownloader
	{
		//private static var serverAddress:String = "http://pit.itu.dk/~mortenq/getNotes.php";
		private static var serverAddress:String = Settings.getInstance().serverAddress + "getNotes.php";
		private var notes:Notes;
		private var _resourceXml:XML;
		private var _resource:Resource;
		private var numNotes:Number;
		private var currentNoteNumber:Number;
		private var notesXml:XMLList;
		
		public function NoteDownloader(xml:XML, resource:Resource)
		{
			_resourceXml = xml;
			_resource = resource;
			notes = new Notes();
			currentNoteNumber = 0;
			numNotes = 0;
			notesXml = _resourceXml.notes.elements("note");
			for each(var x:XML in notesXml) {
				numNotes++;
			}		
		}
		
		public function createNotes():void {
			if(currentNoteNumber < numNotes) {
				var noteXml:XML = notesXml[currentNoteNumber];
				var id:Number = parseInt(noteXml.@id);
				var path:String = noteXml.path;
				var subject:String = noteXml.subject;
				var note:Note = new Note(id, subject, new Date(Date.parse(noteXml.date)), "");
				var req:URLRequest = new URLRequest(serverAddress);
				req.method = URLRequestMethod.POST;
				var urlVariables:URLVariables = new URLVariables();
				urlVariables.filename = path;
				req.data = urlVariables;
				try {
					var stream:URLStream = new URLStream();
					stream.addEventListener(Event.COMPLETE, function saveNotes():void {
						var noteText:String = stream.readUTFBytes(stream.bytesAvailable);
						note.text = noteText;
						notes.add(note);
						currentNoteNumber++;
						createNotes();
					});
					stream.load(req);
				} catch(e:Error) {
					trace("Note download error:", e);
				}
				catch (ioe:IOError) {
					trace("Note download error:", ioe);
				}
			} else {
				_resource.notes = notes;
			}
		}
	}
}