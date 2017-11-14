
/* @pjs preload="single_cover_website2.jpg" */
float lastTimeStamp = 0;
boolean showDebugInfoOnScreen = false;

AnimationBase currentAnimation;

int[] dataArray;

final char SUN_MODE = '0';
final char SIMPLE_FREQ_MODE = '1';
char currentMode = SUN_MODE;

final char[] modes = {SUN_MODE, SIMPLE_FREQ_MODE};

void setup(){
  frameRate(30);
  // audioManager = new AudioManager();
  // audioManager.init(false, false, false, this);
  size(screen.width, screen.height, P2D);

  setNewMode();
  background(0, 0);//transparent background
}

void draw(){
  // float level = audioManager.getLevel();
  dataArray = getDataArray();
  currentAnimation.display();

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
  }

  if (key in modes && key != currentMode){
    currentMode = key;
    setNewMode();
  }
}

void setNewMode(){
  background(0);//clean previous animation
  background(0, 0);//show background image
  console.log("set new mode: " + currentMode);
  if(currentMode == SUN_MODE) {
    currentAnimation = new Sun();
  }else if(currentMode == SIMPLE_FREQ_MODE){
    currentAnimation = new SimpleFreqAnalyzer();
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








