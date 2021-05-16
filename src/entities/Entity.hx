package entities;

import coroutines.Coroutines;
import geom.Rectangle;
import geom.Point2D;
import physics.Body;

class Entity implements Body {
  public var active = true;
  public var kind = "entity";
  public var position = new Point2D(0, 0);
  public var velocity = new Point2D(0, 0);
  public var acceleration = new Point2D(0, 0);
  public var bounds = new Rectangle(0, 0, 16, 16);
  public var maxSpeed = 1.5 * 32 / 8 / 60;
  public var states = new Coroutines();

  public function new(kind: String) {
    this.kind = kind;
  }
}