package gamepad.touch;

import gamepad.touch.events.TouchEndOutsideEvent;
import gamepad.touch.events.TouchMoveEvent;
import gamepad.touch.events.TouchEndEvent;
import gamepad.touch.events.TouchStartEvent;
import gamepad.touch.events.TapReleasedEvent;
import gamepad.touch.events.TapPressedEvent;
import gamepad.touch.events.TouchEvent;
import js.Browser;
import events.Emitter;
import haxe.ds.Option;

class TouchRegion extends Emitter {
  private var options: TouchRegionOptions; 
  private var touches: Array<TouchState> = [];

  public function new(options: TouchRegionOptions) {
    super();
    this.options = options;
    this.options.surface.on(TouchEvent.TapPressed, this.onTapPressed);
    this.options.surface.on(TouchEvent.TapReleased, this.onTapReleased);
    this.options.surface.on(TouchEvent.TouchStart, this.onTouchStart);
    this.options.surface.on(TouchEvent.TouchMove, this.onTouchMove);
    this.options.surface.on(TouchEvent.TouchEnd, this.onTouchEnd);
    this.options.surface.on(TouchEvent.TouchEndOutside, this.onTouchEndOutside);
  }

  private function onTapPressed(event: TapPressedEvent) {
    if (this.inRegion({x: event.touch.x, y: event.touch.y}, this.options.region)) {
      switch (this.findTouch(event.touch)) {
        case None:
          this.touches.push(event.touch);
        case _:
      }
      this.emit(TouchEvent.TapPressed, event);
    }
  }

  private function onTapReleased(event: TapReleasedEvent) {
    if (this.inRegion({x: event.touch.x, y: event.touch.y}, this.options.region)) {
      switch (this.findTouch(event.touch)) {
        case Some(touch):
          this.touches.remove(touch);
          this.emit(TouchEvent.TapReleased, event);
        case _:
      }
    }
  }

  private function onTouchStart(event: TouchStartEvent) {
    if (this.inRegion({x: event.touch.x, y: event.touch.y}, this.options.region)) {
      switch (this.findTouch(event.touch)) {
        case None:
          this.touches.push(event.touch);
        case _:
      }
      this.emit(TouchEvent.TouchStart, event);
    }
  }

  private function onTouchMove(event: TouchMoveEvent) {
    if (this.inRegion({x: event.touch.x, y: event.touch.y}, this.options.region)) {
      switch (this.findTouch(event.touch)) {
        case Some(touch):
          touch.x = event.touch.x;
          touch.y = event.touch.y;
          this.emit(TouchEvent.TouchMove, event);
        case _:
      }
    }
  }

  private function onTouchEnd(event: TouchEndEvent) {
    if (this.inRegion({x: event.touch.x, y: event.touch.y}, this.options.region)) {
      switch (this.findTouch(event.touch)) {
        case Some(touch):
          this.touches.remove(touch);
          this.emit(TouchEvent.TouchEnd, event);
        case _:
      }
    } else {
      switch (this.findTouch(event.touch)) {
        case Some(touch):
          this.touches.remove(touch);
          this.emit(TouchEvent.TouchEndOutside, new TouchEndOutsideEvent(event.touch, event.touches));
        case _:
      }
    }
  }

  private function onTouchEndOutside(event: TouchEndOutsideEvent) {
    if (this.inRegion({x: event.touch.x, y: event.touch.y}, this.options.region)) {
      switch (this.findTouch(event.touch)) {
        case Some(touch):
          this.touches.remove(touch);
          this.emit(TouchEvent.TouchEndOutside, event);
        case _:
      }
    }
  }

  private function findTouch(touch1: TouchState) {
    for (touch2 in this.touches) {
      if (touch1.id == touch2.id) {
        return Some(touch2);
      }
    }
    return None;
  }

  private function inRegion(point: {x: Int, y: Int}, region: {x: Float, y: Float, width: Float, height: Float}) {
    return region.x * Browser.window.innerWidth <= point.x &&
      point.x <= (region.x + region.width) * Browser.window.innerWidth &&
      region.y * Browser.window.innerHeight <= point.y &&
      point.y <= (region.y + region.height) * Browser.window.innerHeight;
  }
}