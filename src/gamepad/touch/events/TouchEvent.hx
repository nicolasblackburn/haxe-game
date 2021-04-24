package gamepad.touch.events;

import events.EventType;

class TouchEvent {
  public static inline var TouchStart = new EventType<TouchStartEvent>("touchstart");
  public static inline var TouchMove = new EventType<TouchMoveEvent>("touchmove");
  public static inline var TouchEnd = new EventType<TouchEndEvent>("touchend");
  public static inline var TouchEndOutside = new EventType<TouchEndOutsideEvent>("touchendoutside");
  public static inline var TapPressed = new EventType<TapPressedEvent>("tappressed");
  public static inline var TapReleased = new EventType<TapReleasedEvent>("tapreleased");

  public var type: String;
  public var touches: Array<TouchState>;
  public var touch: TouchState;

  public function new(type, touch, touches) {
    this.type = type;
    this.touch = touch;
    this.touches = touches;
  }
}