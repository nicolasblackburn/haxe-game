package gamepad.touch.events;

class TouchMoveEvent extends TouchEvent {
  public function new(touch, touches) {
    super("touchmove", touch, touches);
  }
}