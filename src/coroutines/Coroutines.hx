package coroutines;

class Coroutines {
  private var stacks: Array<Array<Coroutine>> = [];

  public function new() {
    
  }

  public function add(coroutine: Coroutine) {
    this.stacks.push([coroutine]);
  }

  public function remove(coroutine: Coroutine) {
    this.stacks = this.stacks.filter(stack -> stack.length > 0 && stack[0] != coroutine);
  }

  public function update() {
    for (stack in this.stacks.slice(0, this.stacks.length)) {
      var top = stack.pop();
      var result = top.next();
      if (!result.done) {
        stack.push(top);
      }
      if (result.value != null) {
        stack.push(result.value);
      }
    }
    this.stacks = this.stacks.filter(stack -> stack.length > 0);
  }
}