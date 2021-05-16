package physics;

import js.html.Console;

class Physics {
  private var model: PhysicsModel;

  public function new(model: PhysicsModel) {
    this.model = model;
  }

  public function fixedUpdate(deltaTime: Float) {
    for (body in this.model.getBodies()) {
      body.velocity.add(body.acceleration);
      this.model.move(body, body.position.clone().add(body.velocity));
    }
  }
}