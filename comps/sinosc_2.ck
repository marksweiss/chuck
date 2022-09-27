// cli: $> chuck lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck \
//               lib/arg_parser/float_arg.ck lib/arg_parser/float_arg.ck lib/arg_parser/time_arg.ck \
//               lib/arg_parser/string_arg.ck lib/arg_parser/arg_parser.ck lib/comp/scale.ck lib/comp/scale_const.ck \
//               lib/comp/note.ck lib/comp/chord.ck lib/comp/sequence.ck lib/comp/sequenceick \
//               lib/comp/instrument/instrument_base.ck lib/comp/clock.ck test/assert.ck \
//               lib/comp/instrument/sinosc2.ck comps/sinosc_2.ck

// For client to spork, which requires a free function as entry point
public void playClock(Clock clock) {
  clock.play();
}

public void playInstr(InstrSinOsc2 instr) {
  instr.play();
}

fun ArgParser getConf(float modulateVibratoRate, dur attack, dur decay, dur release) {
  ArgParser conf;
  conf.addDurationArg("adsrAttack", attack);
  conf.addDurationArg("adsrDecay", decay);
  conf.addFloatArg("adsrSustain", 0.9);
  conf.addDurationArg("adsrRelease", release);
  conf.addFloatArg("chorusModFreq", 200.0);
  conf.addFloatArg("chorusModDepth", 0.2);
  conf.addFloatArg("chorusMix", 0.4);
  conf.addFloatArg("modulateVibratoRate", modulateVibratoRate);
  conf.addFloatArg("modulateVibratoGain", 0.05);
  conf.addFloatArg("modulateRandomGain", 0.1);
  conf.addDurationArg("delayDelay", 50::ms);
  conf.addDurationArg("delayMax", 50::ms);
  conf.addDurationArg("echoDelay", 55::ms);
  conf.addDurationArg("echoMax", 100::ms);
  conf.addFloatArg("echoMix", 0.3);
  conf.addFloatArg("reverbMix", 4.1);
  conf.addFloatArg("panPan", 0.0);
  conf.addFloatArg("mixPan", 1.0);
  conf.loadArgs();

  return conf;
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

  Chord c;
  ScaleConst sc;
  Scale s;
  Chord chords1[4];
  Chord chords2[4];
  c.make(s.triad(OCTAVE, sc.C, sc.M), GAIN * 0.8, HLF) @=> Chord CMaj;
  c.make(s.triad(OCTAVE, sc.F, sc.M), GAIN, QRTR) @=> Chord FMaj;
  c.make(s.triad(OCTAVE, sc.G, sc.M), GAIN * 0.8, QRTR) @=> Chord GMaj;
  c.rest(WHL) @=> Chord rest;
  CMaj @=> chords1[0];
  FMaj @=> chords1[1];
  GMaj @=> chords1[2];
  rest @=> chords1[3];
  FMaj @=> chords2[0];
  CMaj @=> chords2[1];
  rest @=> chords2[2];
  GMaj @=> chords2[3];

  true => int isLooping;
  Sequence seq1;
  seq1.init(isLooping);
  Sequence seq2;
  seq2.init(isLooping);
  Sequences seqs1;
  seqs1.init(isLooping);
  seqs1.add(seq1);
  Sequences seqs2;
  seqs2.init(isLooping);
  seqs2.add(seq2);

  seq1.add(chords1);
  seq2.add(chords2);

  getConf(100, 60::ms, 120::ms, 90::ms) @=> ArgParser conf1;
  getConf(250, 10::ms, 110::ms, 80::ms) @=> ArgParser conf2;
  InstrSinOsc2 instr1;
  InstrSinOsc2 instr2; 
  instr1.init(conf1, seqs1, startEvent, stepEvent, clock.stepDur); 
  instr2.init(conf2, seqs2, startEvent, stepEvent, clock.stepDur); 


  spork ~ playClock(clock);
  spork ~ playInstr(instr1);
  spork ~ playInstr(instr2);

  me.yield();  // yield to Clock and Instrument event loops 
  while (true) {1::second => now;}  // block process exit to force child threads to run
}

main();
