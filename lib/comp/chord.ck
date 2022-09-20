// Depends on
/* Machine.add("lib/comp/scale.ck"); */
/* Machine.add("lib/comp/note.ck"); */

public class Chord {
  0.5 => static float DEFAULT_GAIN; 
  1.0::second => static dur DEFAULT_DUR;
  5 => static int MAX_NUM_CHORD_NOTES;
 
  int cap;
  Note notes[MAX_NUM_CHORD_NOTES];

  fun void init(Note notes_[]) {
    notes_.cap() => cap;
    notes_ @=> this.notes;
  }

  fun static Chord make(Note notes_[]) {
    Chord c;
    c.init(notes_);
    return c;
  }

  fun static Chord make(int pitches[], float gain, dur duration) {
    Chord c;
    Note n;
    Note chordNotes[pitches.cap()];
    for (0 => int i; i < pitches.cap(); i++) {
      n.make(pitches[i], gain, duration) @=> Note chordNote;
      chordNote @=> chordNotes[i]; 
    }
    return make(chordNotes);
  }

  fun static Chord make(int pitches[]) {
    return make(pitches, DEFAULT_GAIN, DEFAULT_DUR);
  }

  fun static Chord make(int rootPitch, int chordPitches[], float gain, dur duration) {
    chordPitchesForRoot(rootPitch, chordPitches) @=> int pitches[];
    return make(pitches, gain, duration);
  }

  fun static Chord make(int rootPitch, int chordPitches[]) {
    chordPitchesForRoot(rootPitch, chordPitches) @=> int pitches[];
    return make(pitches); 
  }

  fun static Chord rest(dur duration) {
    int pitches[1];
    1 => pitches[0];
    return make(pitches, 0.0, duration);
  }

  fun /*private*/ static int[] chordPitchesForRoot(int rootPitch, int chordPitches[]) {
    int pitches[chordPitches.cap()];
    for (0 => int i; i < pitches.cap(); i++) {
      rootPitch + chordPitches[i] @=> pitches[i];
    }
    return pitches;
  }
}
