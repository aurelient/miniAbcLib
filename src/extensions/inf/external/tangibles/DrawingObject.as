package extensions.inf.external.tangibles
{
  import extensions.inf.external.tangibles.data.Stroke;
  import extensions.inf.external.tangibles.data.StrokePoint;
  import extensions.inf.external.tangibles.events.RackEvent;
  
  import flash.display.Graphics;
  import flash.events.MouseEvent;
  
  import mx.collections.ArrayCollection;
  import mx.core.UIComponent;
  
  import spark.primitives.Graphic;
 
  //Taken from: http://www.munkiihouse.com/flexapps/DrawableCanvas/srcview/index.html
  public class DrawingObject
  {

    private var _target:UIComponent;
    private var _lines:ArrayCollection = null;
    private var _colors:ArrayCollection = null;

    private var _curentLine:Stroke;
    private var palette:TableRackExplorer = null;
    
    public function DrawingObject(target:UIComponent):void
    {
      _target = target;
      _target.addEventListener(MouseEvent.MOUSE_DOWN, downEvent);
      _target.addEventListener(MouseEvent.MOUSE_UP, upEvent);
      _target.addEventListener(MouseEvent.MOUSE_OUT, upEvent);
    }
    
    public function newLine():void
    {
      if(palette == null)
        return;
      
      _curentLine = new Stroke();
      _lines.addItem( _curentLine );
      _colors.addItem(palette.Color);
    }
    
    public function addPoint(xIN:int, yIN:int):void
    {
      if(palette == null)
        return;

      _curentLine.Points.push(new StrokePoint(xIN, yIN));
      _target.invalidateDisplayList();
    }
    
    public function drawLines( graphics:Graphics, lw:Number, lc:uint, la:Number ):void
    {
      graphics.clear();
      graphics.lineStyle(lw,lc,la);
      
      if(_lines == null)
        return;
      
      for( var j:int = 0; j<_lines.length; j++ )
      {
        var line:Stroke = _lines[j];
        var color:uint = _colors[j];
        graphics.lineStyle(3, color, 1);

        for( var i:int = 0; i<line.Points.length; i++ )
        {
          var p:StrokePoint = line.Points[i];
          if( i == 0 )
            graphics.moveTo( p.X, p.Y );
          else
            graphics.lineTo( p.X, p.Y );
        }
      }
    }
    
    private function moveEvent(event:MouseEvent):void
    {
      if(palette == null)
        return;

      addPoint( event.localX, event.localY );                
    }
    
    private function downEvent(event:MouseEvent):void
    {
      if(palette == null)
        return;

      _target.addEventListener(MouseEvent.MOUSE_MOVE, moveEvent);      
      newLine();
    }
    
    private function upEvent(event:MouseEvent):void
    {
      if(palette == null)
        return;

      _target.removeEventListener(MouseEvent.MOUSE_MOVE, moveEvent);
    }    
    
    public function set Palette(iPalette:TableRackExplorer):void
    {
      palette = iPalette;
    }
    
    public function get Palette():TableRackExplorer
    {
      return palette;
    }
    
    public function set Lines(iLines:ArrayCollection):void
    {
      _lines = iLines;
    }
    
    public function get Lines():ArrayCollection
    {
      return _lines;
    }
   
    public function set Colors(iColors:ArrayCollection):void
    {
      _colors = iColors;
    }
    
    public function get Colors():ArrayCollection
    {
      return _colors;
    }
    
  }
  
}