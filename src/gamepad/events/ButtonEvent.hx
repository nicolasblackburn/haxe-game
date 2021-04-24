package gamepad.events;

import events.Event;

class ButtonEvent extends Event {
  public var pressed: Bool;
  public var value: Float;
  public var index: Int;

  public function new(type: String, pressed: Bool, value: Float, index: Int) {
    super(type);

    this.pressed = pressed;
    this.value = value;
    this.index = index;
  }
}