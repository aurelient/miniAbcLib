package extensions.inf.external.tangibles.events
{
  import flash.events.Event;
  import extensions.inf.external.tangibles.data.Tube;
  
  public class TubeEvent extends Event
  {
    public static const OPEN:String = "tubeOpen";
    public static const CLOSED:String = "tubeClosed";
    public static const DELETED:String = "tubeDeleted";
   
    private var targetTube:Tube = null;
    
    public function TubeEvent(type:String, iTube:Tube = null, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
      targetTube = iTube;
    }

    public function get TargetTube():Tube
    {
      return targetTube;
    }

    public function set TargetTube(value:Tube):void
    {
      targetTube = value;
    }
	
	override public function clone() : Event {
		return new TubeEvent(type, targetTube, bubbles, cancelable);
	}

  }
}