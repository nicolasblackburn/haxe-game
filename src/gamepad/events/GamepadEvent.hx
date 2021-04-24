package gamepad.events;

import events.EventType;

class GamepadEvent {
  public static inline var AxisPressed = new EventType<AxisPressedEvent>("axispressed");
  public static inline var AxisReleased = new EventType<AxisReleasedEvent>("axisreleased");
  public static inline var ButtonPressed = new EventType<ButtonPressedEvent>("buttonpressed");
  public static inline var ButtonReleased = new EventType<ButtonReleasedEvent>("buttonreleased");
}