package events;

class Emitter {
  private var listeners: Map<String, Array<Dynamic->Void>> = [];

  public function new() {}

  public function on<T>(type: EventType<T>, listener: T->Void) {
    if (!this.listeners.exists(type)) {
      this.listeners[type] = [];
    }
    this.listeners[type].push(listener);
  }

  public function off<T>(type: EventType<T>, listener: T->Void) {
    if (this.listeners.exists(type)) {
      var index = this.listeners[type].lastIndexOf(listener);
      if (index >= 0) {
        return this.listeners[type].splice(index, 1);
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  public function emit<T>(type: EventType<T>, event: T) {
    if (this.listeners.exists(type)) {
      for (listener in this.listeners[type]) {
        listener(event);
      }
    }
  }
}