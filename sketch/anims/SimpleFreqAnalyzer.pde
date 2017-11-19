class SimpleFreqAnalyzer extends AnimationBase{
  PGraphics pg;

  // zones of the spectrum that are going to be used
  float specLow = 0.03; // 3% for the bass
  float specMid = 0.125;  // 12.5% for the middle
  float specHi = 0.50;   // 50% for the high-pitch

  // A lot of the high spectrum is not used, since it is too
  // high-pitched to be heard by the human ear

  // each zone score
  float scoreLow = oldScoreLow = 0;
  float scoreMid = oldScoreMid = 0;
  float scoreHi = oldScoreHi = 0;

  // smoothing
  float scoreDecreaseRate = 25;

  // number of frequencies that are monitored
  int nbBands;

  public SimpleFreqAnalyzer() {
    name = "Simple Frequence Analyser";
    firstDisplay = true;
  }

  private void init(){
    pg = createGraphics(width, height);
    pg.colorMode(RGB, 255);
    firstDisplay = false;
  }

  public void display(){
    // console.log("SFA display);
    if(firstDisplay){
      init();
    }
    
    pg.background(0);

    oldScoreLow = scoreLow;
    oldScoreMid = scoreMid;
    oldScoreHi = scoreHi;
    scoreLow = 0;
    scoreMid = 0;
    scoreHi = 0;

    if(dataArray){
      nbBands = int(dataArray.length * specHi);
      // console.log("nbBands: " + nbBands);
      // console.log("dataArray: " + dataArray);
     
      for(int i = 0; i < nbBands*specLow; i++){
        scoreLow += dataArray[i];
      }      
      for(int i = (int)(nbBands*specLow); i < nbBands*specMid; i++){
        scoreMid += dataArray[i];
      }
      for(int i = (int)(nbBands*specMid); i < nbBands*specHi; i++){
        scoreHi += dataArray[i];
      }
      
      //slow down the slope
      if (oldScoreLow > scoreLow) {
        scoreLow = oldScoreLow - scoreDecreaseRate;
      }
      if (oldScoreMid > scoreMid) {
        scoreMid = oldScoreMid - scoreDecreaseRate;
      }
      if (oldScoreHi > scoreHi) {
        scoreHi = oldScoreHi - scoreDecreaseRate;
      }
      
      // global volume, high-pitched tones are more important
      float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
      
      // display the animation, going through each and every available frequency
      int bandValue, w = max(1, int(width / nbBands));
      for(int i = 0; i < nbBands; i++){
        bandValue = dataArray[i] * volumeFx * 4;
        pg.fill(255, 20 + bandValue);
        pg.stroke(255, 80 + bandValue);
        pg.rect(i*w, height/2-bandValue, w, bandValue);
      }
    }

    pg.fill(255, map(volumeFx, 0, .3, 0, 120), 120);
    pg.rect(0, height/2, map(volumeFx, 0, 1, 0, width), 90);
    image(pg, 0, 0);
  }
}

