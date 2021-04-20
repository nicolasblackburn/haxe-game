import gamepad.MultiGamepad;
import js.Browser;

class Main {
  public static var model: Model;
  public static var controller: Controller;

  static function main() {
    var model = new Model();
    var controller = new Controller(model, new View(model));
    controller.start();

    // For debuging
    (cast Browser.window).controller = controller;
  }
}



