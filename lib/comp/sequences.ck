// Machine.add("lib/comp/sequence")
// cli: $> chuck lib/comp/sequence lib/comp/sequences.ck

public class Sequences {
  string name;
  // dynamically resize in add()
  Sequence seqs[0];
  0 => int idx;
  // manually maintain because dynamically resizing array doesn't report this accurately
  0 => int count;
  false => int isLooping;

  fun void init(int isLooping) {
    Std.itoa(me.id()) => name;
    isLooping => isLooping;
  }

  fun void init(string name, int isLooping) {
    name => this.name;
    isLooping => this.isLooping;
  }

  fun void add(Sequence seq) {
    seqs << seq;
    count++;
  }

  fun int size() {
    return count;
  }

  fun Sequence next() {
    if (idx == chords.size()) {
      if (!isLooping) {
        return null;
      } else {
        reset(); 
      }
    }
    return seqs[idx++];
  }

  fun Sequence current() {
    return seqs[idx];
  }
}
