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

  public function clone() {
    return new Rectangle(this.x, this.y, this.width, this.height);
  }

  public function copyTo(r: Rectangle) {
    r.x = this.x;
    r.y = this.y;
    r.width = this.width;
    r.height = this.height;
    return r;
  }

  public function equal(r: Rectangle) {
    return this.x == r.x && this.y == r.y && this.width == r.width && this.height == r.height;
  }

  public function translate(v: Point2D) {
    this.x += v.x;
    this.y += v.y;
    return this;
  }

  public function overlap(r: Rectangle) {
    return this.x < r.x + r.width && r.x < this.x + this.width &&
    this.y < r.y + r.height && r.y < this.y + this.height;
  }
}