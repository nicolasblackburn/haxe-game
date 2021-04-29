package gamepad.keyboard;

import geom.Point2D;
import gamepad.events.ButtonReleasedEvent;
import gamepad.events.AxisReleasedEvent;
import gamepad.events.ButtonPressedEvent;
import gamepad.events.AxisPressedEvent;
import js.Browser;
import js.html.KeyboardEvent;
import events.Emitter;

private typedef Keymap = {
  var type: String;
  var index: Int;
  var value: Float;
  var ?reverseKey: String;
}

class KeyboardGamepad extends Emitter implements Gamepad {
  public var axes = [0.0, 0.0];
  public var buttons = [{value: 0.0, pressed: false}];

  private var keysStack: Array<String> = [];
  private var mappings: Map<String, Keymap> = [
    "ArrowUp" => {type: "axis", index: 1, value: -1.0},
    "ArrowRight" => {type: "axis", index: 0, value: 1.0},
    "ArrowDown" => {type: "axis", index: 1, value: 1.0},
    "ArrowLeft" => {type: "axis", index: 0, value: -1.0},
    "a" => {type: "button", index: 0, value: 1.0}
  ];
  private var pureAxes = [0.0, 0.0];

  public function new() {
    super();

    Browser.window.addEventListener("keydown", event -> this.onKeyDown(event));
    Browser.window.addEventListener("keyup", event -> this.onKeyUp(event));
  }

  private function onKeyDown(event: KeyboardEvent) {
    if (this.mappings.exists(event.key)) {
      var keymap = this.mappings[event.key];
      switch (keymap.type) {
        case "axis":
          if (this.pureAxes[keymap.index] != keymap.value) {
            this.keysStack.push(event.key);
            this.pureAxes[keymap.index] = keymap.value;
            var normalized = new Point2D(this.pureAxes[0], this.pureAxes[1]).normalize();
            this.axes[0] = normalized.x;
            this.axes[1] = normalized.y;
            this.emit('axispressed', new AxisPressedEvent(this.axes[0], this.axes[1], [0, 1]));
          }
        case "button":
          if (this.buttons[keymap.index].value != keymap.value) {
            this.keysStack.push(event.key);
            this.buttons[keymap.index].value = keymap.value;
            this.buttons[keymap.index].pressed = true;
            this.emit('buttonpressed', new ButtonPressedEvent(keymap.value, keymap.index));
          }
      }
    }
  }

  private function onKeyUp(event: KeyboardEvent) {
    if (this.mappings.exists(event.key)) {
      var keymap = this.mappings[event.key];
      switch (keymap.type) {
        case "axis":
          this.keysStack = this.keysStack.filter(key -> key != event.key);
          if (reverseKeyInStack(event.key)) {
            this.pureAxes[keymap.index] = -this.pureAxes[keymap.index];
          } else {
            this.pureAxes[keymap.index] = 0.0;
          }
          var normalized = new Point2D(this.pureAxes[0], this.pureAxes[1]).normalize();
          this.axes[0] = normalized.x;
          this.axes[1] = normalized.y;
          if (this.axes[0] == 0.0 && this.axes[1] == 0.0) {
            this.emit('axisreleased', new AxisReleasedEvent([0, 1]));
          } else {
            this.emit('axispressed', new AxisPressedEvent(this.axes[0], this.axes[1], [0, 1]));
          }
        case "button":
          this.keysStack = this.keysStack.filter(key -> key != event.key);
          this.buttons[keymap.index].value = 0.0;
          this.buttons[keymap.index].pressed = false;
          this.emit('buttonreleased', new ButtonReleasedEvent(keymap.index));
      }
    }
  }

  private function reverseKeyInStack(key: String) {
    for (reverseKey => map in this.mappings) {
      if (map.index == this.mappings[key].index && map.value == -this.mappings[key].value && this.keysStack.indexOf(reverseKey) >= 0) {
        return true;
      }
    }
    return false;
  }
}