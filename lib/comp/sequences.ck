// cli: $> chuck lib/comp/sequence.ck

// TODO TEST
public class Sequences {
  Sequence seqs[0];
  0 => int idx;
  false => int isLooping;

  fun void init(int isLooping) {
    isLooping => this.isLooping;
  }

  fun void add(Sequence seq) {
    this.seqs << seq;
  }

  fun int size() {
    return this.seqs.size();
  }

  fun Sequence next() {
    if (!hasNext()) {
      Sequence s;
      return s;
    }
    seqs[idx] @=> Sequence ret;
    idx++;
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
}
