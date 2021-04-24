package gamepad.touch.events;

class TouchStartEvent extends TouchEvent {
  public function new(touch, touches) {
    super("touchstart", touch, touches);
  }
}