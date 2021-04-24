package physics;

class Physics {
  private var model: Model;

  public function new(model: Model) {
    this.model = model;
  }

  public function update(deltaTime: Float) {
    var bodies = [cast (this.model.hero, Body)].concat(cast this.model.enemies);
    for (body in bodies) {
      body.velocity.add(body.acceleration);
      body.position.add(body.velocity);
    }
  }
}