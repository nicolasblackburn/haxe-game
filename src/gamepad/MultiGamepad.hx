package gamepad;

import events.Events;
import events.Emitter;

class MultiGamepad extends Emitter {
  public var axes = [0.0, 0.0];
  public var buttons = [{value: 0.0, pressed: false}];
  private var touchGamepad: TouchGamepad;
  private var keyboardGamepad: KeyboardGamepad;

  public function new() {
    super();

    this.touchGamepad = new TouchGamepad();
    this.keyboardGamepad = new KeyboardGamepad();
    
    this.touchGamepad.on(GamepadEvent.AxisPressed, event -> this.onAxisPressed(event));
    this.touchGamepad.on(GamepadEvent.AxisReleased, event -> this.onAxisReleased(event));
    this.touchGamepad.on(GamepadEvent.ButtonPressed, event -> this.onButtonPressed(event));
    this.touchGamepad.on(GamepadEvent.ButtonReleased, event -> this.onButtonReleased(event));
    this.keyboardGamepad.on(GamepadEvent.AxisPressed, event -> this.onAxisPressed(event));
    this.keyboardGamepad.on(GamepadEvent.AxisReleased, event -> this.onAxisReleased(event));
    this.keyboardGamepad.on(GamepadEvent.ButtonPressed, event -> this.onButtonPressed(event));
    this.keyboardGamepad.on(GamepadEvent.ButtonReleased, event -> this.onButtonReleased(event));
  }

  private function onAxisPressed(event: AxisPressedEvent) {
    this.axes[event.indexes[0]] = event.x;
    this.axes[event.indexes[1]] = event.y;
    this.emit(GamepadEvent.AxisPressed, event);
  }

  private function onAxisReleased(event: AxisReleasedEvent) {
    this.axes[event.indexes[0]] = event.x;
    this.axes[event.indexes[1]] = event.y;
    this.emit(GamepadEvent.AxisReleased, event);
  }

  private function onButtonPressed(event: ButtonPressedEvent) {
    this.buttons[event.index].pressed = event.pressed;
    this.buttons[event.index].value = event.value;
    this.emit(GamepadEvent.ButtonPressed, event);
  }

  private function onButtonReleased(event: ButtonReleasedEvent) {
    this.buttons[event.index].pressed = event.pressed;
    this.buttons[event.index].value = event.value;
    this.emit(GamepadEvent.ButtonReleased, event);
  }
}