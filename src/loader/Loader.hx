package loader;

import js.html.svg.SVGElement;
import js.html.Console;
import js.html.Response;
import js.Browser;
import js.lib.Promise;
import events.Emitter;
import loader.events.LoaderEvent;

using Lambda;

class Loader extends Emitter {
  public var cache: Map<String, {id: String, type: String, url: String, data: Dynamic}> = [];
  public var queue: Array<{id: String, type: String, url: String}> = [];

  public function new() {
    super();
  }

  public function add(id: String, url: String, ?type: String) {
    var found = this.cache.exists(id);
    if (!found) {
      for (resource in this.queue) {
        if (resource.id == id) {
          found = true;
          break;
        }
      }
    }
    if (!found) {
      if (type == null) {
        type = url.substr(url.lastIndexOf(".") + 1);
      }
      this.queue.push({id: id, type: type, url: url});
    }
    return this;
  }

  public function load() {
    this.emit(LoaderEvent.LoadStart);
    var totalCount = this.queue.length;
    var count = 0;
    function helper(queue: Array<{id: String, type: String, url: String}>) {
      if (queue.length == 0) {
        this.emit(LoaderEvent.LoadComplete);
        return Promise.resolve([]);
      } else {
        var query = queue[0];
        return Browser.window.fetch(query.url)
        .then(response -> this.parseResponse(query, response))
        .then(data -> {
          var resource = {
            id: query.id,
            type: query.type,
            url: query.url,
            data: data
          };
          this.cache[resource.id] = resource;
          this.emit(LoaderEvent.LoadProgress, (++count) / totalCount);
          return helper(queue.slice(1)).then(rest -> [resource].concat(rest));
        }, error -> {
          throw error;
        });
      }
    };
    return helper(this.queue.splice(0, this.queue.length));
  }

  private function parseResponse(query: {id: String, type: String, url: String}, response: Response): Dynamic {
    switch (query.type) {
      case 'json': return this.parseJson(query, response);
      case 'svg': return this.parseSvg(query, response);
      case 'image' | 'jpg' | 'jpeg' | 'png' | 'bmp' | 'webp': return this.parseImage(query, response);
      case "text" | _: return this.parseText(query, response);
    }
  }

  private function parseSvg(query: {id: String, type: String, url: String}, response: Response) {
    return response.text().then(svg -> {
      var tpl = cast Browser.document.createElement('template');
      tpl.innerHTML = svg;
      return cast (tpl.content.children[0], SVGElement);
    });
  }

  private function parseImage(query: {id: String, type: String, url: String}, response: Response) {
    var img = Browser.document.createImageElement();
    img.src = query.url;
    return img;
  }

  private function parseText(query: {id: String, type: String, url: String}, response: Response) {
    return return response.text();
  }

  private function parseJson(query: {id: String, type: String, url: String}, response: Response) {
    return return response.json();
  }
}