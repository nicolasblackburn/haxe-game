package gamepad.touch.events;

class TouchEndOutsideEvent extends TouchEvent {
  public function new(touch, touches) {
    super("touchendoutside", touch, touches);
  }
}