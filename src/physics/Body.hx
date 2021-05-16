package physics;

import geom.Rectangle;
import geom.Point2D;

interface Body {
  public var kind: String;
  public var position: Point2D;
  public var velocity: Point2D;
  public var acceleration: Point2D;
  public var bounds: Rectangle;
  public var maxSpeed: Float;
}