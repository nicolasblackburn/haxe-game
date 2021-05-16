package coroutines;

enum Result {
  Terminate;
  Continue;
  Return(next: () -> Result);
  Push(next: () -> Result);
}