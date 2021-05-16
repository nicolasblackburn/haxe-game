package geom;

class Point2DOperations {
  public static function add(u: Point2DInt, v: Point2DInt) {
    return u.clone().add(v);
  }

  public static function subtract(u: Point2DInt, v: Point2DInt) {
    return u.clone().subtract(v);
  }

  public static function multiply(u: Point2DInt, a: Int) {
    return u.clone().multiply(a);
  }
  public static function dot(u: Point2DInt, v: Point2DInt) {
    return u.clone().dot(v);
  }

  public static function norm(v: Point2DInt) {
    return v.clone().norm();
  }

  public static function normalize(v: Point2DInt) {
    return v.clone().normalize();
  }
}