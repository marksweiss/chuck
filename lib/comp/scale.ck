// Based on https://chuck.stanford.edu/doc/learn/notes/scale.ck
// author: Graham Coleman
// updates by Ge Wang and Matt Wright (2021)

/*
[0,2,3,1,4,2,6,3,4,4] @=> int mel[]; //sequence data
[0,2,4,5,7,9,11,12] @=> int major[]; //major scale

for (0=>int i; ; i++) { //infinite loop
  std.mtof( 48 + scale( mel[i%mel.size()], major )) => inst.freq; //set the note
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
  1 => static int Cs;
  1 => static int D_flt;
  1 => static int Df;
  2 => static int D;
  3 => static int D_shp;
  3 => static int Ds;
  3 => static int E_flt;
  3 => static int Ef;
  4 => static int E;
  5 => static int F;
  6 => static int F_shp;
  6 => static int Fs;
  6 => static int G_flt;
  6 => static int Gf;
  7 => static int G;
  8 => static int G_shp;
  8 => static int Gs;
  8 => static int A_flt;
  8 => static int Af;
  9 => static int A;
  10 => static int A_shp;
  10 => static int As;
  10 => static int B_flt;
  10 => static int Bf;
  11 => static int B;

  12 => static int C0;
  13 => static int Cs0;
  13 => static int Df0;
  14 => static int D0;
  15 => static int Ds0;
  15 => static int Ef0;
  16 => static int E0;
  17 => static int F0;
  18 => static int Fs0;
  18 => static int Gf0;
  19 => static int G0;
  20 => static int Gs0;
  20 => static int Af0;
  21 => static int A0;
  22 => static int As0;
  22 => static int Bf0;
  23 => static int B0;

  24 => static int C1;
  25 => static int Cs1;
  25 => static int Df1;
  26 => static int D1;
  27 => static int Ds1;
  27 => static int Ef1;
  28 => static int E1;
  29 => static int F1;
  30 => static int Fs1;
  30 => static int Gf1;
  31 => static int G1;
  32 => static int Gs1;
  32 => static int Af1;
  33 => static int A1;
  34 => static int As1;
  34 => static int Bf1;
  35 => static int B1;

  36 => static int C2;
  37 => static int Cs2;
  37 => static int Df2;
  38 => static int D2;
  39 => static int Ds2;
  39 => static int Ef2;
  40 => static int E2;
  41 => static int F2;
  42 => static int Fs2;
  42 => static int Gf2;
  43 => static int G2;
  44 => static int Gs2;
  44 => static int Af2;
  45 => static int A2;
  46 => static int As2;
  46 => static int Bf2;
  47 => static int B2;

  48 => static int C3;
  49 => static int Cs3;
  49 => static int Df3;
  50 => static int D3;
  51 => static int Ds3;
  51 => static int Ef3;
  52 => static int E3;
  53 => static int F3;
  54 => static int Fs3;
  54 => static int Gf3;
  55 => static int G3;
  56 => static int Gs3;
  56 => static int Af3;
  57 => static int A3;
  58 => static int As3;
  58 => static int Bf3;
  59 => static int B3;

  60 => static int C4;
  61 => static int Cs4;
  61 => static int Df4;
  62 => static int D4;
  63 => static int Ds4;
  63 => static int Ef4;
  64 => static int E4;
  65 => static int F4;
  66 => static int Fs4;
  66 => static int Gf4;
  67 => static int G4;
  68 => static int Gs4;
  68 => static int Af4;
  69 => static int A4;
  70 => static int As4;
  70 => static int Bf4;
  71 => static int B4;

  72 => static int C5;
  73 => static int Cs5;
  73 => static int Df5;
  74 => static int D5;
  75 => static int Ds5;
  75 => static int Ef5;
  76 => static int E5;
  77 => static int F5;
  78 => static int Fs5;
  78 => static int Gf5;
  79 => static int G5;
  80 => static int Gs5;
  80 => static int Af5;
  81 => static int A5;
  82 => static int As5;
  82 => static int Bf5;
  83 => static int B5;

  84 => static int C6;
  85 => static int Cs6;
  85 => static int Df6;
  86 => static int D6;
  87 => static int Ds6;
  87 => static int Ef6;
  88 => static int E6;
  89 => static int F6;
  90 => static int Fs6;
  90 => static int Gf6;
  91 => static int G6;
  92 => static int Gs6;
  92 => static int Af6;
  93 => static int A6;
  94 => static int As6;
  94 => static int Bf6;
  95 => static int B6;

  96 => static int C7;
  97 => static int Cs7;
  97 => static int Df7;
  98 => static int D7;
  99 => static int Ds7;
  99 => static int Ef7;
  100 => static int E7;
  101 => static int F7;
  102 => static int Fs7;
  102 => static int Gf7;
  103 => static int G7;
  104 => static int Gs7;
  104 => static int Af7;
  105 => static int A7;
  106 => static int As7;
  106 => static int Bf7;
  107 => static int B7;

  108 => static int C8;
  109 => static int Cs8;
  109 => static int Df8;
  110 => static int D8;
  111 => static int Ds8;
  111 => static int Ef8;
  112 => static int E8;
  113 => static int F8;
  114 => static int Fs8;
  114 => static int Gf8;
  115 => static int G8;
  116 => static int Gs8;
  116 => static int Af8;
  117 => static int A8;
  118 => static int As8;
  118 => static int Bf8;
  119 => static int B8;

  120 => static int C9;
  121 => static int Cs9;
  121 => static int Df9;
  122 => static int D9;
  123 => static int Ds9;
  123 => static int Ef9;
  124 => static int E9;
  125 => static int F9;
  126 => static int Fs9;
  126 => static int Gf9;
  127 => static int G9;
  128 => static int Gs9;
  128 => static int Af9;
  129 => static int A9;
  130 => static int As9;
  130 => static int Bf9;
  131 => static int B9;

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

  // Should be static but uses array, which can't be static
  fun string pitchName(int pitchPosition, int numNotesInOctave) {
    return PITCH_STR_MAP[pitchPosition % numNotesInOctave];
  } 

  // TODO TESTS FOR THESE FOUR METHODS AND THE REST OF THIS CLASS
  fun static int pitch(int octave, int pitchName) {
    return pitch(octave, pitchName, NUM_NOTES_IN_OCTAVE);
  }

  fun static int pitch(int octave, int pitchName, int numNotesInOctave) {
    return (octave * numNotesInOctave) + pitchName;
  }

  fun static float freq(int octave, int pitchName) {
    return freq(octave, pitchName, NUM_NOTES_IN_OCTAVE);
  }

  fun static float freq(int octave, int pitchName, int numNotesInOctave) {
    return Std.mtof(pitch(octave, pitchName, numNotesInOctave));
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
    pitchPosition % scale.size() => int offset;
    return (octave * numNotesInOctave) + scale[offset];
  }

  /** 
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
    pitchPosition % scale.size() => int offset;
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
