class AudioManager {

  PApplet pa;

  public void init(boolean useSong, boolean useMic, boolean useBeat, PApplet pa) {    //does nothing
    this.pa = pa;
  }

  public void getLevel(int bandFrom, int bandTo) {
    if (javascript) {
      return javascript.getMeter()*30;
    } else {
      return 0;
    }
  }

  public void getSpecSize() {
    return 0;
  }
}
