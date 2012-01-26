package extensions.inf.external.tangibles.data
{
  import com.googlecode.flexxb.xml.annotation.XmlArray;
  
  public class Stroke
  {
    
    [XmlArray(type="extensions.inf.external.tangibles.data.StrokePoint")]
    public var Points:Array = new Array();
    
    public function Stroke()
    {
    }
    
  }
  
}