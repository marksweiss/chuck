// cli: $> chuck lib/comp/sequence.ck

// TODO TEST
public class Sequences {
  string name;
  // dynamically resize in add()
  Sequence seqs[0];
  0 => int idx;
  // manually maintain because dynamically resizing array doesn't report this accurately
  0 => int count;
  false => int isLooping;

  fun void init(int isLooping) {
    Std.itoa(me.id()) => this.name;
    isLooping => this.isLooping;
  }

  fun void init(string name, int isLooping) {
    name => this.name;
    isLooping => this.isLooping;
  }

  // *** Container interface
  fun void add(Sequence seq) {
    this.seqs << seq;
    ++this.count;
  }

  fun int size() {
    return this.count;
  }
  // ***

  // *** Iterator interface
  fun Sequence next() {
    if (!hasNext()) {
      Sequence s;
      return s;
    }
    seqs[idx] @=> Sequence ret;
    idx++;
    return ret; 
  }

  fun Sequence current() {
    seqs[idx] @=> Sequence ret;
    return ret;
  }

  fun int hasNext() {
    if (this.idx == seqs.size()) {
      if (this.isLooping) {
        0 => this.idx;
        return true;
      }
      <<< "WARN: next() called for position greater than size:", seqs.size() >>>;
      return false;
    }
    return true;
  }
  // *** 
}
