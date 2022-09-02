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

  // Pitches
  // Enums for the 12 tones in the Western scale, based on C as root
  0 => static int C;
  1 => static int C_shp;
  1 => static int D_flt;
  2 => static int D;
  3 => static int D_shp;
  3 => static int E_flt;
  4 => static int E;
  5 => static int F;
  6 => static int F_shp;
  6 => static int G_flt;
  7 => static int G;
  8 => static int G_shp;
  8 => static int A_flt;
  9 => static int A;
  10 => static int A_shp;
  10 => static int B_flt;
  11 => static int B;

  string PITCH_STR_MAP[12];
  "C" @=> PITCH_STR_MAP[0];
  "C_shp" @=> PITCH_STR_MAP[1];
  "D" @=> PITCH_STR_MAP[2];
  "E_flt" @=> PITCH_STR_MAP[3];
  "F" @=> PITCH_STR_MAP[5];
  "F_shp" @=> PITCH_STR_MAP[6];
  "G" @=> PITCH_STR_MAP[7];
  "A_flt" @=> PITCH_STR_MAP[8];
  "A" @=> PITCH_STR_MAP[9]; 
  "B_flt" @=> PITCH_STR_MAP[10]; 
  "B" @=> PITCH_STR_MAP[11]; 

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
  // Should be static but uses array, which can't be static
  fun string pitchName(int pitchPosition) {
    return pitchName(pitchPosition, NUM_NOTES_IN_OCTAVE);
  } 

  fun string pitchName(int pitchPosition, int numNotesInOctave) {
    return PITCH_STR_MAP[pitchPosition % numNotesInOctave];
  } 

  fun static int pitch(int octave, int pitchName) {
    return octave + pitchName;
  }

  fun static float freq(int octave, int pitchName) {
    return Std.mtof(octave + pitchName);
  }

  /** 
   * Translates an index into a scale into the degree of that index position in the scale,
   * and then offsets that degree upward from `octave * NUM_NOTES_IN_OCTAVE` to get a final
   * integer note value. This can be used directly in MIDI or translated to a frequency with std.mtof().
   * Uses default NUM_NOTES_IN_OCTAVE to compute final note.
   *  
   * octave - octave in which to place note
   * pitchPosition - the index in the scale to return the degree for
   * scale - the scale from which to select the degree for pitchPosition
  */
  fun static int pitch(int octave, int pitchPosition, int scale[]) {
    return pitch(octave, pitchPosition, scale, NUM_NOTES_IN_OCTAVE);
  }

  /** 
   * Translates an index into a scale into the degree of that index position in the scale,
   * and then offsets that degree upward from `octave * NUM_NOTES_IN_OCTAVE` to get a final
   * integer note value. This can be used directly in MIDI or translated to a frequency with std.mtof().
   * 
   * octave - octave in which to place note
   * pitchPosition - the index in the scale to return the degree for
   * scale - the scale from which to select the degree for pitchPosition
   * numNotesInOctave - instead of using class static default, override for other scales
  */ 
  fun static int pitch(int octave, int pitchPosition, int scale[], int numNotesInOctave) {
    pitchPosition % scale.cap() => int offset;
    return (octave * numNotesInOctave) + scale[offset];
  }

  /** 
   * Translates an index into a scale into the frequency of the note at that index, offset to octave.
   *  
   * octave - octave in which to place note
   * pitchPosition - the index in the scale to return the degree for
   * scale - the scale from which to select the frequency for pitchPosition
  */ 
  fun static float freq(int octave, int pitchPosition, int scale[]) {
    return freq(octave, pitchPosition, scale, NUM_NOTES_IN_OCTAVE);
  }

  /** 
   * Translates an index into a scale into the frequency of the note at that index, offset to octave.
   * 
   * octave - octave in which to place note
   * pitchPosition - the index in the scale to return the frequency for
   * scale - the scale from which to select the frequency for pitchPosition
   * numNotesInOctave - instead of using class static default, override for other scales
  */ 
  fun static float freq(int octave, int pitchPosition, int scale[], int numNotesInOctave) {
    return Std.mtof(pitch(octave, pitchPosition, scale, numNotesInOctave));
  }

  // TODO DOC STRINGS
  // CHORD API
  fun static int[] triad(int octave, int rootPitch, int chord[], int numNotesInOctave) {
    (octave * numNotesInOctave) + rootPitch => int pitch;
    return [pitch, pitch + chord[1], pitch + chord[2]];
  } 

  fun static int[] triad(int octave, int rootPitch, int chord[]) {
    return triad(octave, rootPitch, chord, NUM_NOTES_IN_OCTAVE);
  } 

  fun static int[] triad(int octave, int rootPitchPosition, int scale[], int chord[]) {
    return triad(octave, rootPitchPosition, Scale.NUM_NOTES_IN_OCTAVE, scale, chord);
  } 

  // Because field can't be static, functions using it can't be either, which isn't so terrible
  // because static functions are also broken and need to be called through an object ref anyway,
  // so this being non-static doesn't change client call syntax
  fun static int[] triad(int octave, int rootPitchPosition, int numNotesInOctave, int scale[],
      int chord[]) {
    pitch(octave, rootPitchPosition, scale, numNotesInOctave) => int pitch;
    return [pitch, pitch + chord[1], pitch + chord[2]];
  } 
}

fun void main() {
  4 => int octave;
  // static functions are broken and can't be called except through an object reference, i.e. not static
  Scale s;
  <<< s.pitch(octave, Scale.D, Scale.MAJOR) >>>;
  <<< s.freq(octave, Scale.D, Scale.MAJOR) >>>;
  s.triad(octave, Scale.D, Scale.MAJOR, Scale.MAJOR_TRIAD) @=> int chordPitches[];
  <<< "Chord:", chordPitches, "Length:", chordPitches.cap() >>>;
  <<< "Pitches:", chordPitches[0], chordPitches[1], chordPitches[2] >>>;
  <<< Scale.D, "==", s.pitchName(Scale.D) >>>;
}

main();
