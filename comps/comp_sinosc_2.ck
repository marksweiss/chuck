// cli: $> chuck lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck lib/arg_parser/float_arg.ck \
//               lib/arg_parser/time_arg.ck lib/arg_parser/duration_arg.ck lib/arg_parser/string_arg.ck \
//               lib/arg_parser/arg_parser.ck lib/comp/note.ck lib/comp/chord.ck lib/comp/scale.ck \
//               lib/comp/sequence.ck lib/comp/sequences.ck lib/comp/instrument/instrument_base.ck lib/comp/clock.ck \
//               lib/comp/scale_const.ck test/assert.ck lib/comp/instrument/sinosc2.ck comps/comp_sinosc_2.ck

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

fun void addPhrase(Chord phrase[], Sequences seqs[]) {
  for (0 => int i; i < seqs.size(); ++i) {
    Sequence seq;
    seq.init(Std.itoa(i), false);  // not looping phrases 
    seq.add(phrase);
    seqs[i].add(seq);
  } 
}

fun void main () {
  <<< "--------------------------\nIN SINOSC MAIN, shred id:" >>>;

  // init clock, tempo and time advance Events
  240 => int BPM; 
  Event startEvent;
  Event stepEvent; 
  Clock clock;
  clock.init(BPM, startEvent, stepEvent);

  // declare sequence containers
  true => int isLooping;
  Sequences seqs1;
  seqs1.init("seqs1", isLooping);
  Sequences seqs2;
  seqs2.init("seqs2", isLooping);
  [seqs1, seqs2] @=> Sequences seqs[];

  // declare chords / notes for each sequence
  Scale L;
  ScaleConst S;
  addPhrase([S.CM4_8, S.EM4_4, S.CM4_8, S.EM4_4, S.CM4_8, S.EM4_4], seqs);
  addPhrase([S.CM4_8, S.EM4_8, S.FM4_8, S.EM4_4], seqs);
  addPhrase([S.REST_8, S.EM4_8, S.FM4_8, S.EM4_8], seqs);
  addPhrase([S.REST_8, S.EM4_8, S.FM4_8, S.GM4_8], seqs);
  addPhrase([S.EM4_8, S.FM4_8, S.GM4_8, S.REST_8], seqs);
  addPhrase([S.CM5_1, S.CM5_1], seqs);
  addPhrase([S.REST_4, S.REST_4, S.REST_4, S.REST_8,
             S.CM4_8, S.CM4_8, S.CM4_8,
             S.REST_8, S.REST_4, S.REST_4, S.REST_4], seqs);
  addPhrase([L.dotC(S.GM4_1), S.FM4_1, S.FM4_1], seqs);
  addPhrase([S.BM4_16, S.GM4_16, S.REST_8, S.REST_4, S.REST_4, S.REST_4], seqs);
  addPhrase([S.BM4_16, S.GM4_16], seqs);

  // configure instruments, pass clock, Events and sequences of phrases to them
  getConf(100, 60::ms, 120::ms, 90::ms) @=> ArgParser conf1;
  getConf(250, 10::ms, 110::ms, 80::ms) @=> ArgParser conf2;
  InstrSinOsc2 instr1;
  InstrSinOsc2 instr2; 
  instr1.init(conf1, seqs1, startEvent, stepEvent, clock.stepDur); 
  instr2.init(conf2, seqs2, startEvent, stepEvent, clock.stepDur); 

  // start clock thread and instrument play threads
  spork ~ playClock(clock);
  spork ~ playInstr(instr1);
  spork ~ playInstr(instr2);

  // boilerplate to make event loop work
  me.yield();  // yield to Clock and Instrument event loops 
  while (true) {1::second => now;}  // block process exit to force child threads to run
}

main();

