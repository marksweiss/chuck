// cli: $> chuck lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck \
//               lib/arg_parser/float_arg.ck lib/arg_parser/float_arg.ck lib/arg_parser/time_arg.ck \
//               lib/arg_parser/string_arg.ck lib/arg_parser/arg_parser.ck lib/comp/scale.ck lib/comp/note.ck \
//               lib/comp/chord.ck lib/comp/instrument/instrument_base.ck lib/comp/clock.ck
//               test/assert.ck lib/comp/instrument/sinosc2.ck comps/sinosc_2.ck

// For client to spork, which requires a free function as entry point
public void playClock(Clock clock) {
  clock.play();
}

public void playInstrSinOsc(InstrSinOsc2 instr) {
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

  InstrSinOsc2 instr;
  ArgParser conf;
  conf.addDurationArg("adsrAttack", 120::ms);
  conf.addDurationArg("adsrDecay", 70::ms);
  conf.addFloatArg("adsrSustain", 0.8);
  conf.addDurationArg("adsrRelease", 300::ms);
  conf.addFloatArg("chorusModFreq", 4000.0);
  conf.addFloatArg("chorusModDepth", 0.7);
  conf.addFloatArg("chorusMix", 0.4);
  conf.addFloatArg("modulateVibratoRate", 300.0);
  conf.addFloatArg("modulateVibratoGain", 0.05);
  conf.addFloatArg("modulateRandomGain", 0.1);
  conf.addDurationArg("delayDelay", 50::ms);
  /* conf.addDurationArg("delayMax", 50::ms); */
  conf.addDurationArg("echoDelay", 200::ms);
  /* conf.addDurationArg("echoMax", 100::ms); */
  conf.addFloatArg("echoMix", 0.6);
  conf.addFloatArg("reverbMix", 1.1);
  conf.addFloatArg("panPan", 0.0);
  conf.addFloatArg("mixPan", 1.0);
  conf.loadArgs();

  instr.init(conf, startEvent, stepEvent, clock.stepDur);

  Chord c;
  Scale s;
  Chord chords[4];
  c.make(s.triad(OCTAVE, s.C, s.M), GAIN * 0.8, HLF) @=> Chord CMaj;
  c.make(s.triad(OCTAVE, s.F, s.M), GAIN, QRTR) @=> Chord FMaj;
  c.make(s.triad(OCTAVE, s.G, s.M), GAIN * 0.8, QRTR) @=> Chord GMaj;
  c.rest(WHL) @=> Chord rest;
  CMaj @=> chords[0];
  FMaj @=> chords[1];
  GMaj @=> chords[2];
  rest @=> chords[3];
  instr.addChords(chords);

  spork ~ playClock(clock);
  spork ~ playInstrSinOsc(instr);
  me.yield();  // yield to Clock and Instrument event loops 
  while (true) {1::second => now;}  // block process exit to force child threads to run
}

main();

