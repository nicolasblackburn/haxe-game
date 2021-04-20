package entities;

import geom.Point2D;
import geom.Transform;
import geom.Rectangle;

using math.MathExtensions;

class World {
  public var active = true;
  public var name = "world";
  public var transform = new Transform();
  public var gridSize = new Point2D(28, 18);
  public var tileSize = new Point2D(8, 8);
  public var tileIds = [
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
    1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
    1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
    1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0, 1, 1, 1, 1, 0, 0, 1, 1, 
    1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0, 1, 1, 1, 1, 0, 0, 1, 1, 
    1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
    1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
    1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
    1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
    1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0, 1, 1, 1, 1, 0, 0, 1, 1, 
    1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0 ,0, 1, 1, 1, 1, 0, 0, 1, 1, 
    1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
    1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
  ];

  public function new() {}

  public function canMove(entity: {position: Point2D, bounds: Rectangle}, position: Point2D) {
    var xStart = position.x + entity.bounds.x;
    var xEnd = xStart + entity.bounds.width;
    var xEndInclusive = !Math.floatEqual(0, Math.modulo(xEnd, this.tileSize.x));
    
    var yStart = position.y + entity.bounds.y;
    var yEnd = yStart + entity.bounds.height;
    var yEndInclusive = !Math.floatEqual(0, Math.modulo(yEnd, this.tileSize.y));

    var x = xStart;
    while (xEndInclusive ? x <= xEnd : x < xEnd) {
      var y = yStart;

      while (yEndInclusive ? y <= yEnd : y < yEnd) {
        if (this.getTileIdAt(x, y) > 0) {
          return false;
        }
  
        y += this.tileSize.y;
      }

      x += this.tileSize.x;
    }

    return true;
  }

  public function getTileIdAt(x: Float, y:  Float) {
    var xIndex = Std.int(x / this.tileSize.x);
    var yIndex = Std.int(y / this.tileSize.y);
    return this.tileIds[xIndex + Std.int(this.gridSize.x) * yIndex];
  }
}