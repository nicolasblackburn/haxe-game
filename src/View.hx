import geom.Rectangle;
import entities.Hero;
import entities.Enemy;
import entities.World;
import js.html.Element;
import js.Browser;

class View {
  public var visible = false;
  private var root: Element;
  private var scene: Element;
  private var world: Element;
  private var tiles: Array<Element> = [];
  private var enemies: Array<Element> = [];
  private var hero: Element;
  private var model: Model;
  private static inline var SVG_NS = "http://www.w3.org/2000/svg";
  
  public function new(model: Model) {
    this.model = model;

    this.root = this.createRoot();

    this.scene = this.createScene();
    this.root.appendChild(this.scene);

    this.world = this.createWorld();
    this.scene.appendChild(this.world);

    for (index in 0...model.world.tileIds.length) {
      var tileId = model.world.tileIds[index];
      
      var x = index % model.world.gridSize.x * model.world.tileSize.x;
      var y = Std.int(index / model.world.gridSize.x) * model.world.tileSize.y;

      var tile = this.createTile(tileId, x, y, model.world.tileSize.x, model.world.tileSize.y);

      this.world.appendChild(tile);
      this.tiles.push(tile);
    }

    for (enemyModel in model.enemies) {
      var enemy = this.createEnemy(enemyModel);
      this.scene.appendChild(enemy);
      this.enemies.push(enemy);
    }

    this.hero = this.createHero(model.hero);
    this.scene.appendChild(this.hero);

    Browser.document.body.appendChild(this.root);
  }

  public function update(deltaTime: Float) {
    this.root.style.visibility = this.visible ? "" : "hidden";

    this.hero.style.visibility = this.model.hero.active ? "" : "hidden";
    if (this.model.hero.active) {
      this.hero.setAttributeNS(null, "cx", this.model.hero.position.x + this.model.hero.bounds.width / 2 + "px");
      this.hero.setAttributeNS(null, "cy", this.model.hero.position.y + this.model.hero.bounds.height / 2 + "px");
      this.hero.setAttributeNS(null, "rx", this.model.hero.bounds.width / 2 + "px");
      this.hero.setAttributeNS(null, "yy", this.model.hero.bounds.height / 2 + "px");
    }

    for (index in 0...this.model.enemies.length) {
      var enemyModel = this.model.enemies[index];
      var enemyView = this.enemies[index];
      enemyView.style.visibility = enemyModel.active ? "" : "hidden";
      if (enemyModel.active) {
        enemyView.setAttributeNS(null, "cx", enemyModel.position.x + enemyModel.bounds.width / 2 + "px");
        enemyView.setAttributeNS(null, "cy", enemyModel.position.y + enemyModel.bounds.height / 2 + "px");
        enemyView.setAttributeNS(null, "rx", enemyModel.bounds.width / 2 + "px");
        enemyView.setAttributeNS(null, "yy", enemyModel.bounds.height / 2 + "px");
      }
    }
  }

  public function resize(viewport: Rectangle) {
    var width = this.model.world.gridSize.x * this.model.world.tileSize.x;
    var height = this.model.world.gridSize.y * this.model.world.tileSize.y;
    var scale = Math.min(viewport.width / width, viewport.height / height);
    this.scene.setAttributeNS(null, "transform", 'scale(${scale}) translate(${(viewport.width / scale - width) / 2} ${(viewport.height / scale - height) / 2})');
    this.root.setAttributeNS(null, "width", viewport.width + "");
    this.root.setAttributeNS(null, "height", viewport.height + "");
  }

  private function createRoot() {
    return this.createElement("svg", [
      "width" => Browser.window.innerWidth,
      "height" => Browser.window.innerHeight
    ], [
      "visibility" => "hidden"
    ]);
  }

  private function createScene() {
    return this.createElement("g", [
      "class" => "scene"
    ]);
  }

  private function createWorld() {
    return this.createElement("g", [
      "class" => "world"
    ]);
  }

  private function createTile(tileId: Int, x: Float, y: Float,width: Float, height: Float) {
    return this.createElement("rect", [
      "class" => ["ground", "block"][tileId],
      "x" => '${x}px',
      "y" => '${y}px',
      "width" => '${width}px',
      "height" => '${height}px',
      "fill" => ["#303030", "#808080"][tileId],
      "shape-rendering" => "crispEdges"
    ]);
  }

  private function createHero(hero: Hero) {
    return this.createElement('ellipse', [
      "class" => "hero",
      "cx" => '${hero.bounds.width / 2}px',
      "cy" => '${hero.bounds.height / 2}px',
      "rx" => '${hero.bounds.width / 2}px',
      "ry" => '${hero.bounds.height / 2}px',
      "fill" => "#3366cc"
    ]);
  }

  private function createEnemy(enemy: Enemy) {
    return this.createElement('ellipse', [
      "class" => "enemy",
      "cx" => '${enemy.bounds.width / 2}px',
      "cy" => '${enemy.bounds.height / 2}px',
      "rx" => '${enemy.bounds.width / 2}px',
      "ry" => '${enemy.bounds.height / 2}px',
      "fill" => "#cc0066"
    ]);
  }

  private function createElement(name: String, ?attributes: Map<String, Any>, ?style: Map<String, Any>) {
    var element = Browser.document.createElementNS(SVG_NS, name);
    if (attributes != null) {
      for (key => value in attributes) {
        element.setAttributeNS(null, key, value);
      }
    }
    if (style != null) {
      for (key => value in style) {
        Reflect.setField(element.style, key, value);
      }
    }
    return element;
  }
}