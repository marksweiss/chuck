public class CoroutineController {
  0 => int IS_NOT_HEAD;
  1 => int IS_HEAD;

  int id;
  string name;
  Coroutine cor;
  Lock lock;
  int isHead;

  fun void init(int id, string name, Coroutine cor, Lock lock, int isHead) {
    id => this.id;
    name => this.name;
    cor @=> this.cor;
    lock @=> this.lock;
    isHead => this.isHead;

    // All objects / threads have their own Controller but share the Coroutine, which coordinates access
    cor.register(id);
    pause();
  }

  // NOTE: Must be called only once, outside main event loop. Event loop relies on connect() order of
  // Coroutine and calls to yield() to yield critical section in order that threads are wired up in connect()
  fun void start() {
    if (isHead) {
      signalNext();
    }
  }

  // wrap Coroutine API to pass id
  fun void pause() {
    cor.pause(id);
  }  

  fun void yield() {
    cor.yield(id);
  }

  fun void signalNext() {
    cor.signalNext(id);
  }
}
