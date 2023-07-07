public class Coroutine {
  0 => int registeredProcesses;
  // TODO Dynamic array
  // TODO Decouple array indexes from id values of registered objects, right now we need the objects
  //  to be id = 0, 1, 2, ...
  128 => int NUM_PROCESSES;
  Event nextEvents[NUM_PROCESSES];
  Event pauseEvents[NUM_PROCESSES];
  int ids[NUM_PROCESSES];

  // TODO instead of taking an id use registeredProcesses count as the id and return it to the caller
  fun void register(int id) {
    if (this.registeredProcesses == NUM_PROCESSES) {
      <<< "Coroutine only supports orchestrating", NUM_PROCESSES, "processes" >>>;
      me.exit();
    }

    Event event;
    event @=> pauseEvents[id];
    id => ids[registeredProcesses];
    1 +=> registeredProcesses;
  }

  fun void connect(int id, int nextId) {
    // get the Event bound to nextId and set it as the nextEvent for id, by reference
    // i.e. when id calls signalNext it signals the event for nextId. This wired up yield() to
    // unpause the thread associated with nextId by calling signalNext() and pausing the thread associated
    // with id by calling pause()
    pauseEvents[nextId] @=> nextEvents[id];
  }

  fun void yield(int id) {
    signalNext(id);
    pause(id); 
  }

  fun void signal(int id) {
    this.pauseEvents[id].signal();
  }

  fun void signalNext(int id) {
    this.nextEvents[id].signal();
  }

  fun void signalRandom() {
    Math.random2(0, registeredProcesses) => int idToSignal;
    signalNext(idToSignal);
  }

  fun void pause(int id) {
    this.pauseEvents[id] => now;
  }
}

