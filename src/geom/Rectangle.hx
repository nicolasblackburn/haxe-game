package geom;

class Rectangle {
  public var x: Float;
  public var y: Float;
  public var width: Float;
  public var height: Float;

  public function new(
    x: Float,
    y: Float,
    width: Float,
    height: Float
  ) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  public function copyTo(rectangle: Rectangle) {
    rectangle.x = this.x;
    rectangle.y = this.y;
    rectangle.width = this.width;
    rectangle.height = this.height;
    return rectangle;
  }

  public static function equal(r1: Rectangle, r2: Rectangle) {
    return r1.x == r2.x && r1.y == r2.y && r1.width == r2.width && r1.height == r2.height;
  }

  public static function translate(rectangle: Rectangle, translation: Point2D) {
    return new Rectangle(rectangle.x + translation.x, rectangle.y + translation.y, rectangle.width, rectangle.height);
  }

  public static function overlap(r1: Rectangle, r2: Rectangle) {
    return r1.x < r2.x + r2.width && r2.x < r1.x + r1.width &&
    r1.y < r2.y + r2.height && r2.y < r1.y + r1.height;
  }
}