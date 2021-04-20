package gamepad;

import events.EventType;

@:native("touchGamepad.TouchGamepad") extern class TouchGamepad {
  public var axes: Array<Float>;
  public var buttons: Array<{value: Float, pressed: Bool}>;
  public function new():Void;

  public function on<T>(event: EventType<T>, fn: T->Void): Void;
  public function off<T>(event: EventType<T>, fn: T->Void): Void;
}