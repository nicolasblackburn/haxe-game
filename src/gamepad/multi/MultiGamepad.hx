package gamepad.multi;

import gamepad.events.ButtonReleasedEvent;
import gamepad.events.ButtonPressedEvent;
import gamepad.events.AxisReleasedEvent;
import gamepad.events.AxisPressedEvent;
import events.Emitter;
import gamepad.events.GamepadEvent.*;
import gamepad.keyboard.KeyboardGamepad;
import gamepad.touch.TouchGamepad;

class MultiGamepad extends Emitter implements Gamepad {
  public var axes = [0.0, 0.0];
  public var buttons = [{value: 0.0, pressed: false}];
  private var touchGamepad: TouchGamepad;
  private var keyboardGamepad: KeyboardGamepad;

  public function new() {
    super();

    this.touchGamepad = new TouchGamepad({
      axisDistance: 64,
      eightDirectional: true,
      dualHands: false
    });
    this.keyboardGamepad = new KeyboardGamepad();
    
    this.touchGamepad.on(AxisPressed, event -> this.onAxisPressed(event));
    this.touchGamepad.on(AxisReleased, event -> this.onAxisReleased(event));
    this.touchGamepad.on(ButtonPressed, event -> this.onButtonPressed(event));
    this.touchGamepad.on(ButtonReleased, event -> this.onButtonReleased(event));
    this.keyboardGamepad.on(AxisPressed, event -> this.onAxisPressed(event));
    this.keyboardGamepad.on(AxisReleased, event -> this.onAxisReleased(event));
    this.keyboardGamepad.on(ButtonPressed, event -> this.onButtonPressed(event));
    this.keyboardGamepad.on(ButtonReleased, event -> this.onButtonReleased(event));
  }

  private function onAxisPressed(event: AxisPressedEvent) {
    this.axes[event.indexes[0]] = event.x;
    this.axes[event.indexes[1]] = event.y;
    this.emit(AxisPressed, event);
  }

  private function onAxisReleased(event: AxisReleasedEvent) {
    this.axes[event.indexes[0]] = event.x;
    this.axes[event.indexes[1]] = event.y;
    this.emit(AxisReleased, event);
  }

  private function onButtonPressed(event: ButtonPressedEvent) {
    this.buttons[event.index].pressed = event.pressed;
    this.buttons[event.index].value = event.value;
    this.emit(ButtonPressed, event);
  }

  private function onButtonReleased(event: ButtonReleasedEvent) {
    this.buttons[event.index].pressed = event.pressed;
    this.buttons[event.index].value = event.value;
    this.emit(ButtonReleased, event);
  }
}