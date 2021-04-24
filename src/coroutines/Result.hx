package coroutines;

class Result {
  public var value: Coroutine;
  public var done: Bool;

  public function new(done: Bool, ?value: Coroutine) {
    this.value = value;
    this.done = done;
  }
}