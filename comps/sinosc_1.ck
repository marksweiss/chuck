// cli: $> chuck lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck \
//               lib/arg_parser/float_arg.ck lib/arg_parser/string_arg.ck \
//               lib/arg_parser/arg_parser.ck lib/comp/scale.ck lib/comp/note.ck \
//               lib/comp/chord.ck lib/comp/instrument/instrument.ck lib/comp/clock.ck
//               lib/comp/instrument/sinosc.ck comps/sinosc_1.ck

// For client to spork, which requires a free function as entry point
public void playClock(Clock clock) {
  <<< "IN playClock" >>>;

  clock.play();
}

// For client to spork, which requires a free function as entry point
public void playInstrSinOsc(InstrSinOsc instr) {
  <<< "IN playInstr" >>>;

  instr.play();
}

fun void main () {
  <<< "--------------------------\nIN SINOSC MAIN, shred id:" >>>;

  240 => int BPM; 
  4 => int OCTAVE;
  0.75 => float GAIN;

  Event startEvent;
  Event stepEvent; 

  Clock clock;
  clock.init(BPM, startEvent, stepEvent);

  clock.D(0.25) => dur QRTR;
  clock.D(0.5) => dur HLF;
  clock.D(1.0) => dur WHL;
  /* clock.quarter() => dur QRTR; */

  <<< "IN SINOSC MAIN QUARTER_DUR", QRTR >>>;

  InstrSinOsc instr;
  ArgParser conf;
  conf.addFloatArg("gain", GAIN);
  conf.loadArgs();
  instr.init(conf, startEvent, stepEvent, clock.stepDur);

  <<< "IN SINOSC MAIN AFTER INSTR.INIT()" >>>;

  Chord c;
  Scale s;
  Chord chords[2];
  c.make(s.triad(OCTAVE, s.C, s.M), GAIN * 0.8, WHL) @=> Chord CMaj;
  /* c.make(s.triad(OCTAVE, s.F, s.m), GAIN, QRTR) @=> Chord FMin; */
  /* c.make(s.triad(OCTAVE + 1, s.G, s.M), GAIN * 0.8, QRTR) @=> Chord GMaj; */
  c.make(s.triad(OCTAVE, s.C, s.M), 0.0, WHL) @=> Chord CMaj_Rest;
  CMaj @=> chords[0];
  /* FMin @=> chords[1]; */
  /* GMaj @=> chords[2]; */
  CMaj_Rest @=> chords[1];
  instr.addChords(chords);

  <<< "IN SINOSC MAIN AFTER SYNC BEFORE SPORK" >>>;

  spork ~ playClock(clock);
  spork ~ playInstrSinOsc(instr);

  <<< "IN SINOSC MAIN AFTER SPORK" >>>;
 
  me.yield();  // yield to Clock and Instrument event loops 
  while (true) {1::second => now;}  // block process exit to force child threads to run
}

main();

