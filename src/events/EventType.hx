package events;

abstract EventType<T>(String) from String to String {
  public inline function new(type) {
    this = type;
  }
}