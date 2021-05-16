package geom;

class Point2DInt {
  public var x: Int;
  public var y: Int;

  public function new(x: Int, y: Int) {
    this.set(x, y);
  }

  public function set(x: Int, y: Int) {
    this.x = x;
    this.y = y;
    return this;
  }

  public function setX(x: Int) {
    this.x = x;
    return this;
  }

  public function setY(y: Int) {
    this.y = y;
    return this;
  }

  public function equal(v: Point2DInt) {
    return this.x == v.x && this.y == v.y;
  }

  public function clone() {
    return new Point2DInt(this.x, this.y);
  }

  public function copyTo(v: Point2DInt) {
    v.x = this.x;
    v.y = this.y;
    return v;
  }

  public function copyFrom(v: Point2DInt) {
    this.x = v.x;
    this.y = v.y;
    return this;
  }

  public function add(v: Point2DInt) {
    this.x += v.x;
    this.y += v.y;
    return this;
  }

  public function subtract(v: Point2DInt) {
    this.x -= v.x;
    this.y -= v.y;
    return this;
  }

  public function multiply(a: Int) {
    this.x *= a;
    this.y *= a;
    return this;
  }

  public function dot(v: Point2DInt) {
    return this.x * v.x + this.y * v.y;
  }

  public function norm() {
    return Math.sqrt(this.dot(this));
  }

  public function normalize() {
    var point = new Point2D(this.x, this.y);
    var norm = this.norm();
    if (norm != 0) {
      return point.multiply(1 / norm);
    } else {
      return point;
    }
  }
}