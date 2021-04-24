package gamepad.touch.events;

class TapReleasedEvent extends TouchEvent {
  public function new(touch, touches) {
    super("tapreleased", touch, touches);
  }
}