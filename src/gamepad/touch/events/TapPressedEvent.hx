package gamepad.touch.events;

class TapPressedEvent extends TouchEvent {
  public function new(touch, touches) {
    super("tappressed", touch, touches);
  }
}