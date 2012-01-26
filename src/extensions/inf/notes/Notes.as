/**
 * Class representing a collection of notes
 */
package extensions.inf.notes
{
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;

	public class Notes extends ArrayCollection
	{	
		/**
		 * Constructor
		 */
		public function Notes(...parameters)
		{
			super(parameters);
		}
		
		/**
		 * Add a note
		 */
		public function add(note:Note):void {
			for each(var n:Note in this) {
				if(note.id == n.id) {
					n.date = note.date;
					n.subject = note.subject;
					n.text = note.text;
					return;
				}
			}
			this.addItem(note);
		}
		
		/**
		 * Remove a note
		 */
		public function remove(note:Note):void {
			this.removeItemAt(this.getItemIndex(note));
		}
		
		/**
		 * Return sorted notes
		 * Sort on id's as they are generated from timestamps
		 */
		public function getNewestNotes():ArrayCollection {
			var idSortField:SortField = new SortField();
			idSortField.name = "_id";
			idSortField.numeric = true;
			var numericDataSort:Sort = new Sort();
			numericDataSort.fields = [idSortField];
			this.sort = numericDataSort;
			this.refresh();
			return this;
		}
	}
}