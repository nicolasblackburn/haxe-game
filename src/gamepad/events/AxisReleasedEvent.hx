package gamepad.events;

class AxisReleasedEvent extends AxisEvent {
  public function new(indexes: Array<Int>) {
    super("axisreleased", 0, 0, indexes);
  }
}