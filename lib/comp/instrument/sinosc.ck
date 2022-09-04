// Machine.add("lib/comp/instrument/instrument.ck")

public class InstrSinOsc extends Instrument {
  SinOsc so0 => Gain g => dac;
  SinOsc so1 => Gain g => dac;
  SinOsc so2 => Gain g => dac;
  SinOsc players[DEFAULT_NUM_PLAYERS];

  false => bool convertPitchToFreq;
  "pitch" => static string PITCH;

  Time clock;

  fun void init(Time clock) {
    // super()
    clock @=> this.clock;
    //
    0 => numChords;
    DEFAULT_NUM_CHORDS => maxNumChords;
    //
    so0 @=> players[0];
    so1 @=> players[1];
    so2 @=> players[2];
  }

  fun void help() {
    <<< "Args:\n'gain' - float - [0.0..1.0]" >>>;
    <<< "Usage: Expects chords to have freq set. To use with pitch pass '--pitch = true' arg" >>>;
  }

  fun void configure(ArgParser conf) {
    conf["--gain"].floatVal => g.gain;
    if cont.hasArg(PITCH) {
      true => convertPitchToFreq;
    }
  }

  fun void play() {
    if (convertPitchToFreq) {
      playConvertingPitch();
    }

    0 => int i;
    0::ms => dur sinceLastNote;
    0::ms => dur nextNoteDur; 
    while (true) {
      // get next note to play
      chords[i] @=> Chord c;
      c.notes[j] @=> Note n;

      // block on event of next beat step broadcast by clock
      clock.STEP => now;
      sinceLastNote +=> clock.beatStepDur;

      // if enough time has passed, emit the note
      if (sinceLastNote == n.duration) {
        for (0 => int j; j < c.notes.cap(); j++) {
          players[i].freq(n.freq); 
          n[j].gain => g.gain;
        }

        0::ms => sinceLastNote;
        (i + 1) % numChords => i;
      }
    }
  }

  // To avoid an extra if check on every note play
  fun void playConvertingPitch() {
    0 => int i;
    while (true) {
      chords[i] @=> Chord c;
      for (0 => int j; j < c.notes.cap(); j++) {
        c.notes[j] @=> Note n;
        players[i].freq(n.Std.mtof(freq)); 
        n[j].gain => g.gain;

        // TODO TIME
        // n.duration => now;
      }

      (i + 1) % numChords => i;
    }
  }
}

fun void main () {
  ArgParser args;
  args.addFloatArg("gain", 0.5);

  Chord chords[2];
  Chord C;
  C.make(S.triad(4, S.C, S.MAJOR_TRIAD)) @=> Chord CMaj;
  C.make(S.triad(4, S.D, S.MAJOR_TRIAD)) @=> Chord DMaj;
  CMaj @=> chords[0];
  DMaj @=> chords[1];

  InstrSinOsc instr;
  instr.configure(args);
  instr.addChords(chords);

  instr.play(); 
}

main();
