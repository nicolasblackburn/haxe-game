package geom;

class Point2D {
  public var x: Float;
  public var y: Float;

  public function new(x: Float, y: Float) {
    this.x = x;
    this.y = y;
  }

  public function copyTo(v: Point2D) {
    v.x = this.x;
    v.y = this.y;
    return v;
  }

  public static function dot(u: Point2D, v: Point2D) {
    return u.x * v.x + u.y * v.y;
  }

  public static function add(u: Point2D, v: Point2D) {
    return new Point2D(u.x + v.x, u.y + v.y);
  }

  public static function subtract(u: Point2D, v: Point2D) {
    return new Point2D(u.x - v.x, u.y - v.y);
  }

  public static function multiply(u: Point2D, a: Float) {
    return new Point2D(u.x * a, u.y * a);
  }

  public static function norm(v: Point2D) {
    return Math.sqrt(Point2D.dot(v, v));
  }

  public static function normalize(v: Point2D) {
    var norm = Point2D.norm(v);
    if (norm != 0) {
      return Point2D.multiply(v, 1 / norm);
    } else {
      return new Point2D(0, 0);
    }
  }
}