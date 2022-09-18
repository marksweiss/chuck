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
    notes_ @=> notes;
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

/* fun void main() { */
/*   Scale S; */
/*   // manually build major triad */
/*   [S.pitch(4, S.D), S.pitch(4, 2, S.MAJOR), S.pitch(4, 4, S.MAJOR)] @=> int pitches[]; */
/*   0.75 => float gain; */
/*   2::second @=> dur duration; */
/*   // manually build Chord of Notes from pitches */
/*   Chord C; */
/*   <<< C.make(pitches) >>>; */
/*   <<< C.make(pitches, gain, duration) >>>; */

/*   // Use Scale module Chord API */
/*   C.make(S.triad(4, S.D, S.MAJOR_TRIAD)) @=> Chord DMaj; */
/*   <<< "DMajor", DMaj >>>; */
/*   <<< "DMajor notes", DMaj.notes >>>; */
/*   <<< "DMajor notes pitches", DMaj.notes[0].pitch, DMaj.notes[1].pitch, DMaj.notes[2].pitch >>>; */
/* } */

/* main(); */
