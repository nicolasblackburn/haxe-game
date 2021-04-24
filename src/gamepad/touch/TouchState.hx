package gamepad.touch;

class TouchState {
  public var id: Int;
  public var x: Int;
  public var y: Int;
  public var moveX: Int;
  public var moveY: Int;
  public var startX: Int;
  public var startY: Int;
  public var pressed: Bool;
  public var started: Bool;
  public var startTime: Float;

  public function new(id: Int, x: Int, y: Int) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.startX = x;
    this.startY = y;
    this.moveX = 0;
    this.moveY = 0;
    this.pressed = false;
    this.started = false;
    this.startTime = Date.now().getTime();
  }
}