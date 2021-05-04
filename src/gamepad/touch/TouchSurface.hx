package gamepad.touch;

import gamepad.touch.events.TapReleasedEvent;
import gamepad.touch.events.TouchEndEvent;
import gamepad.touch.events.TouchMoveEvent;
import gamepad.touch.events.TapPressedEvent;
import gamepad.touch.events.TouchStartEvent;
import gamepad.touch.events.TouchEvent;
import js.html.PointerEvent;
import events.Emitter;
import js.Browser;

class TouchSurface extends Emitter {
  private var options: TouchSurfaceOptions;
  private var touches: Array<TouchState> = [];
  private var distanceThresholdSquared: Int;

  public function new(options: TouchSurfaceOptions) {
    super();
    this.options = options;
    this.distanceThresholdSquared = this.options.touchStartDistanceThresold * this.options.touchStartDistanceThresold;
    Browser.document.body.style.touchAction = "none";
    Browser.document.addEventListener("pointerdown", this.onPointerDown);
    Browser.document.addEventListener("pointermove", this.onPointerMove);
    Browser.document.addEventListener("pointerup", this.onPointerUp);
  }

  private function onPointerDown(event: PointerEvent) {
    var touch = new TouchState(this.nextId(), event.x, event.y);
    this.touches.push(touch);

    if (this.options.delayTouchStart) {
      var timer = new haxe.Timer(this.options.tapTimeThresold);
      timer.run = function() { 
        timer.stop();
        if (!touch.started && !touch.pressed) {
          touch.pressed = true;
          this.emit(TouchEvent.TapPressed, new TapPressedEvent(touch, this.touches));
        }
      };
    } else {
      touch.started = true;
      this.emit(TouchEvent.TouchStart, new TouchStartEvent(touch, this.touches));
    }
  }

  private function onPointerMove(event: PointerEvent) {
    var touch = this.findClosest({x: event.x, y: event.y}, this.touches);
    if (touch != null) {
      touch.moveX = event.x - touch.startX;
      touch.moveY = event.y - touch.startY;
      touch.x = event.x;
      touch.y = event.y;
      
      if (
        !touch.started && 
        this.distanceSquared({x: touch.x, y :touch.y}, {x: touch.startX, y: touch.startY}) >= this.distanceThresholdSquared
      ) {
        touch.started = true;
        this.emit(TouchEvent.TouchStart, new TouchStartEvent(touch, this.touches));
      } else if (touch.started) {
        this.emit(TouchEvent.TouchMove, new TouchMoveEvent(touch, this.touches));
      }
    }
  }

  private function onPointerUp(event: PointerEvent) {
    var touch = this.findClosest({x: event.x, y: event.y}, this.touches);
    if (touch != null) {
      this.touches.splice(this.touches.indexOf(touch), 1);

      touch.moveX = event.x - touch.startX;
      touch.moveY = event.y - touch.startY;
      touch.x = event.x;
      touch.y = event.y;

      if (touch.started) {
        this.emit(TouchEvent.TouchEnd, new TouchEndEvent(touch, this.touches));
      } else {
        if (!touch.pressed) {
          touch.pressed = true;
          this.emit(TouchEvent.TapPressed, new TapPressedEvent(touch, this.touches));
        }
        this.emit(TouchEvent.TapReleased, new TapReleasedEvent(touch, this.touches));
      }
    }
  }

  private function nextId() {
    this.touches.sort((a, b) -> b.id - a.id);
    var id = 0;
    var i = 0;
    
    while (i < this.touches.length && id >= this.touches[i].id) {
      id = this.touches[i].id + 1;
      i++;
    }

    return id;
  }

  private function findClosest(touch: {x: Int, y: Int}, touches: Array<TouchState>) {
    var closest = null;
    var minDist = Math.POSITIVE_INFINITY;
    for (touch2 in touches) {
      var dx = touch.x - touch2.x;
      var dy = touch.y - touch2.y;
      var dist = dx * dx + dy * dy;
      if (closest == null || dist < minDist) {
        closest = touch2;
        minDist = dist;
      }
    }
    return closest;
  }

  private function distanceSquared(u: {x: Int, y: Int}, v: {x: Int, y: Int}) {
    var x = u.x - v.x;
    var y = u.y - v.y;
    return x * x + y * y;
  }
}