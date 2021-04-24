package geom;

class Point2DOperations {
  public static function add(u: Point2D, v: Point2D) {
    return u.clone().add(v);
  }

  public static function subtract(u: Point2D, v: Point2D) {
    return u.clone().subtract(v);
  }

  public static function multiply(u: Point2D, a: Float) {
    return u.clone().multiply(a);
  }
  public static function dot(u: Point2D, v: Point2D) {
    return u.clone().dot(v);
  }

  public static function norm(v: Point2D) {
    return v.clone().norm();
  }

  public static function normalize(v: Point2D) {
    return v.clone().normalize();
  }
}