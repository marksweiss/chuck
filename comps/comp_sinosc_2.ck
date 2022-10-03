// cli: $> chuck lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck lib/arg_parser/float_arg.ck \
//               lib/arg_parser/time_arg.ck lib/arg_parser/duration_arg.ck lib/arg_parser/string_arg.ck \
//               lib/arg_parser/arg_parser.ck lib/comp/scale.ck lib/comp/note.ck lib/comp/chord.ck \
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

fun void main () {
  <<< "--------------------------\nIN SINOSC MAIN, shred id:" >>>;

  // For "static" consts
  Chord c;
  Scale s;
  ScaleConst sc;
  Clock k;

  240 => int BPM; 
  Event startEvent;
  Event stepEvent; 
  Clock clock;
  // BPM not used right now, because we are using ScaleConst default  
  clock.init(BPM, startEvent, stepEvent);

  Chord chords1[4];
  Chord chords2[4];
  sc.CM4_4 @=> chords1[0];
  sc._FM4_4 @=> chords1[1];
  sc.GM4_4 @=> chords1[2];
  sc.REST_1 @=> chords1[3];
  sc._FM4_4 @=> chords2[0];
  sc.CM4_4 @=> chords2[1];
  sc.REST_1 @=> chords2[2];
  sc.GM4_4 @=> chords2[3];

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

