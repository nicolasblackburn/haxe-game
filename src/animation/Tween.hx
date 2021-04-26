package animation;

class Tween<T> {
  private var lastValues: Map<T, Float> = [];
  private var lense: Lens<T, Float>;
  private var fromTo: TweenValues;

  public function new(lense: Lens<T, Float>, fromTo: TweenValues) {
    this.lense = lense;
    this.fromTo = fromTo;
  }

  public function apply(subject: T, time: Float) {
    var value = this.interpolate(this.fromTo, time);
    if (this.lastValues.exists(subject)) {
      this.lense.setter(subject, this.lense.getter(subject) - this.lastValues[subject] + value);
    } else {
      this.lense.setter(subject, this.lense.getter(subject) + value);
    }
    this.lastValues[subject] = value;
  } 

  public function interpolate(fromTo: TweenValues, time: Float): Float {
    switch (fromTo) {
      case TweenInt(from, to): return from + (to - from) * time;
      case TweenFloat(from, to): return from + (to - from) * time;
    }
  }
}