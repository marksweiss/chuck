// cli: $> chuck test/assert.ck lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck lib/arg_parser/float_arg.ck \
//               lib/arg_parser/time_arg.ck lib/arg_parser/duration_arg.ck lib/arg_parser/string_arg.ck \
//               lib/collection/arg_map.ck lib/collection/object_map.ck lib/collection/set.ck \
//               lib/arg_parser/arg_parser.ck lib/comp/conductor.ck lib/comp/in_c_conductor.ck \
//               lib/comp/note.ck lib/comp/chord.ck lib/comp/scale.ck \
//               lib/comp/sequence.ck lib/comp/sequences.ck lib/comp/instrument/instrument_base.ck lib/comp/clock.ck \
//               lib/comp/note_const.ck lib/comp/scale_const.ck lib/comp/instrument/sinosc2.ck \
//               lib/comp/player_base.ck lib/comp/in_c_player.ck comps/comp_sinosc_2.ck \

// For client to spork, which requires a free function as entry point
public void runClock(Clock clock) {
  clock.play();
}

public void runPlayer(PlayerBase player) {
  player.play();
}

fun ArgParser getConf(float modulateVibratoRate, dur attack, dur decay, dur release) {
  ArgParser conf;
  conf.addDurationArg("adsrAttack", attack);
  conf.addDurationArg("adsrDecay", decay);
  conf.addFloatArg("adsrSustain", 0.5);
  conf.addDurationArg("adsrRelease", release);
  /* conf.addFloatArg("chorusModFreq", 200.0); */
  /* conf.addFloatArg("chorusModDepth", 0.2); */
  /* conf.addFloatArg("chorusMix", 0.4); */
  /* conf.addFloatArg("modulateVibratoRate", modulateVibratoRate); */
  /* conf.addFloatArg("modulateVibratoGain", 0.05); */
  /* conf.addFloatArg("modulateRandomGain", 0.1); */
  conf.addDurationArg("delayDelay", 10::ms);
  conf.addDurationArg("delayMax", 20::ms);
  conf.addDurationArg("echoDelay", 55::ms);
  /* conf.addDurationArg("echoMax", 100::ms); */
  /* conf.addFloatArg("echoMix", 0.3); */
  /* conf.addFloatArg("reverbMix", 0.05); */
  /* conf.addFloatArg("panPan", 0.0); */
  /* conf.addFloatArg("mixPan", 1.0); */
  conf.loadArgs();

  return conf;
}

fun void addPhrase(Note phrase[], Sequences seqs[]) {
  for (0 => int i; i < seqs.size(); ++i) {
    Sequence seq;
    seq.init(Std.itoa(i), false);  // not looping phrases 
    seq.add(phrase);
    seqs[i].add(seq);
  } 
}

fun void main () {
  // TODO
  // - Look at other UGens, work on better timbres for composition
  // - Experiment with micro-detune, (see detune example in book)
  // - JUST INTONATION!!!
  // - Dynamic signal processing example from Chuck book, Chapter 8
  // - Cleanup
  //   - move In C stuff into it's own directory

  // TEMP DEBUG
  /* <<< "--------------------------\nIN SINOSC MAIN, shred id:" >>>; */

  // global coordinator of interprocess state governing composition behavior, such
  // as in this case whether instruments move to the next phrase or stay on the current one
  InCConductor conductor;

  // init clock, tempo and time advance Events
  240 => int BPM; 
  Event startEvent;
  Event stepEvent; 

  // TEMP DEBUG
  /* <<< "IN COMP SINOSC, stepEvent address =", stepEvent, "shredId", me.id() >>>; */
  
  Clock clock;
  clock.init(BPM, startEvent, stepEvent, conductor);

  // declare sequence containers
  true => int isLooping;
  Sequences seqs1;
  seqs1.init("seqs1", isLooping);
  Sequences seqs2;
  seqs2.init("seqs2", isLooping);
  Sequences seqs3;
  seqs3.init("seqs3", isLooping);
  [seqs1, seqs2, seqs3] @=> Sequences seqs[];

  // declare chords / notes for each sequence
  NoteConst N;
  Note T;
  ScaleConst S;
  addPhrase([N.C4_8, N.E4_4, N.C4_8, N.E4_4, N.C4_8, N.E4_4], seqs);
  addPhrase([N.C4_8, N.E4_8, N.F4_8, N.E4_4], seqs);
  addPhrase([N.REST_8, N.E4_8, N.F4_8, N.E4_8], seqs);
  addPhrase([N.REST_8, N.E4_8, N.F4_8, N.G4_8], seqs);
  addPhrase([N.E4_8, N.F4_8, N.G4_8, N.REST_8], seqs);
  addPhrase([N.C5_1, N.C5_1], seqs);
  addPhrase([N.REST_4, N.REST_4, N.REST_4, N.REST_8,
             N.C4_8, N.C4_8, N.C4_8,
             N.REST_8, N.REST_4, N.REST_4, N.REST_4], seqs);
  addPhrase([T.dotN(N.G4_1), N.F4_1, N.F4_1], seqs);
  addPhrase([N.B4_16, N.G4_16, N.REST_8, N.REST_4, N.REST_4, N.REST_4], seqs);
  addPhrase([N.B4_16, N.G4_16], seqs);

  // configure instruments, pass clock, Events, sequences of phrases and conductor to them 
  getConf(100, 40::ms, 30::ms, 30::ms) @=> ArgParser conf1;
  getConf(102.5, 25::ms, 40::ms, 50::ms) @=> ArgParser conf2;
  getConf(105, 35::ms, 35::ms, 70::ms) @=> ArgParser conf3;
  InstrSinOsc2 instr1;
  InstrSinOsc2 instr2; 
  InstrSinOsc2 instr3; 
  instr1.init("instr1", conf1);
  instr2.init("instr2", conf2);
  instr3.init("instr3", conf3);

  // declare the Players whose behavior governed by calling the Conductor to
  // to check their state changes, performing the notes of the Sequences using the
  // Instruments to play the notes
  InCPlayer player1;
  player1.init("player1", seqs1, startEvent, stepEvent, clock.stepDur, conductor, instr1);
  InCPlayer player2;
  player2.init("player2", seqs2, startEvent, stepEvent, clock.stepDur, conductor, instr2);
  InCPlayer player3;
  player3.init("player3", seqs3, startEvent, stepEvent, clock.stepDur, conductor, instr3);

  // start clock thread and instrument play threads
  spork ~ runClock(clock);
  spork ~ runPlayer(player1);
  spork ~ runPlayer(player2);
  spork ~ runPlayer(player3);

  while (true) {1::second => now;}  // block process exit to force child threads to run
}

main();

