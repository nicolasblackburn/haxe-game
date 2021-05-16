import geom.Rectangle;
import gamepad.touch.events.TouchEvent;
import js.Browser;
import gamepad.touch.TouchSurface;
import gamepad.touch.TouchRegion;
import coroutines.Coroutines;
import coroutines.Result;

class Main {
  public static var model: Model;
  public static var controller: Controller;

  static function main() {
    var model = new Model();
    var controller = Controller.createInstance(model, new View(model));
    controller.start();

    // For debuging
    (cast Browser.window).Controller = Controller;
    (cast Browser.window).Coroutines = Coroutines;
    (cast Browser.window).Result = Result;
  }
}



