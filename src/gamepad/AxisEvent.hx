package gamepad;

import events.Event;

class AxisEvent extends Event {
  public var x: Float;
  public var y: Float;
  public var indexes: Array<Int>;

  public function new(type: String, x: Float, y: Float, indexes: Array<Int>) {
    super(type);

    this.x = x;
    this.y = y;
    this.indexes = indexes;
  }
}