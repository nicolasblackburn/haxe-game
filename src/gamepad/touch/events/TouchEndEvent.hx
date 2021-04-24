package gamepad.touch.events;

class TouchEndEvent extends TouchEvent {
  public function new(touch, touches) {
    super("touchend", touch, touches);
  }
}