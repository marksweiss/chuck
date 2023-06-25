public class CoroutineController {
  0 => int IS_NOT_HEAD;
  1 => int IS_HEAD;

  int id;
  string name;
  Coroutine cor;
  Lock lock;
  int isHead;

  fun void init(int id, string name, Coroutine cor, Lock lock, int isHead) {
    id => this.id;
    name => this.name;
    cor @=> this.cor;
    lock @=> this.lock;
    isHead => this.isHead; 

    cor.register(id);
  }
}
