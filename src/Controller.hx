import gamepad.MultiGamepad;
import gamepad.GamepadEvent;
import events.Events;
import physics.Physics;
import geom.Rectangle;
import js.Browser;

class Controller {
  public var started = false;
  public var paused = false;
  public var model: Model;
  public var view: View;
  public var physics: Physics;
  public var events: Events;
  public var viewport: Rectangle;
  public var gamepad: MultiGamepad;

  private var lastTime: Float;
  private var fixedTimeStep: Float = 1000 / 60 / 8;
  private var fixedTimeLeft: Float = 0;

  public function new(model: Model, view: View) {
    this.model = model;
    this.view = view;
    this.events = new Events();
    this.physics = new Physics();
    this.viewport = new Rectangle(0, 0, 0, 0);
    this.gamepad = new MultiGamepad();
  }

  public function start() {
    if (!this.started) {
      this.started = true;
      
      this.model.init();
      this.initEvents();

      function loop(currentTime: Float) {
        if (!this.paused) {
          var viewport = new Rectangle(0, 0, Browser.window.innerWidth, Browser.window.innerHeight);
  
          if (this.lastTime == null) {
            viewport.copyTo(this.viewport);
            this.view.resize(viewport);

            this.events.processQueue();

            this.view.visible = true;
            this.view.update();
  
            this.lastTime = currentTime;
            this.fixedTimeLeft = 0;

          } else {
            if (!Rectangle.equal(this.viewport, viewport)) {
              viewport.copyTo(this.viewport);
              this.view.resize(viewport);
            }

            this.events.processQueue();
  
            var deltaTime = currentTime - this.lastTime;
    
            this.fixedTimeLeft += deltaTime;
    
            while (this.fixedTimeLeft >= this.fixedTimeStep) {
              this.physics.update(this.fixedTimeStep);
              this.fixedTimeLeft -= this.fixedTimeStep;
            }
    
            this.view.update();
            
            this.lastTime = currentTime;
          }
          Browser.window.requestAnimationFrame(loop);
        }
      }
      Browser.window.requestAnimationFrame(loop);
    }
  }

  private function initEvents() {
    this.gamepad.on(GamepadEvent.AxisPressed, event -> this.events.push(event));
    this.gamepad.on(GamepadEvent.AxisReleased, event -> this.events.push(event));
    this.gamepad.on(GamepadEvent.ButtonPressed, event -> this.events.push(event));
    this.gamepad.on(GamepadEvent.ButtonReleased, event -> this.events.push(event));
  }
}