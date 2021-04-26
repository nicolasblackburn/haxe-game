package loader.events;

import events.EventType;

class LoaderEvent {
  public static inline var LoadStart = new EventType<Void>("loadstart");
  public static inline var LoadProgress = new EventType<Float>("loadprogress");
  public static inline var LoadComplete = new EventType<Void>("loadcomplete");
}