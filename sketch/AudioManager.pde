class AudioManager {

  PApplet pa;

  public void init(boolean useSong, boolean useMic, boolean useBeat, PApplet pa) {    //does nothing
    this.pa = pa;
  }

  public void getLevel(int bandFrom, int bandTo) {
    var level = 0;
    if (javascript) {
      level = javascript.getMeter()*10;
    }
    return level;
  }

  public void getSpecSize() {
    return 0;
  }
}
