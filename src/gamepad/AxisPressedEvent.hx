package gamepad;

class AxisPressedEvent extends AxisEvent {
  public function new(x: Float, y: Float, indexes: Array<Int>) {
    super("axispressed", x, y, indexes);
  }
}