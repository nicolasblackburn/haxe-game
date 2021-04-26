import geom.Point2D;
import js.html.Console;
import physics.Body;
import physics.PhysicsModel;
import geom.Rectangle;
import geom.RectangleOperations.*;
import entities.World;
import entities.Enemy;
import entities.Hero;

class Model implements PhysicsModel {
  public var world: World;
  public var hero: Hero;
  public var enemies: Array<Enemy>;

  private var controller: Controller;

  public function new() {
    this.world = new World();
    this.hero = new Hero();
    this.enemies = [for (_ in 0...10) new Enemy()];
  }

  public function setController(controller: Controller) {
    this.controller = controller;
  }

  public function init() {
    var tileSize = this.world.tileSize;
    var gridSize = this.world.gridSize;

    this.hero.position.x = (Std.int(Math.random() * 4) + 5) 
    * tileSize.x * 2;
    this.hero.position.y = (Std.int(Math.random() * 3) + 3) 
    * tileSize.y * 2;

    while (!this.world.canMove(this.hero, this.hero.position)) {
      this.hero.position.x = (Std.int(Math.random() * 4) + 5) 
      * tileSize.x * 2;
      this.hero.position.y = (Std.int(Math.random() * 3) + 3) 
      * tileSize.y * 2;
    }

    var heroRegion = new Rectangle(
      this.hero.position.x + this.hero.bounds.x - this.world.tileSize.x,
      this.hero.position.y + this.hero.bounds.y - this.world.tileSize.y,
      this.hero.bounds.width + 2 * this.world.tileSize.x,
      this.hero.bounds.height + 2 * this.world.tileSize.y
    );

    for (enemy in this.enemies.slice(0, 4)) {
      enemy.active = true;

      enemy.position.x = (Std.int(Math.random() * (gridSize.x / 2 - 2)) + 1) 
      * tileSize.x * 2;
      enemy.position.y = (Std.int(Math.random() * (gridSize.y / 2 - 2)) + 1) 
      * tileSize.y * 2;
  
      while (!this.world.canMove(enemy, enemy.position) || overlap(heroRegion, enemy.bounds)) {
        enemy.position.x = (Std.int(Math.random() * (gridSize.x / 2 - 2)) + 1) 
        * tileSize.x * 2;
        enemy.position.y = (Std.int(Math.random() * (gridSize.y / 2 - 2)) + 1) 
        * tileSize.y * 2;
      }
    }
  }

  public function update(deltaTime: Float) {
    var gamepad = this.controller.gamepad;
  
    this.hero.velocity.set(gamepad.axes[0], gamepad.axes[1]).multiply(this.hero.maxSpeed);
  }

  public function getBodies() {
    if (this.hero.active) {
      return [cast (this.hero, Body)].concat(cast this.enemies.filter(e -> e.active));
    } else {
      return cast this.enemies.filter(e -> e.active);
    }
  }

  public function move(body: Body, position: Point2D) {
    var displacement = position.clone().subtract(body.position);
    body.position.x += displacement.x;
    if (!this.world.canMove(body, body.position)) {
      this.resolveCollisionX(body, body.velocity);
    }
    body.position.y += displacement.y;
    if (!this.world.canMove(body, body.position)) {
      this.resolveCollisionY(body, body.velocity);
    }
  }

  private function resolveCollisionX(body: Body, displacement: Point2D) {
    var topCorner = if (displacement.x >= 0) {
      body.position.clone().add(new Point2D(body.bounds.x, body.bounds.y)).add(new Point2D(body.bounds.width, 0));
    } else {
      body.position.clone().add(new Point2D(body.bounds.x, body.bounds.y));
    }

    var bottomCorner = topCorner.clone().add(new Point2D(0, body.bounds.height));
    
    var correctionX = if (displacement.x >= 0) {
      -(body.position.x + body.bounds.x + body.bounds.width) % this.world.tileSize.x;
    } else {
      this.world.tileSize.x - (body.position.x + body.bounds.x) % this.world.tileSize.x;
    }
    body.position.x += correctionX;

    if (!this.world.canMovePoint(topCorner) && this.world.canMovePoint(bottomCorner)) {
      var nudgeY = Math.min(
        Math.abs(body.velocity.x) / Math.sqrt(2),
        this.world.tileSize.y - topCorner.y % this.world.tileSize.y
      );
      if (nudgeY > displacement.y) {
        body.velocity.y = nudgeY;
      }
    } else if (this.world.canMovePoint(topCorner) && !this.world.canMovePoint(bottomCorner)) {
      var nudgeY = Math.max(
        -Math.abs(body.velocity.x) / Math.sqrt(2),
        -bottomCorner.y % this.world.tileSize.y
      );
      if (nudgeY < displacement.y) {
        body.velocity.y = nudgeY;
      }
    }
  }

  private function resolveCollisionY(body: Body, displacement: Point2D) {
    var leftCorner = if (displacement.y >= 0) {
      body.position.clone().add(new Point2D(body.bounds.x, body.bounds.y)).add(new Point2D(0, body.bounds.height));
    } else {
      body.position.clone().add(new Point2D(body.bounds.x, body.bounds.y));
    }

    var rightCorner = leftCorner.clone().add(new Point2D(body.bounds.width, 0));

    var correctionY = if (displacement.y >= 0) {
      -(body.position.y + body.bounds.y + body.bounds.height) % this.world.tileSize.y;
    } else {
      this.world.tileSize.y - (body.position.y + body.bounds.y) % this.world.tileSize.y;
    }
    body.position.y += correctionY;

    if (!this.world.canMovePoint(leftCorner) && this.world.canMovePoint(rightCorner)) {
      var nudgeX = Math.min(
        Math.abs(body.velocity.y) / Math.sqrt(2),
        this.world.tileSize.x - leftCorner.x % this.world.tileSize.x
      );
      if (nudgeX > displacement.x) {
        body.position.x += nudgeX;
      }
    } else if (this.world.canMovePoint(leftCorner) && !this.world.canMovePoint(rightCorner)) {
      var nudgeX = Math.max(
        -Math.abs(body.velocity.y) / Math.sqrt(2),
        -rightCorner.x % this.world.tileSize.x
      );
      if (nudgeX < displacement.x) {
        body.position.x += nudgeX;
      }
    }
  }
}