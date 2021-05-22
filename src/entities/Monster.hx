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
  public var wanderRate: Float;
  public var seekRate: Float;
  public var hungerRate: Float;

  public function new() {
    super("monster");
    this.active = false;
    this.maxSpeed = 32 / 8 / 60;
    this.wanderRate = 0.25;
    this.seekRate = 0.25;
    this.hungerRate = 0.25;

    this.states.add(this.updateIdle);
  }

  // 1 s = 60 f * 8 sf/f = (60 * 8) sf
  // x px/s = y px/sf
  // x_pixel_per_subframe_frame * y_subframe * z_frame = w_ 
  private function updateIdle() {
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
      this.velocity = difference;
      return Terminate;
    } else {
      return Continue;
    }
  }

  private function targetReached() {
    return this.target.floatEqual(this.position);
  }

  private function changeDirection() {
    var model = Controller.getInstance().model;
    var world = model.world;
    var oldTarget = this.target != null ? this.target.clone() : null;
    var grid = oldTarget != null ? world.toGridCoordinates(oldTarget.x, oldTarget.y) : world.toGridCoordinates(this.position.x, this.position.y);

    if (oldTarget != null) {
      var direction = this.velocity.clone().normalize();
      var newGrid = grid.clone().add(new Point2DInt(Std.int(direction.x) * 2, Std.int(direction.y) * 2));
      this.target = world.toWorldCoordinates(newGrid.x, newGrid.y);
    }

    var hasSeeked = false;
    if (Math.random() < this.seekRate) {
      hasSeeked = true;
      var gridDisplacement = new Point2DInt(0, 0);
      var difference = model.hero.position.clone().subtract(this.position);
      if (Math.abs(difference.x) <= Math.abs(difference.y)) {
        gridDisplacement.x = 0;
        gridDisplacement.y = 2;
        if (difference.y < 0) {
          gridDisplacement.y = -2;
        }
      } else {
        gridDisplacement.x = 2;
        gridDisplacement.y = 0;
        if (difference.x < 0) {
          gridDisplacement.x = -2;
        }
      }
      var newGrid = grid.clone().add(gridDisplacement);
      this.target = world.toWorldCoordinates(newGrid.x, newGrid.y);
    }
    
    if (this.target == null || !world.canMove(this, this.target) || (!hasSeeked && Math.random() < this.wanderRate)) {
      do {
        var newGrid = grid.clone();

        switch (Std.int(Math.random() * 4)) {
          case 0: newGrid.add(new Point2DInt(2, 0));
          case 1: newGrid.add(new Point2DInt(0, 2));
          case 2: newGrid.add(new Point2DInt(-2, 0));
          case 3: newGrid.add(new Point2DInt(0, -2));
        }
        
        this.target = world.toWorldCoordinates(newGrid.x, newGrid.y);

      } while (!world.canMove(this, this.target));
    }

    var oldDirection = oldTarget != null ? oldTarget.clone().subtract(this.position).normalize() : null;
    var newDirection = this.target.clone().subtract(this.position).normalize();
    if (oldDirection == null || !oldDirection.floatEqual(newDirection)) {
      this.velocity = newDirection.multiply(this.maxSpeed);
    }
  }
}