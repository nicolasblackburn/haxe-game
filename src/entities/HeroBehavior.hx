package entities;

import gamepad.Gamepad;
import coroutines.Result;
import coroutines.Coroutine;

class HeroBehavior implements Coroutine {
  private var gamepad: Gamepad;
  private var hero: Hero;

  public function new(gamepad: Gamepad, hero: Hero) {
    this.gamepad = gamepad;
    this.hero = hero;  
  }

  public function next() {
    this.hero.velocity.x = this.gamepad.axes[0] * this.hero.walkSpeed;
    this.hero.velocity.y = this.gamepad.axes[1] * this.hero.walkSpeed;
    return new Result(false);
  }
}