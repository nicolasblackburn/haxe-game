package geom;

using math.MathExtensions;

class Point2D {
  public var x: Float;
  public var y: Float;

  public function new(x: Float, y: Float) {
    this.set(x, y);
  }

  public function set(x: Float, y: Float) {
    this.x = x;
    this.y = y;
    return this;
  }

  public function setFromPoint2D(p: Point2D) {
    this.x = p.x;
    this.y = p.y;
    return this;
  }

  public function setX(x: Float) {
    this.x = x;
    return this;
  }

  public function setY(y: Float) {
    this.y = y;
    return this;
  }

  public function equal(v: Point2D) {
    return this.x == v.x && this.y == v.y;
  }

  public function floatEqual(v: Point2D, epsilon = 0.0001) {
    return Math.floatEqual(this.x, v.x, epsilon) && Math.floatEqual(this.y, v.y, epsilon);
  }

  public function clone() {
    return new Point2D(this.x, this.y);
  }

  public function copyTo(v: Point2D) {
    v.x = this.x;
    v.y = this.y;
    return v;
  }

  public function copyFrom(v: Point2D) {
    this.x = v.x;
    this.y = v.y;
    return this;
  }

  public function add(v: Point2D) {
    this.x += v.x;
    this.y += v.y;
    return this;
  }

  public function subtract(v: Point2D) {
    this.x -= v.x;
    this.y -= v.y;
    return this;
  }

  public function multiply(a: Float) {
    this.x *= a;
    this.y *= a;
    return this;
  }

  public function dot(v: Point2D) {
    return this.x * v.x + this.y * v.y;
  }

  public function norm() {
    return Math.sqrt(this.dot(this));
  }

  public function normalize() {
    var norm = this.norm();
    if (norm != 0) {
      return this.multiply(1 / norm);
    } else {
      return this;
    }
  }
}