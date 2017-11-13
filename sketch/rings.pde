

/* @pjs preload="star.jpg" */

boolean showDebugInfoOnScreen = false;

color[]       userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };
PVector com = new PVector();
PVector com2d = new PVector();

AudioManager audioManager;

//background image
PImage img;
//ball image
PImage ballImage;
int ballImageR;
float ballImageRatio;


float imageWidth;
float imageHeight;
float lastTimeStamp;
float ringSizeModifier = 0.03;
float particleSpeed = 0.3;
// graphics
Ring[] rings;
int noRings = 1; // howmany rings will be used?
int bandsPerRing;
float ringColorOffset = 0;
int ringColorOffsetCounter = 0;
boolean moveRingColor = false;
boolean drawParticles = false;
boolean useBeat = true;

// set to true to turn on gradient color
boolean useFillColor = true;
boolean tintColor = false;
// gradient colors; from the inside out
color c1 = #203070;
color c2 = #dde050;

int particleNum = 5000;
float particleRadius = 0;

int currentMode = 3;
float thetaBetween = 0;
float screenBallRatio = 1;

Sun sun;

void setup(){
  frameRate(30);
  audioManager = new AudioManager();
  audioManager.init(false, false, false, this);
  size(screen.width, screen.height, P2D);
  //fullScreen(P2D);

  sun = new Sun();

  colorMode(HSB, 1);

  img = loadImage("single_cover_website2.jpg");
  ballImage = loadImage("star.jpg");

  ballImageR = ballImage.width / 2;
  screenBallRatio = min(width, height) / 2 / ballImageR * 0.8;

  imageWidth = img.width;
  imageHeight = img.height;

  lastTimeStamp = millis();
}


int lastBeatTime = millis();
int lastVirtualBeatTime = lastBeatTime;
boolean wasOnBeat = false;
boolean onBeat = false;
int lastBeat = 100;
float estimatedBeatToBeat = 470;
boolean onVirtualBeat = false;
boolean onAnyBeat = false;

void draw(){
  rect(0, 0, 222, 222);
  float level = audioManager.getLevel();
  if (showDebugInfoOnScreen) {
    drawFPS();
  }
  fill(0, 0.07);
  rect(0,0,width, height);

  if (currentMode == 0 ) {
  } 

  sun.draw();
}

void drawFPS(){
  float time = millis();
  float fps = 1000/(time-lastTimeStamp);
  stroke(1);
  fill(1);
  textSize(32);
  text("fps: "+fps, 10, 30);
  lastTimeStamp = time;
}

void keyPressed(){
  if (key == 32) {
    javascript.fullScreen();
  }else if(key==49){
   
  }else if(key=='z'){
    
  }else if (key == 'a') {
    
  }else if(key==112) {
    showDebugInfoOnScreen = !showDebugInfoOnScreen;
  }
}

void clearObjects() {

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