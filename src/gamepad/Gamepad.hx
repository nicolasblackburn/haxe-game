package gamepad;

import events.EventType;

interface Gamepad {
  public var axes: Array<Float>;
  public var buttons: Array<{value: Float, pressed: Bool}>;
  public function on<T>(type: EventType<T>, listener: T->Void): Void;
  public function off<T>(type: EventType<T>, listener: T->Void): Array<Dynamic->Void>;
}