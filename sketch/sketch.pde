

/* @pjs preload="single_cover_website2.jpg" */
float lastTimeStamp = 0;
boolean showDebugInfoOnScreen = false;

AudioManager audioManager;

Sun sun;

void setup(){
  frameRate(30);
  audioManager = new AudioManager();
  audioManager.init(false, false, false, this);
  size(screen.width, screen.height, P2D);

  sun = new Sun();
  background(0);
  colorMode(HSB, 1);
}

void draw(){
  float level = audioManager.getLevel();
  if (showDebugInfoOnScreen) {
    drawFPS();
  }
  sun.draw();
}

void drawFPS(){
  float time = millis();
  float fps = 1000/(time-lastTimeStamp);
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
  }else if(key==112) {
    showDebugInfoOnScreen = !showDebugInfoOnScreen;
  }
}

////// javascript functions

interface JavaScript {
  void fullScreen();
  float getMeter();
}

void bindJavaScript(JavaScript js) {
  javascript = js;
}

public JavaScript javascript;







