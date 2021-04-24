package gamepad.touch;

import js.html.Console;
import gamepad.events.AxisReleasedEvent;
import gamepad.events.AxisPressedEvent;
import geom.Point2D;
import gamepad.events.ButtonReleasedEvent;
import gamepad.events.ButtonPressedEvent;
import gamepad.events.GamepadEvent;
import gamepad.touch.events.TouchEvent;
import gamepad.touch.events.TapReleasedEvent;
import gamepad.touch.events.TapPressedEvent;
import gamepad.touch.events.TouchEndOutsideEvent;
import gamepad.touch.events.TouchEndEvent;
import gamepad.touch.events.TouchMoveEvent;
import gamepad.touch.events.TouchStartEvent;
import geom.Rectangle;
import events.Emitter;

class TouchGamepad extends Emitter implements Gamepad {
  public var axes = [0.0, 0.0];
  public var buttons = [{value: 0.0, pressed: false}];
  private var options: TouchGamepadOptions;
  private var surface: TouchSurface;
  private var regions: Array<TouchRegion> = [];

  public function new(options: TouchGamepadOptions) {
    super();
    this.options = options;
    this.surface = new TouchSurface({
      delayTouchStart: !this.options.dualHands ? true : false,
      touchStartDistanceThresold: !this.options.dualHands ? 7 : 0,
      tapTimeThresold: !this.options.dualHands ? 100 : 0
    });
    if (this.options.dualHands) {
      this.regions.push(new TouchRegion({
        surface: this.surface,
        region: new Rectangle(0, 0, 0.5, 1)
      }));
      this.regions.push(new TouchRegion({
        surface: this.surface,
        region: new Rectangle(0.5, 0, 0.5, 1)
      }));
    } else {
      this.regions.push(new TouchRegion({
        surface: this.surface,
        region: new Rectangle(0, 0, 1, 1)
      }));
    }

    for (i in 0 ... this.regions.length) {
      this.regions[i].on(TouchEvent.TouchStart, event -> this.onTouchStart(i, event));
      this.regions[i].on(TouchEvent.TouchMove, event -> this.onTouchMove(i, event));
      this.regions[i].on(TouchEvent.TouchEnd, event -> this.onTouchEnd(i, event));
      this.regions[i].on(TouchEvent.TouchEndOutside, event -> this.onTouchEndOutside(i, event));
      this.regions[i].on(TouchEvent.TapPressed, event -> this.onTapPressed(i, event));
      this.regions[i].on(TouchEvent.TapReleased, event -> this.onTapReleased(i, event));
    }
  }

  private function onTouchStart(regionIndex: Int, event: TouchStartEvent) {
    if (regionIndex == 1 && this.options.dualHands) {
      var index = 0;
      this.buttons[index].value = 1;
      this.buttons[index].pressed = true;
      this.emit(GamepadEvent.ButtonPressed, new ButtonPressedEvent(this.buttons[index].value, index));
    }
  }

  private function onTouchMove(regionIndex: Int, event: TouchMoveEvent) {
    var displacement = new Point2D(event.touch.moveX, event.touch.moveY);
    if (displacement.equal(new Point2D(0, 0))) {
      this.axes[0] = 0;
      this.axes[1] = 0;
    } else {
      var norm = displacement.norm();
      var normalizedValue = Math.min(this.options.axisDistance, norm) / this.options.axisDistance; 
      if (this.options.eightDirectional) {
        var angle = 2 * Math.PI * this.discretizedAngle(8, displacement) / 8;
        displacement = new Point2D(Math.cos(angle), Math.sin(angle)).multiply(normalizedValue);
      } else {
        displacement.multiply(normalizedValue / norm);
      }
      this.axes[0] = displacement.x;
      this.axes[1] = displacement.y;
    }
    if (!this.options.dualHands && this.buttons[0].pressed) {
      var index = 0;
      this.buttons[index].value = 0;
      this.buttons[index].pressed = false;
      this.emit(GamepadEvent.ButtonReleased, new ButtonReleasedEvent(index));
    }
    this.emit(GamepadEvent.AxisPressed, new AxisPressedEvent(this.axes[0], this.axes[1], [0, 1]));
  }

  private function onTouchEnd(regionIndex: Int, event: TouchEndEvent) {
    if (regionIndex == 1 && this.options.dualHands) {
      var index = 0;
      this.buttons[index].value = 0;
      this.buttons[index].pressed = false;
      this.emit(GamepadEvent.ButtonReleased, new ButtonReleasedEvent(index));
    } else if (regionIndex == 0) {
      this.axes[0] = 0;
      this.axes[1] = 0;
      this.emit(GamepadEvent.AxisReleased, new AxisReleasedEvent([0, 1]));
    }
  }

  private function onTouchEndOutside(regionIndex: Int, event: TouchEndOutsideEvent) {
    this.axes[0] = 0;
    this.axes[1] = 0;
    this.emit(GamepadEvent.AxisReleased, new AxisReleasedEvent([0, 1]));
  }

  private function onTapPressed(regionIndex: Int, event: TapPressedEvent) {
    if (regionIndex == 0 && !this.options.dualHands) {
      var index = 0;
      this.buttons[index].value = 1;
      this.buttons[index].pressed = true;
      this.emit(GamepadEvent.ButtonPressed, new ButtonPressedEvent(this.buttons[index].value, index));
    }
  }

  private function onTapReleased(regionIndex: Int, event: TapReleasedEvent) {
    if (regionIndex == 0 && !this.options.dualHands) {
      var index = 0;
      this.buttons[index].value = 0;
      this.buttons[index].pressed = false;
      this.emit(GamepadEvent.ButtonReleased, new ButtonReleasedEvent(index));
    }
  }

  private function discretizedAngle(n: Int, v: Point2D) {
    var a = Math.atan2(v.y, v.x) / 2 / Math.PI * n + 1 / 2;
    return Math.floor(a + (a < 0 ? n : 0));
  }
}