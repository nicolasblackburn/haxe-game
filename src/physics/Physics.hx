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
      this.model.move(body, body.position.clone().add(body.velocity));
    }
  }

  private function canMoveAbove() {
    return false;
  }

  private function canMoveBelow() {
    return false;
  }

  private function canMoveLeft() {
    return false;
  }

  private function canMoveRight() {
    return false;
  }
}