package physics;

import geom.Point2D;

interface PhysicsModel {
  public function getBodies(): Array<Body>;
  public function move(body: Body, position: Point2D): Void;
}