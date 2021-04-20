package gamepad;

class ButtonPressedEvent extends ButtonEvent {
  public function new(value: Float, index: Int) {
    super("buttonpressed", true, value, index);
  }
}