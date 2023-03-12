public void runThing(Thing thing) {
  <<< "IN RUN_THING()" >>>;
  thing.run();
}


// TODO THIS ONLY WORKS FOR TWO PROCESSES BECAUSE IT RELIES ON SIGNAL
// TODO NEED A SEPARATE CO-ROUTINE CHAIN CLASS

public class Coroutine {
  0 => int registeredProcesses;
  2 => int NUM_PROCESSES;
  Event nextEvents[NUM_PROCESSES];
  Event pauseEvents[NUM_PROCESSES];

  fun void register(int id) {
    if (this.registeredProcesses == 2) {
      <<< "Coroutine only supports orchestrating two processes" >>>;
      me.exit();
    }

    Event event;
    event @=> pauseEvents[id];
    1 +=> registeredProcesses;
    <<< "IN INIT ID", id , "ID EVENT", this.pauseEvents[id] >>>;
  }

  fun void connect(int id, int nextId) {
    // get the Event bound to nextId and set it as the nextEvent for id, by reference
    // i.e. when id calls signalNext it signals the event for nextId
    pauseEvents[nextId] @=> Event nextEvent;
    nextEvent @=> nextEvents[id];
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

class Thing {
  int id;
  Coroutine cor;
  
  fun void init(int id, Coroutine cor) {
    id => this.id;
    cor @=> this.cor;
  }

  fun void run() {
    <<< "IN RUN ", this.id >>>;
    while(true) {
      for (0 => int i; i < 5; i++) {
        <<< "id", this.id >>>;
      }
      // Just to make each slice take longer
      for (0 => int i; i < 100000; i++) {
        // no-op
      }
      cor.yield(this.id);
    }
  }
}

fun void main() {
  Coroutine cor;

  Thing thing0;
  thing0.init(0, cor); 
  Thing thing1;
  thing1.init(1, cor);

  cor.register(0);
  cor.register(1);
  cor.connect(0, 1);
  cor.connect(1, 0);

  spork ~ runThing(thing0);
  spork ~ runThing(thing1);
  while (true) {1::second => now;}  // block process exit to force child threads to run
}

main();
