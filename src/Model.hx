import geom.Rectangle;
import geom.RectangleOperations.*;
import entities.World;
import entities.Enemy;
import entities.Hero;

class Model {
  public var world: World;
  public var hero: Hero;
  public var enemies: Array<Enemy>;

  public function new() {
    this.world = new World();
    this.hero = new Hero();
    this.enemies = [for (_ in 0...10) new Enemy()];
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

  }
}