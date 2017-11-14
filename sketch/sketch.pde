

/* @pjs preload="single_cover_website2.jpg" */
float lastTimeStamp = 0;
boolean showDebugInfoOnScreen = false;

AudioManager audioManager;
AnimationBase currentAnimation;


void setup(){
  frameRate(30);
  audioManager = new AudioManager();
  audioManager.init(false, false, false, this);
  size(screen.width, screen.height, P2D);

  currentAnimation = new Sun();
  background(0, 0);//transparent background
  colorMode(HSB, 1);
}

void draw(){
  float level = audioManager.getLevel();
  if (showDebugInfoOnScreen) {
    drawFPS();
  }
  audioManager.getLevel();
  currentAnimation.display();
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
    javascript.fullScreen();   
  }else if(key=='f'){
    javascript.fullScreen(); 
  }else if(key=='d') {
    showDebugInfoOnScreen = !showDebugInfoOnScreen;
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








