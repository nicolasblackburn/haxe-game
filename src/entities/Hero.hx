package entities;

import coroutines.Result;

class Hero extends Entity {
  public function new() {
    super("hero");
    this.maxSpeed = 32 / 8 / 60;

    this.states.add(this.updateNormal);
  }

  public function updateNormal() {
    var gamepad = Controller.getInstance().gamepad;
    this.velocity.set(gamepad.axes[0], gamepad.axes[1]).multiply(this.maxSpeed);
    return Continue;
  }
}