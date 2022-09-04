// Machine.add("lib/comp/instrument.ck")

// Based on https://chuck.stanford.edu/doc/learn/notes/tg.ck
// name: tg.ck
// desc: TimeGrid class; basic timing operations abbreviated
// author: Graham Coleman 

// TODO SOME MODEL OF HOLDING REFERENCES TO EVENTS AND RECIEVING EVENT SIGNALS
// AND ADVANCING TIME FOR SIGNALS

public class Time {
  4 => static int QUARTER_NOTE; 
  64 => static int BEAT_STEP_NOTE;
  // the resolution in note duration (not actual time duration) of each beat step,
  // i.e.. each advance of time (each addition to 'now')
  BEAT_STEP_NOTE / QUARTER_NOTE => static int BEAT_STEP;
  // bpm - beats per minute, number of quarter notes per minute
  // i.e. 60 bpm means a quarter note is 1 second
  int bpm;
  // the duration of eatch beat step in actual time, so this is:
  // "how long is a 64th note in millisedons for the desired bpm?"
  dur beatStepDur;

  Event START;
  Event STEP;

  // TODO DOES IT MAKE SENSE TO MANAGE GROUPS OF NOTES HERE?
  /* dur measureDur; */
  /* int numBeats; */
  /* int numMeasures; */
  // /TODO DOES IT MAKE SENSE TO MANAGE GROUPS OF NOTES HERE?

  fun void init(int bpm) {
    1::minute / bpm / BEAT_STEP => this.beatStepDur;
    sync();
  }

  fun static void play() {
    START.broadcast();
    while (true) {
      STEP.broadcast();
      this.beatStepDur => now;
    }
  }

  // TODO DOES IT MAKE SENSE TO MANAGE GROUPS OF NOTES HERE?
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

  // TODO PRIVATE? TODO DO WE NEED THIS?
  /**
   * Sync to a beat duration
   */
  fun void sync(dur beatStepDur) {
    beatStepDur - (now % beatStepDur) => now;
  }

  // TODO PRIVATE?
  /**
   * Sync to the configured beat duration
   */
  fun void sync() {
    sync(this.beatStepDur);
  }

}
