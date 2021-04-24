package geom;

class RectangleOperations {
  public static function equal(r1: Rectangle, r2: Rectangle) {
    return r1.clone().equal(r2);
  }

  public static function translate(r: Rectangle, v: Point2D) {
    return r.clone().translate(v);
  }

  public static function overlap(r1: Rectangle, r2: Rectangle) {
    return r1.clone().overlap(r2);
  }
}