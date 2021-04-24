package entities;

import geom.Rectangle;
import geom.Point2D;
import physics.Body;

class Enemy implements Body {
  public var active = false;
  public var name = "enemy";
  public var position = new Point2D(0, 0);
  public var velocity = new Point2D(0, 0);
  public var acceleration = new Point2D(0, 0);
  public var bounds = new Rectangle(0, 0, 16, 16);
  public var maxSpeed = 32 / 8 / 60;

  public function new() {
    
  }
}