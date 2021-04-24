package gamepad.events;

class ButtonReleasedEvent extends ButtonEvent {
  public function new(index: Int) {
    super("buttonreleased", false, 0, index);
  }
}