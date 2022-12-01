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
    isLooping => this.isLooping;
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
    // TEMP DEBUG
    /* <<< "IN SEQUENCES.next() TOP, idx:", idx, " seqs size", seqs.size(), "thread", me.id() >>>; */

    if (idx == seqs.size()) {
      if (!isLooping) {
        return null;
      } else {
        reset(); 
      }
    }
    return seqs[idx++];
  }

  fun Sequence current() {
    // TEMP DEBUG
    /* <<< "IN SEQUENCES.current(), idx:", idx, "seqs size", seqs.size(), "thread", me.id() >>>; */

    return seqs[idx];
  }

  fun void reset() {
    0 => idx;
  }
}
