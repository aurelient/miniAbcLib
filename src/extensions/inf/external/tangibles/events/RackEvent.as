package extensions.inf.external.tangibles.events
{
  import extensions.inf.external.tangibles.data.GridRack;
  
  import flash.events.Event;

  public class RackEvent extends Event
  {
    
    public static const ENTER:String = "enterRack";
    public static const OPEN:String = "openRack";
    public static const CLOSED:String = "closedRack";
	/** Used when the content of the rack is resized, ie. when a rack expands to show the rackexplorer. */
	public static const RESIZED:String = "resizedRack";
	/** Use when a rack is placed to the multi touch surface. */
	public static const DOWN:String = "downRack";
	/** Use when a rack is lifted off the multi touch surface. */
	public static const UP:String	= "upRack";
	/** Use when a rack is moved. Both up/down but also rotated! */
	public static const MOVED:String	= "movedRack";
	
    private var rack:GridRack;
    
    public function RackEvent(type:String, iRack:GridRack = null)
    {
      super(type, true, false);
      rack = iRack;
    }
    
    public function get Rack():GridRack
    {
      return rack;
    }

    public function set Rack(value:GridRack):void
    {
      rack = value;
    }

  }
}