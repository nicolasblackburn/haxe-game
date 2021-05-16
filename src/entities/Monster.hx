package entities;

import geom.Point2DInt;
import geom.Point2D;
import entities.Entity;
import coroutines.Result;

enum MonsterState {
  Idle;
  Seek;
}

class Monster extends Entity {
  public var target: Point2D;
  public var state = Idle;

  public function new() {
    super("monster");
    this.active = false;
    this.maxSpeed = 32 / 8 / 60;

    this.states.add(this.updateNormal);
  }

  private function updateNormal() {
    var world = Controller.getInstance().model.world;
    this.state = Idle;

    this.changeDirection();

    if (!world.canMove(this, this.target)) {
      return Continue;
    } else {
      return Push(this.updateSeek);
    }
  }

  private function updateSeek() {
    this.state = Seek;

    var difference = this.target.clone().subtract(this.position);
    var norm = difference.norm();

    if (this.maxSpeed >= norm) {
      return Terminate;
    } else {
      this.velocity = difference.normalize().multiply(this.maxSpeed);
      return Continue;
    }
  }

  private function targetReached() {
    return this.target.floatEqual(this.position);
  }

  private function changeDirection() {
    var world = Controller.getInstance().model.world;
    var oldTarget = this.target != null ? this.target.clone() : null;

    if (oldTarget != null) {
      var direction = this.velocity.clone().normalize();
      var grid = world.toGridCoordinates(oldTarget.x, oldTarget.y);
      grid.add(new Point2DInt(Std.int(direction.x) * 2, Std.int(direction.y) * 2));
      this.target = world.toWorldCoordinates(grid.x, grid.y);
    }
    
    if (this.target == null || !world.canMove(this, this.target) || Math.random() < 0.25) {
      do {
        var grid = oldTarget != null ? world.toGridCoordinates(oldTarget.x, oldTarget.y) : world.toGridCoordinates(this.position.x, this.position.y);
        switch (Std.int(Math.random() * 4)) {
          case 0: grid.add(new Point2DInt(2, 0));
          case 1: grid.add(new Point2DInt(0, 2));
          case 2: grid.add(new Point2DInt(-2, 0));
          case 3: grid.add(new Point2DInt(0, -2));
        }
        
        this.target = world.toWorldCoordinates(grid.x, grid.y);

      } while (!world.canMove(this, this.target));
    }
  }
}