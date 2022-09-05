// arg_parser
/* Machine.add("lib/arg_parser/arg_base.ck"); */
/* Machine.add("lib/arg_parser/int_arg.ck"); */
/* Machine.add("lib/arg_parser/float_arg.ck"); */
/* Machine.add("lib/arg_parser/string_arg.ck"); */
/* Machine.add("lib/arg_parser/arg_parser.ck"); */
// comp
/* Machine.add("lib/comp/scale.ck"); */
/* Machine.add("lib/comp/note.ck"); */
/* Machine.add("lib/comp/chord.ck"); */
/* Machine.add("lib/comp/time.ck"); */
// comp/instrument
/* Machine.add("lib/comp/instrument/instrument.ck"); */

// cli: $> chuck lib/arg_parser/arg_base.ck lib/arg_parser/int_arg.ck \
//               lib/arg_parser/float_arg.ck lib/arg_parser/string_arg.ck \
//               lib/arg_parser/arg_parser.ck lib/comp/scale.ck lib/comp/note.ck \
//               lib/comp/chord.ck lib/comp/instrument/instrument.ck lib/comp/time.ck
//               lib/comp/instrument/sinosc.ck

// For client to spork, which requires a free function as entry point
public void playTime(Time time_) {
  <<< "IN playTime" >>>;

  time_.play();
}

// For client to spork, which requires a free function as entry point
public void playInstrSinOsc(InstrSinOsc instr) {
  <<< "IN playInstr" >>>;

  instr.play();
}

public class InstrSinOsc extends Instrument {
  // ugen setup
  Gain g;
  SinOsc so0 => g => dac;
  SinOsc so1 => g => dac;
  SinOsc so2 => g => dac;
  SinOsc players[DEFAULT_NUM_PLAYERS];
  so0 @=> players[0];
  so1 @=> players[1];
  so2 @=> players[2];
  // args specific to this instr
  "--gain" => string ARG_GAIN;
  "--pitch" => string ARG_PITCH;
  false => int convertPitchToFreq;
  // events
  Event startEvent;
  Event stepEvent;
  dur stepDur;

  fun void init(ArgParser conf, Event startEvent, Event playEvent, dur stepDur) {
    conf.args[ARG_GAIN].fltVal => g.gain;
    if (conf.hasArg(ARG_PITCH)) {
      true => convertPitchToFreq;
    }

    <<< "DEBUG convertPitchToFreq:", convertPitchToFreq >>>;
    <<< "DEBUG gain:", conf.args[ARG_GAIN].fltVal >>>;
    
    startEvent @=> this.startEvent;    
    stepEvent @=> this.stepEvent;    
    stepDur => this.stepDur;

    <<< "DEBUG this.startEvent:", startEvent >>>;
    <<< "DEBUG this.stepEvent:", stepEvent >>>;
    <<< "DEBUG this.stepDur:", stepDur, "ms" >>>;
  }

  fun void instrHelp() {
    <<< "Args:\n'gain' - float - [0.0..1.0]" >>>;
    <<< "Usage: Expects chords to have freq set. To use with pitch pass '--pitch = true' arg" >>>;
  }

  fun void play() {
    <<< "IN INSTR PLAY BEFORE START" >>>;

    /* if (convertPitchToFreq) { */
    /*   playConvertingPitch(); */
    /* } */

    // block on START
    startEvent => now;

    <<< "START passed in Instr" >>>;

    0 => int i;
    0::ms => dur sinceLastNote;
    while (true) {
      // get next note to play
      chords[i] @=> Chord c;
      // TODO assumes all notes in chord have same duration
      c.notes[0].duration => dur nextNoteDur;

      // block on event of next beat step broadcast by clock
      stepEvent => now;
      sinceLastNote +=> stepDur; 
      <<< "STEP passed in Instr", sinceLastNote >>>;

      // if enough time has passed, emit the note
      if (sinceLastNote == nextNoteDur) {
        for (0 => int j; j < c.notes.cap(); j++) {
          c.notes[j] @=> Note n;
          players[i].freq(Std.mtof(n.pitch)); 
          n.gain => g.gain;
        }

        0::ms => sinceLastNote;
        (i + 1) % numChords => i;
      }
    }
  }

  // TODO FIX THIS
  // To avoid an extra if check on every note play
  /* fun void playConvertingPitch() { */
  /*   0 => int i; */
  /*   while (true) { */
  /*     chords[i] @=> Chord c; */
  /*     for (0 => int j; j < c.notes.cap(); j++) { */
  /*       c.notes[j] @=> Note n; */
  /*       players[i].freq(n.Std.mtof(freq)); */ 
  /*       n[j].gain => g.gain; */

  /*       // TODO TIME */
  /*       // n.duration => now; */
  /*     } */

  /*     (i + 1) % numChords => i; */
  /*   } */
  /* } */
}

fun void main () {
  <<< "--------------------------\nIN SINOSC MAIN" >>>;

  120 => int BPM; 

  Event startEvent;
  Event stepEvent; 

  Time time_;
  time_.init(BPM, startEvent, stepEvent);

  InstrSinOsc instr;
  ArgParser conf;
  conf.addFloatArg("gain", 0.5);
  conf.loadArgs();
  instr.init(conf, startEvent, stepEvent, time_.getStepDur());

  <<< "IN SINOSC MAIN AFTER INSTR.INIT()" >>>;

  Chord c;
  Scale s;
  4 => int octave;
  Chord chords[3];
  c.make(s.triad(octave, s.C, s.MAJOR_TRIAD)) @=> Chord CMaj;
  c.make(s.triad(octave, s.D, s.MAJOR_TRIAD)) @=> Chord DMaj;
  c.make(s.triad(octave + 1, s.G, s.MAJOR_TRIAD)) @=> Chord GMaj;
  CMaj @=> chords[0];
  DMaj @=> chords[1];
  GMaj @=> chords[2];
  instr.addChords(chords);

  <<< "IN SINOSC MAIN AFTER INSTR.ADD_CHORDS()" >>>;

  time_.sync();

  <<< "IN SINOSC MAIN AFTER SYNC BEFORE SPORK" >>>;

  spork ~ playTime(time_);
  spork ~ playInstrSinOsc(instr);

  <<< "IN SINOSC MAIN AFTER SPORK" >>>;

  // yield to Time and Player event loops to perform the composition
  me.yield();
  // need last statement in outer scope to block process exit to force child threads to run
  while (true) {
    1::second => now;
  }
}

main();
