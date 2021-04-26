package animation;

class Lens<T, V> {
  public var getter: T->V;
  public var setter: (T, V)->Void;

  public function new(getter: T->V, setter: (T, V)->Void) {
    this.getter = getter;
    this.setter = setter;
  }
}