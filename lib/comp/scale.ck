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
}

fun void main() {
  4 => int octave;
  2 => int notePosition;
  // static functions are broken and can't be called except through an object reference, i.e. not static
  Scale s;
  <<< s.note(octave, notePosition, Scale.MAJOR) >>>;
  <<< s.freq(octave, notePosition, Scale.MAJOR) >>>;
}

main();
