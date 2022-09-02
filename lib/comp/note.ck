// Machine.add("lib/comp/scale.ck")

public class Note {
  0.5 => static float DEFAULT_GAIN; 
  1.0::second => static dur DEFAULT_DUR;
 
  int pitch;
  float gain;  // [0.0 .. 1.0]
  dur duration;

  fun void init(int pitch_, float gain_, dur duration_) {
    if (gain_ < 0.0 || gain_ > 1.0) {
      <<< "gain must be in range [0.0 .. 1.0], value:", gain_ >>>;
      me.exit();
    }
    pitch_ => pitch;
    gain_ => gain;
    duration_ => duration;
  }

  fun static Note make(int pitch_, float gain_, dur duration_) {
    Note n;
    n.init(pitch_, gain_, duration_);
    return n;
  }

  fun static Note make(int pitch_) {
    return make(pitch_, DEFAULT_GAIN, DEFAULT_DUR);
  }
}

fun void main() {
  Scale.D => int pitch;
  .75 => float gain;
  2.0::second => dur duration;
  Note n;
  <<< n.make(pitch) >>>;
  <<< n.make(pitch, gain, duration) >>>;
  n.make(pitch, gain, duration) @=> Note newNote;
  <<< newNote.pitch, newNote.gain, newNote.duration >>>;
}

main();
