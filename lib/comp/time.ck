// Machine.add("lib/comp/instrument.ck")

// Based on https://chuck.stanford.edu/doc/learn/notes/tg.ck
// name: tg.ck
// desc: TimeGrid class; basic timing operations abbreviated
// author: Graham Coleman 

public class Time {
  4 => static int QUARTER_NOTE; 
  64 => static int BEAT_STEP_NOTE;
  // the resolution in note duration (not actual time duration) of each beat step,
  // i.e.. each advance of time (each addition to 'now')
  BEAT_STEP_NOTE / QUARTER_NOTE => static int BEAT_STEP;

  dur stepDur;

  Event startEvent;
  Event stepEvent;

  // bpm - beats per minute, number of quarter notes per minute
  // i.e. 60 bpm means a quarter note is 1 second
  fun void init(int bpm, Event startEvent, Event stepEvent) {
    1::minute / bpm / BEAT_STEP => this.stepDur;
    startEvent @=> this.startEvent; 
    stepEvent @=> this.stepEvent;
  }

  fun void play() {
    <<< "IN TIME PLAY BEFORE START" >>>;

    this.startEvent.broadcast();

    <<< "START passed" >>>;

    while (true) {
      <<< "IN TIME EVENT LOOP BEFORE STEP BROADCAST" >>>;

      stepEvent.broadcast();

      <<< "IN TIME EVENT LOOP AFTER STEP BROADCAST BEFORE PITCHING" >>>;

      stepDur => now;

      <<< "IN TIME EVENT LOOP AFTER PITCHING STEP_DUR => NOW" >>>;
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
