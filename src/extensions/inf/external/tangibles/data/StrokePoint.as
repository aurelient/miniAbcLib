package extensions.inf.external.tangibles.data
{
  import com.googlecode.flexxb.xml.annotation.XmlAttribute;
  
  public class StrokePoint
  {
    
    [XmlAttribute]
    public var X:uint = 0;
    
    [XmlAttribute]
    public var Y:uint = 0;
    
    public function StrokePoint(inputX:uint = 0, inputY:uint = 0)
    {
      X = inputX;
      Y = inputY;
    }
    
  }
  
}