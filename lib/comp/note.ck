// Machine.add("lib/comp/scale.ck")

public class Note {
  0.1 => static float DEFAULT_GAIN; 
  1.0::second => static dur DEFAULT_DUR;

  string name; 
  int pitch;
  float freq;
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

    Std.itoa(me.id()) => name;
  }

  fun void init(float freq_, float gain_, dur duration_) {
    if (gain_ < 0.0 || gain_ > 1.0) {
      <<< "gain must be in range [0.0 .. 1.0], value:", gain_ >>>;
      me.exit();
    }
    freq_ => freq;
    gain_ => gain;
    duration_ => duration;

    Std.itoa(me.id()) => name;
  }

  fun static Note make(int pitch_, float gain_, dur duration_) {
    Note n;
    n.init(pitch_, gain_, duration_);
    return n;
  }

  // TODO TEST
  fun static Note make(int octave, int pitch_, float gain_, dur duration_) {
    return make(octave + pitch_, gain_, duration_); 
  }

  // TODO TEST
  fun static Note make(Note note) {
    return make(note.pitch, note.gain, note.duration);
  }

  fun static Note make(int pitch_) {
    return make(pitch_, DEFAULT_GAIN, DEFAULT_DUR);
  }

  fun static Note make(float freq_, float gain_, dur duration_) {
    Note n;
    n.init(freq_, gain_, duration_);
    return n;
  }

  fun static Note make(float freq_) {
    return make(freq_, DEFAULT_GAIN, DEFAULT_DUR);
  }

  // TODO TEST
  fun static Note dotN(Note note) {
    Note.make(note) @=> Note ret;
    ret.duration * 1.5 @=> ret.duration;
    return ret;
  }

  // TODO TEST
  fun static dur dotD(dur duration) {
    return duration * 1.5;
  }
}
