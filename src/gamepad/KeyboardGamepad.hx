package gamepad;

import js.Browser;
import events.Emitter;
import js.html.KeyboardEvent;

private typedef Keymap = {
  var type: String;
  var index: Int;
  var value: Float;
}

class KeyboardGamepad extends Emitter {
  private var mappings: Map<String, Keymap> = [
    "ArrowUp" => {type: "axis", index: 0, value: 1.0},
    "ArrowRight" => {type: "axis", index: 0, value: 1.0},
    "ArrowDown" => {type: "axis", index: 0, value: -1.0},
    "ArrowLeft" => {type: "axis", index: 0, value: -1.0},
    "a" => {type: "button", index: 0, value: 1.0}
  ];
  public var axes = [0.0, 0.0];
  public var buttons = [{value: 0.0, pressed: false}];

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
          if (this.axes[keymap.index] != keymap.value) {
            this.axes[keymap.index] = keymap.value;
            this.emit('axispressed', new AxisPressedEvent(this.axes[0], this.axes[1], [0, 1]));
          }
        case "button":
          if (this.buttons[keymap.index].value != keymap.value) {
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
          if (this.axes[keymap.index] != 0.0) {
            this.axes[keymap.index] = 0.0;
            this.emit('axisreleased', new AxisReleasedEvent([0, 1]));
          }
        case "button":
          if (this.buttons[keymap.index].value != 0.0) {
            this.buttons[keymap.index].value = 0.0;
            this.buttons[keymap.index].pressed = false;
            this.emit('buttonreleased', new ButtonReleasedEvent(keymap.index));
          }
      }
    }
  }
}