package entities;

import geom.Point2DInt;
import physics.Body;
import geom.Point2D;
import geom.Transform;
import geom.Rectangle;

using math.MathExtensions;

class World {
  public var active = true;
  public var transform = new Transform();
  public var gridSize = new Point2DInt(28, 18);
  public var tileSize = new Point2DInt(8, 8);
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

  public function canMove(body: Body, position: Point2D) {
    var xStart = position.x + body.bounds.x;
    var xEnd = xStart + body.bounds.width;
    var xEndInclusive = !Math.floatEqual(0, Math.modulo(xEnd, this.tileSize.x));
    
    var yStart = position.y + body.bounds.y;
    var yEnd = yStart + body.bounds.height;
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

  public function canMovePoint(position: Point2D) {
    return this.getTileIdAt(position.x, position.y) <= 0;
  }

  public function getTileIdAt(x: Float, y:  Float) {
    var gridCoordinates = this.toGridCoordinates(x, y);
    return this.tileIds[gridCoordinates.x + Std.int(this.gridSize.x) * gridCoordinates.y];
  }

  public function toGridCoordinates(x: Float, y: Float) {
    return new Point2DInt(Std.int(x / this.tileSize.x), Std.int(y / this.tileSize.y));
  }

  public function toWorldCoordinates(x: Int, y: Int) {
    return new Point2D(x * this.tileSize.x, y * this.tileSize.y);
  }
}