// Machine.add("lib/collection/set.ck"); 


public class Util {

  // TODO UNIT TEST
  fun /*static*/ int[] permutation(int rangeMin, int rangeMax) {
    if (rangeMax < rangeMin) {
      <<< "ERROR: rangeMax", rangeMax, "not greater than rangeMin", rangeMin >>>;
      me.exit();
    }
    if (rangeMin < 0 || rangeMax < 0) {
      <<< "ERROR: rangeMax", rangeMax, "and rangeMin", rangeMin, "must be > 0" >>>;
      me.exit();
    }

    OrderedStringSet unusedIdxs;
    (rangeMax - rangeMin) + 1 => int rangeSize;
    for (rangeMin => int i; i <= rangeMax; i++) {
      unusedIdxs.put(Std.itoa(i)); 
    }

    int idxs[rangeSize];
    0 => int idxCount;
    while (unusedIdxs.notEmpty()) {
      Math.random2(rangeMin, rangeMax) => int idx;
      Std.itoa(idx) => string idxKey;
      if (unusedIdxs.hasKey(idxKey)) {
        idx => idxs[idxCount];
        idxCount++;
        unusedIdxs.delete(idxKey);
      }
    }

    return idxs;
  }
}
