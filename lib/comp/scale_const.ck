// Machine.add("lib/comp/chord.ck")
// Machine.add("lib/comp/scale.ck")
// Machine.add("lib/comp/clock.ck")

public class ScaleConst {
  1.0 => float DEFAULT_GAIN;

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

  Chord c;
  Scale s;
  Clock k;

  c.make(s.triad(0, C, M), DEFAULT_GAIN, k.QRTR) @=> Chord CM;
  c.make(s.triad(0, Cs, M), DEFAULT_GAIN, k.QRTR) @=> Chord CsM;
  c.make(s.triad(0, D, M), DEFAULT_GAIN, k.QRTR) @=> Chord DM;
  c.make(s.triad(0, Ds, M), DEFAULT_GAIN, k.QRTR) @=> Chord DsM;
  c.make(s.triad(0, Ef, M), DEFAULT_GAIN, k.QRTR) @=> Chord EfM;
  c.make(s.triad(0, E, M), DEFAULT_GAIN, k.QRTR) @=> Chord EM;
  c.make(s.triad(0, F, M), DEFAULT_GAIN, k.QRTR) @=> Chord _FM;
  c.make(s.triad(0, Fs, M), DEFAULT_GAIN, k.QRTR) @=> Chord FsM;
  c.make(s.triad(0, Gf, M), DEFAULT_GAIN, k.QRTR) @=> Chord GfM;
  c.make(s.triad(0, G, M), DEFAULT_GAIN, k.QRTR) @=> Chord GM;
  c.make(s.triad(0, Gs, M), DEFAULT_GAIN, k.QRTR) @=> Chord GsM;
  c.make(s.triad(0, Af, M), DEFAULT_GAIN, k.QRTR) @=> Chord AfM;
  c.make(s.triad(0, A, M), DEFAULT_GAIN, k.QRTR) @=> Chord AM;
  c.make(s.triad(0, As, M), DEFAULT_GAIN, k.QRTR) @=> Chord AsM;
  c.make(s.triad(0, Bf, M), DEFAULT_GAIN, k.QRTR) @=> Chord BfM;
  c.make(s.triad(0, B, M), DEFAULT_GAIN, k.QRTR) @=> Chord BM;

  c.make(s.triad(1, C, M), DEFAULT_GAIN, k.QRTR) @=> Chord CM0;
  c.make(s.triad(1, Cs, M), DEFAULT_GAIN, k.QRTR) @=> Chord CsM0;
  c.make(s.triad(1, D, M), DEFAULT_GAIN, k.QRTR) @=> Chord DM0;
  c.make(s.triad(1, Ds, M), DEFAULT_GAIN, k.QRTR) @=> Chord DsM0;
  c.make(s.triad(1, Ef, M), DEFAULT_GAIN, k.QRTR) @=> Chord EfM0;
  c.make(s.triad(1, E, M), DEFAULT_GAIN, k.QRTR) @=> Chord EM0;
  c.make(s.triad(1, F, M), DEFAULT_GAIN, k.QRTR) @=> Chord _FM0;
  c.make(s.triad(1, Fs, M), DEFAULT_GAIN, k.QRTR) @=> Chord FsM0;
  c.make(s.triad(1, Gf, M), DEFAULT_GAIN, k.QRTR) @=> Chord GfM0;
  c.make(s.triad(1, G, M), DEFAULT_GAIN, k.QRTR) @=> Chord GM0;
  c.make(s.triad(1, Gs, M), DEFAULT_GAIN, k.QRTR) @=> Chord GsM0;
  c.make(s.triad(1, Af, M), DEFAULT_GAIN, k.QRTR) @=> Chord AfM0;
  c.make(s.triad(1, A, M), DEFAULT_GAIN, k.QRTR) @=> Chord AM0;
  c.make(s.triad(1, As, M), DEFAULT_GAIN, k.QRTR) @=> Chord AsM0;
  c.make(s.triad(1, Bf, M), DEFAULT_GAIN, k.QRTR) @=> Chord BfM0;
  c.make(s.triad(1, B, M), DEFAULT_GAIN, k.QRTR) @=> Chord BM0;

  c.make(s.triad(2, C, M), DEFAULT_GAIN, k.QRTR) @=> Chord CM1;
  c.make(s.triad(2, Cs, M), DEFAULT_GAIN, k.QRTR) @=> Chord CsM1;
  c.make(s.triad(2, D, M), DEFAULT_GAIN, k.QRTR) @=> Chord DM1;
  c.make(s.triad(2, Ds, M), DEFAULT_GAIN, k.QRTR) @=> Chord DsM1;
  c.make(s.triad(2, Ef, M), DEFAULT_GAIN, k.QRTR) @=> Chord EfM1;
  c.make(s.triad(2, E, M), DEFAULT_GAIN, k.QRTR) @=> Chord EM1;
  c.make(s.triad(2, F, M), DEFAULT_GAIN, k.QRTR) @=> Chord _FM1;
  c.make(s.triad(2, Fs, M), DEFAULT_GAIN, k.QRTR) @=> Chord FsM1;
  c.make(s.triad(2, Gf, M), DEFAULT_GAIN, k.QRTR) @=> Chord GfM1;
  c.make(s.triad(2, G, M), DEFAULT_GAIN, k.QRTR) @=> Chord GM1;
  c.make(s.triad(2, Gs, M), DEFAULT_GAIN, k.QRTR) @=> Chord GsM1;
  c.make(s.triad(2, Af, M), DEFAULT_GAIN, k.QRTR) @=> Chord AfM1;
  c.make(s.triad(2, A, M), DEFAULT_GAIN, k.QRTR) @=> Chord AM1;
  c.make(s.triad(2, As, M), DEFAULT_GAIN, k.QRTR) @=> Chord AsM1;
  c.make(s.triad(2, Bf, M), DEFAULT_GAIN, k.QRTR) @=> Chord BfM1;
  c.make(s.triad(2, B, M), DEFAULT_GAIN, k.QRTR) @=> Chord BM1;

  c.make(s.triad(3, C, M), DEFAULT_GAIN, k.QRTR) @=> Chord CM2;
  c.make(s.triad(3, Cs, M), DEFAULT_GAIN, k.QRTR) @=> Chord CsM2;
  c.make(s.triad(3, D, M), DEFAULT_GAIN, k.QRTR) @=> Chord DM2;
  c.make(s.triad(3, Ds, M), DEFAULT_GAIN, k.QRTR) @=> Chord DsM2;
  c.make(s.triad(3, Ef, M), DEFAULT_GAIN, k.QRTR) @=> Chord EfM2;
  c.make(s.triad(3, E, M), DEFAULT_GAIN, k.QRTR) @=> Chord EM2;
  c.make(s.triad(3, F, M), DEFAULT_GAIN, k.QRTR) @=> Chord _FM2;
  c.make(s.triad(3, Fs, M), DEFAULT_GAIN, k.QRTR) @=> Chord FsM2;
  c.make(s.triad(3, Gf, M), DEFAULT_GAIN, k.QRTR) @=> Chord GfM2;
  c.make(s.triad(3, G, M), DEFAULT_GAIN, k.QRTR) @=> Chord GM2;
  c.make(s.triad(3, Gs, M), DEFAULT_GAIN, k.QRTR) @=> Chord GsM2;
  c.make(s.triad(3, Af, M), DEFAULT_GAIN, k.QRTR) @=> Chord AfM2;
  c.make(s.triad(3, A, M), DEFAULT_GAIN, k.QRTR) @=> Chord AM2;
  c.make(s.triad(3, As, M), DEFAULT_GAIN, k.QRTR) @=> Chord AsM2;
  c.make(s.triad(3, Bf, M), DEFAULT_GAIN, k.QRTR) @=> Chord BfM2;
  c.make(s.triad(3, B, M), DEFAULT_GAIN, k.QRTR) @=> Chord BM2;

  c.make(s.triad(4, C, M), DEFAULT_GAIN, k.QRTR) @=> Chord CM3;
  c.make(s.triad(4, Cs, M), DEFAULT_GAIN, k.QRTR) @=> Chord CsM3;
  c.make(s.triad(4, D, M), DEFAULT_GAIN, k.QRTR) @=> Chord DM3;
  c.make(s.triad(4, Ds, M), DEFAULT_GAIN, k.QRTR) @=> Chord DsM3;
  c.make(s.triad(4, Ef, M), DEFAULT_GAIN, k.QRTR) @=> Chord EfM3;
  c.make(s.triad(4, E, M), DEFAULT_GAIN, k.QRTR) @=> Chord EM3;
  c.make(s.triad(4, F, M), DEFAULT_GAIN, k.QRTR) @=> Chord _FM3;
  c.make(s.triad(4, Fs, M), DEFAULT_GAIN, k.QRTR) @=> Chord FsM3;
  c.make(s.triad(4, Gf, M), DEFAULT_GAIN, k.QRTR) @=> Chord GfM3;
  c.make(s.triad(4, G, M), DEFAULT_GAIN, k.QRTR) @=> Chord GM3;
  c.make(s.triad(4, Gs, M), DEFAULT_GAIN, k.QRTR) @=> Chord GsM3;
  c.make(s.triad(4, Af, M), DEFAULT_GAIN, k.QRTR) @=> Chord AfM3;
  c.make(s.triad(4, A, M), DEFAULT_GAIN, k.QRTR) @=> Chord AM3;
  c.make(s.triad(4, As, M), DEFAULT_GAIN, k.QRTR) @=> Chord AsM3;
  c.make(s.triad(4, Bf, M), DEFAULT_GAIN, k.QRTR) @=> Chord BfM3;
  c.make(s.triad(4, B, M), DEFAULT_GAIN, k.QRTR) @=> Chord BM3;

  c.make(s.triad(5, C, M), DEFAULT_GAIN, k.QRTR) @=> Chord CM4;
  c.make(s.triad(5, Cs, M), DEFAULT_GAIN, k.QRTR) @=> Chord CsM4;
  c.make(s.triad(5, D, M), DEFAULT_GAIN, k.QRTR) @=> Chord DM4;
  c.make(s.triad(5, Ds, M), DEFAULT_GAIN, k.QRTR) @=> Chord DsM4;
  c.make(s.triad(5, Ef, M), DEFAULT_GAIN, k.QRTR) @=> Chord EfM4;
  c.make(s.triad(5, E, M), DEFAULT_GAIN, k.QRTR) @=> Chord EM4;
  c.make(s.triad(5, F, M), DEFAULT_GAIN, k.QRTR) @=> Chord _FM4;
  c.make(s.triad(5, Fs, M), DEFAULT_GAIN, k.QRTR) @=> Chord FsM4;
  c.make(s.triad(5, Gf, M), DEFAULT_GAIN, k.QRTR) @=> Chord GfM4;
  c.make(s.triad(5, G, M), DEFAULT_GAIN, k.QRTR) @=> Chord GM4;
  c.make(s.triad(5, Gs, M), DEFAULT_GAIN, k.QRTR) @=> Chord GsM4;
  c.make(s.triad(5, Af, M), DEFAULT_GAIN, k.QRTR) @=> Chord AfM4;
  c.make(s.triad(5, A, M), DEFAULT_GAIN, k.QRTR) @=> Chord AM4;
  c.make(s.triad(5, As, M), DEFAULT_GAIN, k.QRTR) @=> Chord AsM4;
  c.make(s.triad(5, Bf, M), DEFAULT_GAIN, k.QRTR) @=> Chord BfM4;
  c.make(s.triad(5, B, M), DEFAULT_GAIN, k.QRTR) @=> Chord BM4;

  c.make(s.triad(6, C, M), DEFAULT_GAIN, k.QRTR) @=> Chord CM5;
  c.make(s.triad(6, Cs, M), DEFAULT_GAIN, k.QRTR) @=> Chord CsM5;
  c.make(s.triad(6, D, M), DEFAULT_GAIN, k.QRTR) @=> Chord DM5;
  c.make(s.triad(6, Ds, M), DEFAULT_GAIN, k.QRTR) @=> Chord DsM5;
  c.make(s.triad(6, Ef, M), DEFAULT_GAIN, k.QRTR) @=> Chord EfM5;
  c.make(s.triad(6, E, M), DEFAULT_GAIN, k.QRTR) @=> Chord EM5;
  c.make(s.triad(6, F, M), DEFAULT_GAIN, k.QRTR) @=> Chord _FM5;
  c.make(s.triad(6, Fs, M), DEFAULT_GAIN, k.QRTR) @=> Chord FsM5;
  c.make(s.triad(6, Gf, M), DEFAULT_GAIN, k.QRTR) @=> Chord GfM5;
  c.make(s.triad(6, G, M), DEFAULT_GAIN, k.QRTR) @=> Chord GM5;
  c.make(s.triad(6, Gs, M), DEFAULT_GAIN, k.QRTR) @=> Chord GsM5;
  c.make(s.triad(6, Af, M), DEFAULT_GAIN, k.QRTR) @=> Chord AfM5;
  c.make(s.triad(6, A, M), DEFAULT_GAIN, k.QRTR) @=> Chord AM5;
  c.make(s.triad(6, As, M), DEFAULT_GAIN, k.QRTR) @=> Chord AsM5;
  c.make(s.triad(6, Bf, M), DEFAULT_GAIN, k.QRTR) @=> Chord BfM5;
  c.make(s.triad(6, B, M), DEFAULT_GAIN, k.QRTR) @=> Chord BM5;

  c.make(s.triad(7, C, M), DEFAULT_GAIN, k.QRTR) @=> Chord CM6;
  c.make(s.triad(7, Cs, M), DEFAULT_GAIN, k.QRTR) @=> Chord CsM6;
  c.make(s.triad(7, D, M), DEFAULT_GAIN, k.QRTR) @=> Chord DM6;
  c.make(s.triad(7, Ds, M), DEFAULT_GAIN, k.QRTR) @=> Chord DsM6;
  c.make(s.triad(7, Ef, M), DEFAULT_GAIN, k.QRTR) @=> Chord EfM6;
  c.make(s.triad(7, E, M), DEFAULT_GAIN, k.QRTR) @=> Chord EM6;
  c.make(s.triad(7, F, M), DEFAULT_GAIN, k.QRTR) @=> Chord _FM6;
  c.make(s.triad(7, Fs, M), DEFAULT_GAIN, k.QRTR) @=> Chord FsM6;
  c.make(s.triad(7, Gf, M), DEFAULT_GAIN, k.QRTR) @=> Chord GfM6;
  c.make(s.triad(7, G, M), DEFAULT_GAIN, k.QRTR) @=> Chord GM6;
  c.make(s.triad(7, Gs, M), DEFAULT_GAIN, k.QRTR) @=> Chord GsM6;
  c.make(s.triad(7, Af, M), DEFAULT_GAIN, k.QRTR) @=> Chord AfM6;
  c.make(s.triad(7, A, M), DEFAULT_GAIN, k.QRTR) @=> Chord AM6;
  c.make(s.triad(7, As, M), DEFAULT_GAIN, k.QRTR) @=> Chord AsM6;
  c.make(s.triad(7, Bf, M), DEFAULT_GAIN, k.QRTR) @=> Chord BfM6;
  c.make(s.triad(7, B, M), DEFAULT_GAIN, k.QRTR) @=> Chord BM6;

  c.make(s.triad(8, C, M), DEFAULT_GAIN, k.QRTR) @=> Chord CM7;
  c.make(s.triad(8, Cs, M), DEFAULT_GAIN, k.QRTR) @=> Chord CsM7;
  c.make(s.triad(8, D, M), DEFAULT_GAIN, k.QRTR) @=> Chord DM7;
  c.make(s.triad(8, Ds, M), DEFAULT_GAIN, k.QRTR) @=> Chord DsM7;
  c.make(s.triad(8, Ef, M), DEFAULT_GAIN, k.QRTR) @=> Chord EfM7;
  c.make(s.triad(8, E, M), DEFAULT_GAIN, k.QRTR) @=> Chord EM7;
  c.make(s.triad(8, F, M), DEFAULT_GAIN, k.QRTR) @=> Chord _FM7;
  c.make(s.triad(8, Fs, M), DEFAULT_GAIN, k.QRTR) @=> Chord FsM7;
  c.make(s.triad(8, Gf, M), DEFAULT_GAIN, k.QRTR) @=> Chord GfM7;
  c.make(s.triad(8, G, M), DEFAULT_GAIN, k.QRTR) @=> Chord GM7;
  c.make(s.triad(8, Gs, M), DEFAULT_GAIN, k.QRTR) @=> Chord GsM7;
  c.make(s.triad(8, Af, M), DEFAULT_GAIN, k.QRTR) @=> Chord AfM7;
  c.make(s.triad(8, A, M), DEFAULT_GAIN, k.QRTR) @=> Chord AM7;
  c.make(s.triad(8, As, M), DEFAULT_GAIN, k.QRTR) @=> Chord AsM7;
  c.make(s.triad(8, Bf, M), DEFAULT_GAIN, k.QRTR) @=> Chord BfM7;
  c.make(s.triad(8, B, M), DEFAULT_GAIN, k.QRTR) @=> Chord BM7;

  c.make(s.triad(9, C, M), DEFAULT_GAIN, k.QRTR) @=> Chord CM8;
  c.make(s.triad(9, Cs, M), DEFAULT_GAIN, k.QRTR) @=> Chord CsM8;
  c.make(s.triad(9, D, M), DEFAULT_GAIN, k.QRTR) @=> Chord DM8;
  c.make(s.triad(9, Ds, M), DEFAULT_GAIN, k.QRTR) @=> Chord DsM8;
  c.make(s.triad(9, Ef, M), DEFAULT_GAIN, k.QRTR) @=> Chord EfM8;
  c.make(s.triad(9, E, M), DEFAULT_GAIN, k.QRTR) @=> Chord EM8;
  c.make(s.triad(9, F, M), DEFAULT_GAIN, k.QRTR) @=> Chord _FM8;
  c.make(s.triad(9, Fs, M), DEFAULT_GAIN, k.QRTR) @=> Chord FsM8;
  c.make(s.triad(9, Gf, M), DEFAULT_GAIN, k.QRTR) @=> Chord GfM8;
  c.make(s.triad(9, G, M), DEFAULT_GAIN, k.QRTR) @=> Chord GM8;
  c.make(s.triad(9, Gs, M), DEFAULT_GAIN, k.QRTR) @=> Chord GsM8;
  c.make(s.triad(9, Af, M), DEFAULT_GAIN, k.QRTR) @=> Chord AfM8;
  c.make(s.triad(9, A, M), DEFAULT_GAIN, k.QRTR) @=> Chord AM8;
  c.make(s.triad(9, As, M), DEFAULT_GAIN, k.QRTR) @=> Chord AsM8;
  c.make(s.triad(9, Bf, M), DEFAULT_GAIN, k.QRTR) @=> Chord BfM8;
  c.make(s.triad(9, B, M), DEFAULT_GAIN, k.QRTR) @=> Chord BM8;

  c.make(s.triad(0, C, m), DEFAULT_GAIN, k.QRTR) @=> Chord Cm;
  c.make(s.triad(0, Cs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Csm;
  c.make(s.triad(0, D, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dm;
  c.make(s.triad(0, Ds, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dsm;
  c.make(s.triad(0, Ef, m), DEFAULT_GAIN, k.QRTR) @=> Chord Efm;
  c.make(s.triad(0, E, m), DEFAULT_GAIN, k.QRTR) @=> Chord Em;
  c.make(s.triad(0, F, m), DEFAULT_GAIN, k.QRTR) @=> Chord _Fm;
  c.make(s.triad(0, Fs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Fsm;
  c.make(s.triad(0, Gf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gfm;
  c.make(s.triad(0, G, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gm;
  c.make(s.triad(0, Gs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gsm;
  c.make(s.triad(0, Af, m), DEFAULT_GAIN, k.QRTR) @=> Chord Afm;
  c.make(s.triad(0, A, m), DEFAULT_GAIN, k.QRTR) @=> Chord Am;
  c.make(s.triad(0, As, m), DEFAULT_GAIN, k.QRTR) @=> Chord Asm;
  c.make(s.triad(0, Bf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bfm;
  c.make(s.triad(0, B, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bm;

  c.make(s.triad(1, C, m), DEFAULT_GAIN, k.QRTR) @=> Chord Cm0;
  c.make(s.triad(1, Cs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Csm0;
  c.make(s.triad(1, D, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dm0;
  c.make(s.triad(1, Ds, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dsm0;
  c.make(s.triad(1, Ef, m), DEFAULT_GAIN, k.QRTR) @=> Chord Efm0;
  c.make(s.triad(1, E, m), DEFAULT_GAIN, k.QRTR) @=> Chord Em0;
  c.make(s.triad(1, F, m), DEFAULT_GAIN, k.QRTR) @=> Chord _Fm0;
  c.make(s.triad(1, Fs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Fsm0;
  c.make(s.triad(1, Gf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gfm0;
  c.make(s.triad(1, G, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gm0;
  c.make(s.triad(1, Gs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gsm0;
  c.make(s.triad(1, Af, m), DEFAULT_GAIN, k.QRTR) @=> Chord Afm0;
  c.make(s.triad(1, A, m), DEFAULT_GAIN, k.QRTR) @=> Chord Am0;
  c.make(s.triad(1, As, m), DEFAULT_GAIN, k.QRTR) @=> Chord Asm0;
  c.make(s.triad(1, Bf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bfm0;
  c.make(s.triad(1, B, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bm0;

  c.make(s.triad(2, C, m), DEFAULT_GAIN, k.QRTR) @=> Chord Cm1;
  c.make(s.triad(2, Cs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Csm1;
  c.make(s.triad(2, D, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dm1;
  c.make(s.triad(2, Ds, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dsm1;
  c.make(s.triad(2, Ef, m), DEFAULT_GAIN, k.QRTR) @=> Chord Efm1;
  c.make(s.triad(2, E, m), DEFAULT_GAIN, k.QRTR) @=> Chord Em1;
  c.make(s.triad(2, F, m), DEFAULT_GAIN, k.QRTR) @=> Chord _Fm1;
  c.make(s.triad(2, Fs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Fsm1;
  c.make(s.triad(2, Gf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gfm1;
  c.make(s.triad(2, G, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gm1;
  c.make(s.triad(2, Gs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gsm1;
  c.make(s.triad(2, Af, m), DEFAULT_GAIN, k.QRTR) @=> Chord Afm1;
  c.make(s.triad(2, A, m), DEFAULT_GAIN, k.QRTR) @=> Chord Am1;
  c.make(s.triad(2, As, m), DEFAULT_GAIN, k.QRTR) @=> Chord Asm1;
  c.make(s.triad(2, Bf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bfm1;
  c.make(s.triad(2, B, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bm1;

  c.make(s.triad(3, C, m), DEFAULT_GAIN, k.QRTR) @=> Chord Cm2;
  c.make(s.triad(3, Cs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Csm2;
  c.make(s.triad(3, D, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dm2;
  c.make(s.triad(3, Ds, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dsm2;
  c.make(s.triad(3, Ef, m), DEFAULT_GAIN, k.QRTR) @=> Chord Efm2;
  c.make(s.triad(3, E, m), DEFAULT_GAIN, k.QRTR) @=> Chord Em2;
  c.make(s.triad(3, F, m), DEFAULT_GAIN, k.QRTR) @=> Chord _Fm2;
  c.make(s.triad(3, Fs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Fsm2;
  c.make(s.triad(3, Gf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gfm2;
  c.make(s.triad(3, G, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gm2;
  c.make(s.triad(3, Gs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gsm2;
  c.make(s.triad(3, Af, m), DEFAULT_GAIN, k.QRTR) @=> Chord Afm2;
  c.make(s.triad(3, A, m), DEFAULT_GAIN, k.QRTR) @=> Chord Am2;
  c.make(s.triad(3, As, m), DEFAULT_GAIN, k.QRTR) @=> Chord Asm2;
  c.make(s.triad(3, Bf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bfm2;
  c.make(s.triad(3, B, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bm2;

  c.make(s.triad(4, C, m), DEFAULT_GAIN, k.QRTR) @=> Chord Cm3;
  c.make(s.triad(4, Cs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Csm3;
  c.make(s.triad(4, D, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dm3;
  c.make(s.triad(4, Ds, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dsm3;
  c.make(s.triad(4, Ef, m), DEFAULT_GAIN, k.QRTR) @=> Chord Efm3;
  c.make(s.triad(4, E, m), DEFAULT_GAIN, k.QRTR) @=> Chord Em3;
  c.make(s.triad(4, F, m), DEFAULT_GAIN, k.QRTR) @=> Chord _Fm3;
  c.make(s.triad(4, Fs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Fsm3;
  c.make(s.triad(4, Gf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gfm3;
  c.make(s.triad(4, G, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gm3;
  c.make(s.triad(4, Gs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gsm3;
  c.make(s.triad(4, Af, m), DEFAULT_GAIN, k.QRTR) @=> Chord Afm3;
  c.make(s.triad(4, A, m), DEFAULT_GAIN, k.QRTR) @=> Chord Am3;
  c.make(s.triad(4, As, m), DEFAULT_GAIN, k.QRTR) @=> Chord Asm3;
  c.make(s.triad(4, Bf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bfm3;
  c.make(s.triad(4, B, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bm3;

  c.make(s.triad(5, C, m), DEFAULT_GAIN, k.QRTR) @=> Chord Cm4;
  c.make(s.triad(5, Cs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Csm4;
  c.make(s.triad(5, D, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dm4;
  c.make(s.triad(5, Ds, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dsm4;
  c.make(s.triad(5, Ef, m), DEFAULT_GAIN, k.QRTR) @=> Chord Efm4;
  c.make(s.triad(5, E, m), DEFAULT_GAIN, k.QRTR) @=> Chord Em4;
  c.make(s.triad(5, F, m), DEFAULT_GAIN, k.QRTR) @=> Chord _Fm4;
  c.make(s.triad(5, Fs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Fsm4;
  c.make(s.triad(5, Gf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gfm4;
  c.make(s.triad(5, G, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gm4;
  c.make(s.triad(5, Gs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gsm4;
  c.make(s.triad(5, Af, m), DEFAULT_GAIN, k.QRTR) @=> Chord Afm4;
  c.make(s.triad(5, A, m), DEFAULT_GAIN, k.QRTR) @=> Chord Am4;
  c.make(s.triad(5, As, m), DEFAULT_GAIN, k.QRTR) @=> Chord Asm4;
  c.make(s.triad(5, Bf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bfm4;
  c.make(s.triad(5, B, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bm4;

  c.make(s.triad(6, C, m), DEFAULT_GAIN, k.QRTR) @=> Chord Cm5;
  c.make(s.triad(6, Cs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Csm5;
  c.make(s.triad(6, D, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dm5;
  c.make(s.triad(6, Ds, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dsm5;
  c.make(s.triad(6, Ef, m), DEFAULT_GAIN, k.QRTR) @=> Chord Efm5;
  c.make(s.triad(6, E, m), DEFAULT_GAIN, k.QRTR) @=> Chord Em5;
  c.make(s.triad(6, F, m), DEFAULT_GAIN, k.QRTR) @=> Chord _Fm5;
  c.make(s.triad(6, Fs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Fsm5;
  c.make(s.triad(6, Gf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gfm5;
  c.make(s.triad(6, G, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gm5;
  c.make(s.triad(6, Gs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gsm5;
  c.make(s.triad(6, Af, m), DEFAULT_GAIN, k.QRTR) @=> Chord Afm5;
  c.make(s.triad(6, A, m), DEFAULT_GAIN, k.QRTR) @=> Chord Am5;
  c.make(s.triad(6, As, m), DEFAULT_GAIN, k.QRTR) @=> Chord Asm5;
  c.make(s.triad(6, Bf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bfm5;
  c.make(s.triad(6, B, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bm5;

  c.make(s.triad(7, C, m), DEFAULT_GAIN, k.QRTR) @=> Chord Cm6;
  c.make(s.triad(7, Cs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Csm6;
  c.make(s.triad(7, D, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dm6;
  c.make(s.triad(7, Ds, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dsm6;
  c.make(s.triad(7, Ef, m), DEFAULT_GAIN, k.QRTR) @=> Chord Efm6;
  c.make(s.triad(7, E, m), DEFAULT_GAIN, k.QRTR) @=> Chord Em6;
  c.make(s.triad(7, F, m), DEFAULT_GAIN, k.QRTR) @=> Chord _Fm6;
  c.make(s.triad(7, Fs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Fsm6;
  c.make(s.triad(7, Gf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gfm6;
  c.make(s.triad(7, G, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gm6;
  c.make(s.triad(7, Gs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gsm6;
  c.make(s.triad(7, Af, m), DEFAULT_GAIN, k.QRTR) @=> Chord Afm6;
  c.make(s.triad(7, A, m), DEFAULT_GAIN, k.QRTR) @=> Chord Am6;
  c.make(s.triad(7, As, m), DEFAULT_GAIN, k.QRTR) @=> Chord Asm6;
  c.make(s.triad(7, Bf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bfm6;
  c.make(s.triad(7, B, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bm6;

  c.make(s.triad(8, C, m), DEFAULT_GAIN, k.QRTR) @=> Chord Cm7;
  c.make(s.triad(8, Cs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Csm7;
  c.make(s.triad(8, D, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dm7;
  c.make(s.triad(8, Ds, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dsm7;
  c.make(s.triad(8, Ef, m), DEFAULT_GAIN, k.QRTR) @=> Chord Efm7;
  c.make(s.triad(8, E, m), DEFAULT_GAIN, k.QRTR) @=> Chord Em7;
  c.make(s.triad(8, F, m), DEFAULT_GAIN, k.QRTR) @=> Chord _Fm7;
  c.make(s.triad(8, Fs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Fsm7;
  c.make(s.triad(8, Gf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gfm7;
  c.make(s.triad(8, G, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gm7;
  c.make(s.triad(8, Gs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gsm7;
  c.make(s.triad(8, Af, m), DEFAULT_GAIN, k.QRTR) @=> Chord Afm7;
  c.make(s.triad(8, A, m), DEFAULT_GAIN, k.QRTR) @=> Chord Am7;
  c.make(s.triad(8, As, m), DEFAULT_GAIN, k.QRTR) @=> Chord Asm7;
  c.make(s.triad(8, Bf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bfm7;
  c.make(s.triad(8, B, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bm7;

  c.make(s.triad(9, C, m), DEFAULT_GAIN, k.QRTR) @=> Chord Cm8;
  c.make(s.triad(9, Cs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Csm8;
  c.make(s.triad(9, D, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dm8;
  c.make(s.triad(9, Ds, m), DEFAULT_GAIN, k.QRTR) @=> Chord Dsm8;
  c.make(s.triad(9, Ef, m), DEFAULT_GAIN, k.QRTR) @=> Chord Efm8;
  c.make(s.triad(9, E, m), DEFAULT_GAIN, k.QRTR) @=> Chord Em8;
  c.make(s.triad(9, F, m), DEFAULT_GAIN, k.QRTR) @=> Chord _Fm8;
  c.make(s.triad(9, Fs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Fsm8;
  c.make(s.triad(9, Gf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gfm8;
  c.make(s.triad(9, G, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gm8;
  c.make(s.triad(9, Gs, m), DEFAULT_GAIN, k.QRTR) @=> Chord Gsm8;
  c.make(s.triad(9, Af, m), DEFAULT_GAIN, k.QRTR) @=> Chord Afm8;
  c.make(s.triad(9, A, m), DEFAULT_GAIN, k.QRTR) @=> Chord Am8;
  c.make(s.triad(9, As, m), DEFAULT_GAIN, k.QRTR) @=> Chord Asm8;
  c.make(s.triad(9, Bf, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bfm8;
  c.make(s.triad(9, B, m), DEFAULT_GAIN, k.QRTR) @=> Chord Bm8;
}
