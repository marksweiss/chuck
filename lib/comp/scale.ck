// Based on https://chuck.stanford.edu/doc/learn/notes/scale.ck
// author: Graham Coleman
// updates by Ge Wang and Matt Wright (2021)

/*
[0,2,3,1,4,2,6,3,4,4] @=> int mel[]; //sequence data
[0,2,4,5,7,9,11,12] @=> int major[]; //major scale

for (0=>int i; ; i++) { //infinite loop
  std.mtof( 48 + scale( mel[i%mel.cap()], major )) => inst.freq; //set the note
  inst.noteOn( 0.5 ); //play a note at half volume
  300::ms => now; //compute audio for 0.3 sec
}
*/

public class Scale {
  // default to Western 12-note "piano" scale
  12 => static int NUM_NOTES_IN_OCTAVE;

  // Scale Intervals - Intervals also called Degrees
  // minor scales
  [0, 2, 3, 5, 7, 8, 10] @=> static int MINOR[]; // minor mode
  [0, 2, 3, 5, 7, 8, 11] @=> static int HARMONIC_MINOR[]; // harmonic minor
  [0, 2, 3, 5, 7, 9, 11] @=> static int ASC_MELODIC_MINOR[]; // ascending melodic minor
  [0, 1, 3, 5, 7, 8, 10] @=> static int NEAPOLITAN[]; // make 2nd degree neapolitain
  // other church modes
  [0, 2, 4, 5, 7, 9, 11] @=> static int MAJOR[]; // major scale
  [0, 2, 4, 5, 7, 8, 10] @=> static int MIXOLYDIAN[]; // church mixolydian
  [0, 2, 3, 5, 7, 9, 10] @=> static int DORIAN[]; // church dorian
  [0, 2, 4, 6, 7, 9, 11] @=> static int LYDIAN[]; // church lydian
  // other
  [0, 2, 4, 7, 9] @=> static int MAJOR_PENTATONIC[]; // major pentatonic
  [0, 2, 4, 6, 8, 10] @=> static int WHOLE_TONE[]; // the whole tone scale
  [0, 2, 3, 5, 6, 8, 9, 11] @=> static int DIMINISHED[]; // diminished scale 
 
  // Chords
  // common triads in Western music, as degrees from the chord root
  // Note these are 0-based, but in traditional music theory scales etc. are 1-based
  [0, 4, 7] @=> static int MAJOR_TRIAD[];  // So, 0th, 2nd and 4th offset are degrees 1, 4, 7 e.g. C-E-G for C MAJOR
  [0, 4, 7] @=> static int M[];  // common alias
  [0, 3, 7] @=> static int MINOR_TRIAD[];  
  [0, 3, 7] @=> static int m[];  
  [0, 3, 6] @=> static int DIMINISHED_TRIAD[];
  [0, 3, 6] @=> static int dim[];
  [0, 4, 8] @=> static int AUGMENTED_TRIAD[];
  [0, 4, 8] @=> static int aug[];
  
  // SCALE API
  /** 
   * Translates an index into a scale into the degree of that index position in the scale,
   * and then offsets that degree upward from `octave * NUM_NOTES_IN_OCTAVE` to get a final
   * integer note value. This can be used directly in MIDI or translated to a frequency with std.mtof().
   * Uses default NUM_NOTES_IN_OCTAVE to compute final note.
   *  
   * octave - octave in which to place note
   * note_poisition - the index in the scale to return the degree for
   * scale - the scale from which to select the degree for notePosition
  */
  fun static int note(int octave, int notePosition, int scale[]) {
    return note(octave, notePosition, scale, NUM_NOTES_IN_OCTAVE);
  }

  /** 
   * Translates an index into a scale into the degree of that index position in the scale,
   * and then offsets that degree upward from `octave * NUM_NOTES_IN_OCTAVE` to get a final
   * integer note value. This can be used directly in MIDI or translated to a frequency with std.mtof().
   * 
   * octave - octave in which to place note
   * note_poisition - the index in the scale to return the degree for
   * scale - the scale from which to select the degree for notePosition
   * num_notes_in_octave - instead of using class static default, override for other scales
  */ 
  fun static int note(int octave, int notePosition, int scale[], int numNotesInOctave) {
    notePosition % scale.cap() => int offset;
    return (octave * numNotesInOctave) + scale[offset];
  }

  /** 
   * Translates an index into a scale into the frequency of the note at that index, offset to octave.
   *  
   * octave - octave in which to place note
   * note_poisition - the index in the scale to return the frequency for
   * scale - the scale from which to select the frequency for notePosition
  */ 
  fun static float freq(int octave, int notePosition, int scale[]) {
    return freq(octave, notePosition, scale, NUM_NOTES_IN_OCTAVE);
  }

  /** 
   * Translates an index into a scale into the frequency of the note at that index, offset to octave.
   * 
   * octave - octave in which to place note
   * note_poisition - the index in the scale to return the frequency for
   * scale - the scale from which to select the frequency for notePosition
   * num_notes_in_octave - instead of using class static default, override for other scales
  */ 
  fun static float freq(int octave, int notePosition, int scale[], int numNotesInOctave) {
    return Std.mtof(note(octave, notePosition, scale, numNotesInOctave));
  }

  // CHORD API
  fun static int[] triad(int octave, int rootNotePosition, int scale[], int chord[]) {
    return triad(octave, rootNotePosition, Scale.NUM_NOTES_IN_OCTAVE, scale, chord);
  } 

  // Because field can't be static, functions using it can't be either, which isn't so terrible
  // because static functions are also broken and need to be called through an object ref anyway,
  // so this being non-static doesn't change client call syntax
  fun static int[] triad(int octave, int rootNotePosition, int numNotesInOctave, int scale[],
      int chord[]) {
    note(octave, rootNotePosition, scale, numNotesInOctave) => int note;
    return [note, note + chord[1], note + chord[2]];
  } 
}

fun void main() {
  4 => int octave;
  2 => int notePosition;
  // static functions are broken and can't be called except through an object reference, i.e. not static
  Scale s;
  <<< s.note(octave, notePosition, Scale.MAJOR) >>>;
  <<< s.freq(octave, notePosition, Scale.MAJOR) >>>;
  s.triad(octave, notePosition, Scale.MAJOR, Scale.MAJOR_TRIAD) @=> int chordNotes[];
  <<< "Chord:", chordNotes >>>;
  <<< "Notes:", chordNotes[0], chordNotes[1], chordNotes[2] >>>;
}

main();
