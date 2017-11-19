
/* @pjs preload="single_cover_website2.jpg" */
float lastTimeStamp = 0;
boolean showDebugInfoOnScreen = false;

AnimationManager animMgr;


final char SIMPLE_FREQ_MODE = '0';
final char SUN_MODE = '1';
final char RENAME_ME_MODE = '2';
final char HAIRY_MODE = '3';
final char[] modes = {SUN_MODE, SIMPLE_FREQ_MODE, RENAME_ME_MODE, HAIRY_MODE};

char currentMode = HAIRY_MODE;
char changeToMode = null;//used to synchronise the keyboard input with the display() call


// frequencies data array
int[] dataArray;
// main volume
float volume;
float prevVolume;
float volumeFx;

void setup(){
  frameRate(30);
  // audioManager = new AudioManager();
  // audioManager.init(false, false, false, this);
  size(screen.width, screen.height, P2D);
  noStroke();

  animMgr = new AnimationManager();

  animMgr.setNewMode(true);
  // background(0, 0);//transparent background
}

void draw(){
  // float level = audioManager.getLevel();
  dataArray = getFreqArray();
  prevVolume = volume;
  volume = getMeter();
  float volumeCoeff = volumeFx < volume ? .2 : .05;
  volumeFx += (volume - volumeFx) * volumeCoeff;
    
  if(changeToMode){
    currentMode = changeToMode;
    animMgr.setNewMode(false);
    changeToMode = null;
  }

  animMgr.display();
  
  if (showDebugInfoOnScreen) {
    drawFPS();
  }
}

void drawFPS(){
  float time = millis();
  float fps = 1000/(time-lastTimeStamp);
  fill(1, 0, 0);
  noStroke();
  rect(5, 5, 150, 80);
  stroke(1);
  fill(1);
  textSize(32);
  text("fps: "+int(fps), 10, 30);
  lastTimeStamp = time;
}

void keyPressed(){
  if (key == 32) {
  }else if(key=='f'){
    javascript.fullScreen(); 
  }else if(key=='d') {
    showDebugInfoOnScreen = !showDebugInfoOnScreen;
  }else if(key=='m') {
    toggleMic();
  }

  if (key in modes && key != currentMode){
    changeToMode = key;
  }
}

////// javascript functions
public JavaScript javascript;
interface JavaScript {
  void fullScreen();
  float getMeter();
}

void bindJavaScript(JavaScript js) {
  javascript = js;
}








