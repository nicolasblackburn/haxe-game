package loader;

class Resource<T> {
  public var url: String;
  public var data: T;

  public function new(url: String, data: T) {
    this.url = url;
    this.data = data;
  }
}