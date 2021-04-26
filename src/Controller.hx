import js.html.Console;
import gamepad.Gamepad;
import coroutines.Coroutines;
import gamepad.multi.MultiGamepad;
import gamepad.events.GamepadEvent;
import events.Events;
import physics.Physics;
import geom.Rectangle;
import js.Browser;
import loader.Loader;

class Controller {
  private static var instance: Controller;

  public var started = false;
  public var paused = false;
  public var model: Model;
  public var view: View;
  public var physics: Physics;
  public var events: Events;
  public var viewport: Rectangle;
  public var gamepad: Gamepad;
  public var coroutines: Coroutines;
  public var loader: Loader;

  private var lastTime: Float;
  private var fixedTimeStep: Float = 1000 / 60 / 8;
  private var fixedTimeLeft: Float = 0;

  public function new(model: Model, view: View) {
    this.model = model;
    this.view = view;
    this.events = new Events();
    this.physics = new Physics(this.model);
    this.viewport = new Rectangle(0, 0, 0, 0);
    this.gamepad = new MultiGamepad();
    this.coroutines = new Coroutines();
    this.loader = new Loader();
    this.model.setController(this);
  }

  public static function createInstance(model: Model, view: View) {
    if (Controller.instance == null) {
      Controller.instance = new Controller(model, view);
    }
    return Controller.instance;
  }

  public static function getInstance() {
    return Controller.instance;
  }

  public function start() {
    if (!this.started) {
      this.started = true;
      
      this.init();

      function loop(currentTime: Float) {
        if (!this.paused) {
          var viewport = new Rectangle(0, 0, Browser.window.innerWidth, Browser.window.innerHeight);
          if (!this.viewport.equal(viewport)) {
            viewport.copyTo(this.viewport);
            this.view.resize(viewport);
          }

          this.events.processQueue();
          this.coroutines.update();

          var deltaTime = this.lastTime == null ? 0 : currentTime - this.lastTime;
  
          this.fixedTimeLeft += deltaTime;
  
          while (this.fixedTimeLeft >= this.fixedTimeStep) {
            this.fixedUpdate(this.fixedTimeStep);
            this.fixedTimeLeft -= this.fixedTimeStep;
          }

          this.update(deltaTime);
          
          this.lastTime = currentTime;

          Browser.window.requestAnimationFrame(loop);
        }
      }
      Browser.window.requestAnimationFrame(loop);
    }
  }

  private function init() {
    this.model.init();

    //this.coroutines.add(new HeroBehavior(this.gamepad, this.model.hero));
    
    this.gamepad.on(GamepadEvent.AxisPressed, event -> this.events.push(event));
    this.gamepad.on(GamepadEvent.AxisReleased, event -> this.events.push(event));
    this.gamepad.on(GamepadEvent.ButtonPressed, event -> this.events.push(event));
    this.gamepad.on(GamepadEvent.ButtonReleased, event -> this.events.push(event));
  }

  private function fixedUpdate(deltaTime: Float) {
    this.physics.update(deltaTime);
  }

  private function update(deltaTime: Float) {
    this.model.update(deltaTime);

    if (this.started && !this.view.visible) {
      this.view.visible = true;
    }
    this.view.update(deltaTime);
  }
}