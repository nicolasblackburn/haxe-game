package physics;

import js.html.Console;

class Physics {
  private var model: PhysicsModel;

  public function new(model: PhysicsModel) {
    this.model = model;
  }

  public function update(deltaTime: Float) {
    for (body in this.model.getBodies()) {
      body.velocity.add(body.acceleration);
      body.position.add(body.velocity);
    }
  }
}