package;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
using flixel.util.FlxSpriteUtil;

class Graph extends FlxSprite {


  //data fromat =
  /* data =
  {
    { {x,y}, {x,y}, ...},
    { {x,y}, {x,y}, ...},
  }
  */
  public var data:Array<Array<Array<Int>>> = [];

  public function new(x:Int, y:Int, w:Int, h:Int, bgc:FlxColor, fgc:FlxColor,
        ?xlabel:String = "", ?ylabel:String = "" ) : Void {

    super(x,y);
    var lineStyle:LineStyle = { color: fgc, thickness: 2 };
    var drawStyle:DrawStyle = { smoothing: true };


    makeGraphic(w,h,bgc, true);
    //FlxSpriteUtil.beginDraw(fgc, line);
    drawLine(0,0,0,h, lineStyle);
    drawLine(0,h-1,w,h-1, lineStyle);
    //FlxSpriteUtil.endDraw(this);

  }

  public function updateGraph(?limit:Int = 0):Void {
    fill(FlxColor.TRANSPARENT);
    drawLine(0,0,0,h, lineStyle);
    drawLine(0,h-1,w,h-1, lineStyle);
    for(dataSet in data) {
      for(dataPoint in dataSet) {
        x = dataPoint[0];
        y = dataPoint[1];
        trace(x+", "+y);
      }
    }
  }

}
