package events;

class Events extends Emitter {
  private var queue: Array<Dynamic> = [];

  public function push<T>(event: T) {
    this.queue.push(event);
  }

  public function processQueue() {
    for (event in this.queue.splice(0, this.queue.length)) {
      if (this.listeners.exists(event.type)) {
        this.emit(event.type, event);
      }
    }
  }
}