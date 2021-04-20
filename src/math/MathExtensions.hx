package math;

class MathExtensions {
  public static function floatEqual(cl:Class<Math>, x: Float, y: Float, epsilon = 0.0001) {
    return Math.abs(x - y) < epsilon;
  }

  public static function modulo(cl:Class<Math>, x: Float, y: Float) {
    return x < 0 ? x % y + y : x % y;
  }
}