/* public void runCorr(CoroutineDoSomethingExample corr) { */
/*   <<< "IN RUN_THING()" >>>; */
/*   corr.run(); */
/* } */

public class Coroutine {
  0 => int registeredProcesses;
  // TODO Dynamic array
  // TODO Decouple array indexes from id values of registered objects, right now we need the objects
  //  to be id = 0, 1, 2, ...
  3 => int NUM_PROCESSES;
  Event nextEvents[NUM_PROCESSES];
  Event pauseEvents[NUM_PROCESSES];

  fun void register(int id) {
    if (this.registeredProcesses == NUM_PROCESSES) {
      <<< "Coroutine only supports orchestrating", NUM_PROCESSES, "processes" >>>;
      me.exit();
    }

    Event event;
    event @=> pauseEvents[id];
    1 +=> registeredProcesses;
    <<< "IN INIT ID", id , "ID EVENT", this.pauseEvents[id] >>>;
  }

  fun void connect(int id, int nextId) {
    // get the Event bound to nextId and set it as the nextEvent for id, by reference
    // i.e. when id calls signalNext it signals the event for nextId. This wired up yield() to
    // unpause the thread associated with nextId by calling signalNext() and pausing the thread associated
    // with id by calling pause()
    pauseEvents[nextId] @=> nextEvents[id];
    <<< "IN CONNECT ID", id, "NEXT_ID", nextId, "NEXT EVENT", this.nextEvents[id] >>>;
  }

  fun void yield(int id) {
    signalNext(id);
    pause(id); 
  }

  fun void signalNext(int id) {
    <<< "IN SIGNAL_NEXT BEFORE ", id, "NEXT EVENT", this.nextEvents[id] >>>;
    this.nextEvents[id].signal();
    <<< "IN SIGNAL_NEXT AFTER ", id, "NEXT EVENT", this.nextEvents[id] >>>;
  }

  fun void pause(int id) {
    <<< "IN PAUSE BEFORE ", id, "ID EVENT", this.pauseEvents[id] >>>;
    this.pauseEvents[id] => now;
    <<< "IN PAUSE AFTER ", id, "ID EVENT", this.pauseEvents[id] >>>;
  }
}

/* class Lock extends Event { */
/*   int id; */

/*   fun void init(int id) { */
/*     id => this.id; */
/*   } */
/* } */

// Pattern is to extend this and implement a real ruan that does the work you want
// and uses the coroutine chain to control controll flow
/* class CoroutineDoSomethingExample { */
/*   int id; */
/*   Coroutine cor; */
/*   Lock lock; */
/*   int isHead; */
  
/*   fun void init(int id, Coroutine cor, Lock lock, int isHead) { */
/*     id => this.id; */
/*     cor @=> this.cor; */
/*     lock @=> this.lock; */
/*     isHead => this.isHead; */

/*     cor.register(id); */
/*   } */

/*   fun void run() { */
/*     <<< "IN RUN ", this.id >>>; */
/*     if (! this.isHead) { */
/*       this.lock => now; */
/*     } */
/*     <<< "UNLOCKED" >>>; */
/*     while(true) { */
/*       for (0 => int i; i < 5; i++) { */
/*         <<< "id", this.id >>>; */
/*       } */
/*       // Just to make each slice take longer */
/*       for (0 => int i; i < 100000; i++) { */
/*         // no-op */
/*       } */
/*       cor.yield(this.id); */
/*     } */
/*   } */
/* } */

/* fun void main() { */
/*   Coroutine cor; */
/*   Lock lock; */

/*   CoroutineDoSomethingExample corr0; */
/*   corr0.init(0, cor, lock, true); */ 
/*   CoroutineDoSomethingExample corr1; */
/*   corr1.init(1, cor, lock, false); */
/*   CoroutineDoSomethingExample corr2; */
/*   corr2.init(2, cor, lock, false); */

/*   cor.connect(0, 1); */
/*   cor.connect(1, 2); */
/*   cor.connect(2, 0); */

/*   spork ~ runCorr(corr0); */
/*   spork ~ runCorr(corr1); */
/*   spork ~ runCorr(corr2); */
/*   while (true) {1::second => now;}  // block process exit to force child threads to run */
/* } */

/* main(); */
