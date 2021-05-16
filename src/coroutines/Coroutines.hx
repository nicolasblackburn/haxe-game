package coroutines;

class Coroutines {
  private var stacks: Array<Array<Coroutine>> = [];

  public function new() { }

  public function add(coroutine: Coroutine) {
    this.stacks.push([coroutine]);
  }

  public function remove(coroutine: Coroutine) {
    this.stacks = this.stacks.filter(stack -> stack.length > 0 && stack[0] != coroutine);
  }

  public function update() {
    for (stack in this.stacks.slice(0, this.stacks.length)) {
      var top = stack.pop();
      switch (top()) {
        case Terminate: 
        case Continue: 
          stack.push(top);
        case Return(next): 
          stack.push(next);
        case Push(next): 
          stack.push(top);
          stack.push(next);
      }
    }
    this.stacks = this.stacks.filter(stack -> stack.length > 0);
  }
}