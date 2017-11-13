

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
Particle[] particles = new Particle[particleNum];

int currentMode = 3;
float thetaBetween = 0;
float screenBallRatio = 1;

void setup(){
  frameRate(30);
  audioManager = new AudioManager();
  audioManager.init(false, false, false, this);
  size(screen.width, screen.height, P2D);
  //fullScreen(P2D);

  particleSpeed = min(width, height) / 1000;
  for (int i = 0; i<particleNum; i++){
    particles[i] = new Particle();
  }

  img = loadImage("single_cover_website2.jpg");
  ballImage = loadImage("star.jpg");

  ballImageR = ballImage.width / 2;
  screenBallRatio = min(width, height) / 2 / ballImageR * 0.8;

  imageWidth = img.width;
  imageHeight = img.height;

  lastTimeStamp=millis();

  changeMode(currentMode);
}


int lastBeatTime = millis();
int lastVirtualBeatTime = lastBeatTime;
boolean wasOnBeat = false;
boolean onBeat = false;
int lastBeat = 100;
float estimatedBeatToBeat = 470;
boolean onVirtualBeat = false;
boolean onAnyBeat = false;

void processBeat() {
  fft.forward(song.mix);
  beat.detect(song.mix);
  int time = millis();
  boolean onBeat = beat.isRange(18, 26, 5) && lastBeat > 4;
  if (onBeat) {
    int beatDur = time - lastBeatTime;
    float nBeats = round(beatDur / estimatedBeatToBeat);
    if (nBeats > 0) {
      float newBTB = beatDur / nBeats;
      if (newBTB > 450 && newBTB < 510) {
        estimatedBeatToBeat = 0.9*estimatedBeatToBeat + 0.1*newBTB;
      }
    }
    println("Beat: " + beatDur);
    lastBeatTime = time;
    lastVirtualBeatTime = time;
    lastBeat = 0;
  }else {
    if(time - lastVirtualBeatTime > estimatedBeatToBeat) {
      println("Virtual Beat: " + (time - lastVirtualBeatTime));
      lastVirtualBeatTime = time;
      onVirtualBeat = true;
    }else{
      onVirtualBeat = false;
    }

    lastBeat += 1;
  }

  onAnyBeat = onBeat || onVirtualBeat;

}

void draw(){
  rect(0, 0, 222, 222);
  float level = audioManager.getLevel();
  if (showDebugInfoOnScreen) {
    drawFPS();
  }
  //processBeat();
  fill(0, 0.07);
  rect(0,0,width, height);

  //background(0, 0);

  if (currentMode == 7 ) {
    drawRevRings();
  } else if (currentMode == 8) {
    drawLightening();
  } else if (currentMode == 9) {
    if(onAnyBeat){
      disco.randomizeColor();
    }
    drawDisco();
  } else if (currentMode == 10) {
    drawZap(level);
  } else if (currentMode == 11) {
    drawRossette(level);
  }else if (currentMode == 12) {
    drawCrack(level);
  } else if (currentMode == 13) {
    drawSpark();
  } else if (currentMode == 14) {
    drawDream();
  } else if (currentMode == 4) {
    largerPulse(0.001);
  }

  float mod;
  if(moveRingColor){
    if (onAnyBeat) {
      ringColorOffset += 1;
    }
    setColor(c1, c2, rings);
  }
  for(int i = 0; i<noRings; i++){
    if(useBeat){
      mod = onAnyBeat?5:1;
    }else{
      mod = 10*(log(level)-2);
    }
    mod=mod<0?0:mod*ringSizeModifier;

    mod = 1 + level;
    rings[i].modifyOuterR(mod);
    rings[i].modifyInnerR(mod);
    rings[i].update();
    drawARing(rings[i]);
  }
  if(drawParticles){

    loadPixels();
    for (int i = 0; i<particleNum; i++){
      particles[i].run();
    }
    updatePixels();
  }


  if(false) {
    drawKinect();
  }
}

void drawARing(Ring ring){
  noStroke();
  for (int i = 0; i < ring.noPies; i++) {
    beginShape(QUADS);
    fill(ring.fillColors[i],ring.alpha);

    int j = i+1;

    if (j >= ring.noPies) {
      if (!ring.connectWholeCircle) {
        break;
      }
      j = 0;
    }
    vertex(ring.x+ring.outerPoints[i].x, ring.y+ring.outerPoints[i].y);//, ballImage.width/2+ring.outerPoints[i].originX/screenBallRatio, ballImage.height/2+ring.outerPoints[i].originY/screenBallRatio);
    vertex(ring.x+ring.outerPoints[j].x, ring.y+ring.outerPoints[j].y);//, ballImage.width/2+ring.outerPoints[j].originX/screenBallRatio, ballImage.height/2+ring.outerPoints[j].originY/screenBallRatio);
    vertex(ring.x+ring.innerPoints[j].x, ring.y+ring.innerPoints[j].y);//, ballImage.width/2+ring.innerPoints[j].originX/screenBallRatio, ballImage.height/2+ring.innerPoints[j].originY/screenBallRatio);
    vertex(ring.x+ring.innerPoints[i].x, ring.y+ring.innerPoints[i].y);//, ballImage.width/2+ring.innerPoints[i].originX/screenBallRatio, ballImage.height/2+ring.innerPoints[i].originY/screenBallRatio);
    endShape();
  }
}

void initRings(){
  if (noRings > 0) {

    //bandsPerRing = fft.specSize()/noRings;
    colorMode(HSB, 1);

    rings = new Ring[noRings];
    float shorterSide = min(height, width);
    float ringThickness = shorterSide*0.3/noRings;
    ballImageRatio = ballImageR / shorterSide*0.3;
    for(int i = 0; i<noRings; i++){
      rings[i] = new Ring(ringThickness*(i)+1, ringThickness*(i+1)-4, width/2, height/2);
      rings[i].useFillColor = useFillColor;
    }
    setColor(c1, c2, rings);
  } else {
    rings = null;
  }
}

void setColor(color c1, color c2, Ring[] rings){
  if (rings != null) {
    for(int i=0; i<rings.length; i++){
      rings[noRings-i-1].fillColor = lerpColor(c1, c2, 1.*((i+ringColorOffset)%noRings)/(rings.length-1));
      rings[noRings-i-1].randomizeColor();
    }
  }
}

void drawFPS(){
  float time = millis();
  float fps = 1000/(time-lastTimeStamp);
  stroke(1);
  fill(1);
  textSize(32);
  text("fps: "+fps, 10,30);
  lastTimeStamp = time;
}

void keyPressed(){
  if (key == 32) {
    javascript.fullScreen();
  }else if(key==49){
    changeMode(3);
  }else if(key==50){
    changeMode(10);
  }else if(key==51){
    changeMode(11);
  }else if(key==52){
    changeMode(12);
  }else if(key==int("5")){
    changeMode(4);
  }else if(key==int("6")){
    changeMode(2);
  }else if(key=='7'){
    changeMode(7);
  }else if(key=='8'){
    changeMode(8);
  }else if(key=='9'){
    changeMode(9);
  }else if(key=='0'){
    changeMode(1);
  }else if(key=='q'){
    changeMode(2);
  }else if(key=='w'){
    changeMode(6);
  }else if(key=='e'){
    changeMode(13);
  }else if(key=='r'){
    changeMode(14);
  }else if(key=='x'){
    largerPulse(1);
  }else if(key=='s'){
    smallerPulse(1);
  }else if(key=='z'){
    particleRadius = 160;
    for(int i = 0; i<particleNum; i++){
      particles[i].setSpeed(0.3);
      particles[i].relocate();
    }
  }else if (key == 'a') {
    changeMode(5);
  }else if(key==112) {
    showDebugInfoOnScreen = !showDebugInfoOnScreen;
  }
}

void largerPulse(float m) {
    ringSizeModifier += 0.1 * m;
    particleSpeed +=0.2 * m;
    particleRadius += 10 * m;
    for(int i = 0; i<particleNum; i++){
      particles[i].setSpeed(particleSpeed);
    }
}

void smallerPulse(float m) {
    ringSizeModifier -= 0.1 * m;
    particleSpeed -=0.2 * m;
    particleRadius -= 10 * m;
    for(int i = 0; i<particleNum; i++){
      particles[i].setSpeed(particleSpeed);
    }
}

OlympicRings[] oRings;

Lightening lightening;

void initLightening() {
  lightening = new Lightening();
  lightening.init();
}

void drawLightening() {
  lightening.draw(this);
}

Disco disco;

void initDisco() {
  disco = new Disco();
  disco.init();
}

void drawDisco() {
  disco.draw(this);
}

Zap zap;
void initZap() {
  zap = new Zap();
  zap.init(this);
}

void drawZap(float level) {
  zap.draw(level);
}

Rossette rossette;
void initRossette() {
  rossette = new Rossette();
  rossette.init(this);
}

void drawRossette(float level) {
  rossette.draw(level);
}

Crack crack;
void initCrack() {
  crack = new Crack();
  crack.init(this);
}

void drawCrack(float level) {
  crack.draw(level);
}

Spark spark;
void initSpark() {
  spark = new Spark();
  spark.init(this);
}

void drawSpark() {
  spark.draw();
}

Dream dream;
void initDream() {
  dream = new Dream();
  dream.init(this);
}

void drawDream() {
  dream.draw();
}

OlympicRings revRings;

void initRevRings() {

}

void drawRevRings() {

}

void changeMode(int newMode) {
  fill(1, 1);
  tint(1, 1);

  currentMode = newMode;
  if(newMode==1){
    drawParticles = false;
    useBeat = true;
    noRings = 1;
    initRings();
    rings[0].wiggleInside = true;
    tintColor = false;
    moveRingColor = false;
  }else if(newMode==2){
    drawParticles = false;
    useBeat = false;
    noRings = 10;
    tintColor = true;
    moveRingColor = false;
    initRings();
    for(int ringNumber = 0; ringNumber<noRings; ringNumber++){
      rings[ringNumber].useOuterNoise = false;
      rings[ringNumber].useFillColor = true;
      rings[ringNumber].alpha = 0.1;
    }
    for(int ringNumber = 0; ringNumber<noRings; ringNumber+=2){
      rings[ringNumber].targetAlpha = 0;
    }
  }else if(newMode==3){
    drawParticles = false;
    useBeat = false;
    noRings = 10;
    tintColor = true;
    moveRingColor = true;
    initRings();
    for(int i = 0; i<rings.length; i++){
      rings[i].useFillColor = true;
      rings[i].useOuterNoise = false;
      rings[i].textureAngularSpeed =random(0.020)-0.01;
      rings[i].alpha = 1;
    }

  }else if(newMode==4){
    drawParticles = true;
    useBeat = false;
    noRings = 10;
    tintColor = true;
    moveRingColor = false;
    initRings();
    ringColorOffset = 0;
    setColor(#994466, #602030, rings);

    for(int ringNumber = 0; ringNumber<noRings; ringNumber++){
      rings[ringNumber].useOuterNoise = false;
      rings[ringNumber].useFillColor = true;
      rings[ringNumber].alpha = 0;
    }

    float shorterSide = min(height, width);
    particleRadius = shorterSide * 0.3;
    particleSpeed = min(width, height) / 1000;
    for(int i = 0; i<particleNum; i++){
      particles[i].setSpeed(particleSpeed);
      particles[i].relocate();
    }

  }else if(newMode==5){
    for(int ringNumber = 0; ringNumber<noRings; ringNumber++){
      rings[ringNumber].targetAlpha = 0;
    }
    particleRadius = max(height, width);
    particleSpeed = min(width, height) / 100;
    for(int i = 0; i<particleNum; i++){
      particles[i].setSpeed(particleSpeed);
    }
  }else if(newMode==6){
    drawParticles = false;
    useBeat = false;
    noRings = 10;
    tintColor = true;
    moveRingColor = false;
    initRings();

    for(int ringNumber = 0; ringNumber<noRings; ringNumber++){
      rings[ringNumber].useOuterNoise = false;
      rings[ringNumber].useFillColor = true;
      rings[ringNumber].alpha = 0.1;
      rings[ringNumber].noPies -= 8;
      rings[ringNumber].connectWholeCircle = false;
      rings[ringNumber].textureAngularSpeed =0.01;
    }
  }else if(newMode==7){
    clearObjects();
    initRevRings();
  }else if (newMode == 8) {
    clearObjects();
    initLightening();
  }else if (newMode == 9) {
    clearObjects();
    initDisco();
  }else if (newMode == 10) {
    clearObjects();
    initZap();
  }else if (newMode == 11) {
    clearObjects();
    initRossette();
  }else if (newMode == 12) {
    clearObjects();
    initCrack();
  }else if (newMode == 13) {
    clearObjects();
    initSpark();
  }else if (newMode == 14) {
    clearObjects();
    initDream();
  }
}

void clearObjects() {
   drawParticles = false;
    noRings = 0;
    rings = null;
    revRings = null;
    lightening = null;
    disco = null;
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