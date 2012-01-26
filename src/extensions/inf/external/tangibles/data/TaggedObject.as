package extensions.inf.external.tangibles.data
{
  
  [Bindable]
  public class TaggedObject
  {
    public static const TAGGEDMACHINE:int = 0x000F0000;
    public static const RACKPINKFOAM:int = 0x00010000;
    public static const RACKMULTIORANGE:int = 0x00020000;
    public static const RACKWIREDBLUE:int = 0x00030000;
    public static const RACKBLACK:int = 0x00040000;
    public static const RACKFORPCR:int = 0x00050000;
    
    private var consecutive:int;
    private var type:int;
    
    private var posX:int;
    private var posY:int;
    private var rotation:Number = 0;
    
    private var width:int;
    private var height:int;
    
    public function TaggedObject(iType:int = 0, iCons:int = 0)
    {
      type = iType;
      consecutive = iCons;
    }
    
    public function get ID():String
    {
      return "0x" + (type + consecutive).toString(16);
    }
    
    public function get ResourceName() : String
    {
      switch(type)
      {
        case TaggedObject.RACKMULTIORANGE:
          return "Orange " + (consecutive + 1); 
        case TaggedObject.RACKPINKFOAM:
          return "Pink " + (consecutive + 1);
        case TaggedObject.RACKWIREDBLUE:
          return "Blue " + (consecutive + 1);
        case TaggedObject.RACKBLACK:
          return "Black " + (consecutive + 1);
        case TaggedObject.RACKFORPCR:
          return "PCR " + (consecutive + 1);
        default:
          return ID;
      }
    }
    
    public function get Height():int
    {
      return height;
    }
    
    public function set Height(value:int):void
    {
      height = value;
    }
    
    public function get Width():int
    {
      return width;
    }
    
    public function set Width(value:int):void
    {
      width = value;
    }
    
    [XmlAttribute]
    public function get Type():int
    {
      return type;
    }
    
    public function set Type(iType:int):void
    {
      type = iType;
    }
    
    [XmlAttribute]
    public function get Consecutive():int
    {
      return consecutive;
    }
    
    public function set Consecutive(iCons:int):void
    {
      consecutive = iCons;
    }
    
    [XmlAttribute]
    public function get PosX():int
    {
      return posX;
    }
    
    public function set PosX(value:int):void
    {
      posX = value;
    }
    
    [XmlAttribute]
    public function get PosY():int
    {
      return posY;
    }
    
    public function set PosY(value:int):void
    {
      posY = value;
    }
    
    [XmlAttribute]
    public function get Rotation():Number
    {
      return 0;
      //return rotation;
    }
    
    public function get RotationRaw():Number
    {
      return rotation;
    }
    
    public function set RotationRaw(value:Number):void
    {
      rotation = value;
    }
    
    public function set RotationRad(value:Number):void
    {
      RotationRaw = (value * 180) / Math.PI;
      //It now fixes the orientation of tubes
      OnRotationUpdated();
    }
    
    protected function OnRotationUpdated():void
    {
    }
    
    public static function IsGridRackType(iType:int):Boolean
    {
      switch(iType)
      {
        case TaggedObject.RACKMULTIORANGE:
        case TaggedObject.RACKPINKFOAM:
        case TaggedObject.RACKWIREDBLUE:
        case TaggedObject.RACKBLACK:
        case TaggedObject.RACKFORPCR:
          return true;
      }
      return false;
    }
    
  }
}