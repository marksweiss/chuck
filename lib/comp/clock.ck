// Machine.add("lib/comp/instrument.ck")

// Based on https://chuck.stanford.edu/doc/learn/notes/tg.ck
// name: tg.ck
// desc: TimeGrid class; basic timing operations abbreviated
// author: Graham Coleman 

public class Clock {
  4 => static float QUARTER_NOTE; 
  64 => static float BEAT_STEP_NOTE;
  // the resolution in note duration (not actual time duration) of each beat step,
  // i.e.. each advance of time (each addition to 'now')
  BEAT_STEP_NOTE / QUARTER_NOTE => static float BEAT_STEP;
  44100.0 => static float SAMPLING_RATE_PER_SEC;
  1::minute / 60 => dur SAMPLES_PER_SEC;

  dur stepDur;

  Event startEvent;
  Event stepEvent;

  // bpm - beats per minute, number of quarter notes per minute
  // i.e. 60 bpm means a quarter note is 1 second
  fun void init(float bpm, Event startEvent, Event stepEvent) {
    <<< "BEAT_STEP", BEAT_STEP >>>;
    <<< "SAMPLES_PER_SEC", SAMPLES_PER_SEC >>>;

    bpm / 60.0 => float beatsPerSec;

    <<< "bpm", bpm, "beatsPerSec", beatsPerSec >>>;

    SAMPLES_PER_SEC / beatsPerSec =>  dur samplesPerBeat;

    <<< "SAMPLES PER BEAT", samplesPerBeat >>>;

    samplesPerBeat / BEAT_STEP => stepDur;

    <<< "stepDur", stepDur >>>;

    startEvent @=> this.startEvent; 
    stepEvent @=> this.stepEvent;
  }

  fun void play() {
    /* <<< "IN CLOCK PLAY BEFORE START, shred id:", me.id() >>>; */

    sync();

    this.startEvent.broadcast();
    me.yield();

    /* <<< "IN CLOCK START passed" >>>; */

    while (true) {
      stepEvent.broadcast();
      me.yield();

      /* <<< "IN CLOCK EVENT LOOP AFTER STEP BROADCAST BEFORE PITCHING", now, stepDur >>>; */

      stepDur => now;

      /* <<< "IN CLOCK EVENT LOOP AFTER PITCHING STEP_DUR => NOW", now >>>; */
    }
  }

  fun dur getStepDur() {
    return this.stepDur;
  }

  // TODO PRIVATE? TODO DO WE NEED THIS?
  /**
   * Sync to a beat duration
   */
  fun static void sync(dur stepDur) {
    stepDur - (now % stepDur) => now;
  }

  // TODO PRIVATE?
  /**
   * Sync to the configured beat duration
   */
  fun void sync() {
    sync(this.stepDur);
  }

  // TODO DOES IT MAKE SENSE TO MANAGE GROUPS OF NOTES HERE?
  /* dur measureDur; */
  /* int numBeats; */
  /* int numMeasures; */

  // TODO ARE WE USING THIS?
  /* fun void init(int bpm, int numBeats, int numMeasures) { */
  /*   // 1 minute / */
  /*   // beats per minute / */
  /*   // ratio of num beats per measure to quarter note (4 per measure) */
  /*   1::minute / bpm / (numBeats / QUARTER_NOTE_NUM_BEATS) => this.beatDur; */
  /*   numBeats => this.numBeats; */
  /*   numMeasures => this.numMeasures; */
  /*   this.beatDur * this.numBeats => measureDur; */
  /* } */
}
