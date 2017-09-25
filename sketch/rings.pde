
/*
import SimpleOpenNI.*;

import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
*/


/* @pjs preload="star.jpg" */

boolean showDebugInfoOnScreen = false;

//SimpleOpenNI  context;
color[]       userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };
PVector com = new PVector();
PVector com2d = new PVector();

//audio
//Minim minim;
//FFT fft;
//AudioPlayer song;
//AudioInput song;
//BeatDetect beat;

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
  size(500, 500, P2D);
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

  //minim = new Minim(this);
  //song = minim.loadFile("song.mp3");
  //song = minim.getLineIn();
  //beat = new BeatDetect();
  //beat.detectMode(BeatDetect.FREQ_ENERGY);


  //song.play();
  //fft = new FFT(song.bufferSize(), song.sampleRate());
  //println(fft.specSize());

  lastTimeStamp=millis();

/*

  //kinect settings
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!");
     exit();
     return;
  }
    // enable depthMap generation
  context.enableDepth();

  // enable skeleton generation for all joints
  context.enableUser();
*/

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
  //processBeat();
  fill(0, 0.07);
  tint(1, 0.07);
  image(img, 0,0, width, height);
  noTint();
  rect(0,0,width, height);

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
    drawZap();
  } else if (currentMode == 11) {
    drawRossette();
  }else if (currentMode == 12) {
    drawCrack();
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
   float level = 0;
    for(int j = 0; j<bandsPerRing; j++){
      level+=fft.getBand(i*bandsPerRing+j);
    }

    if(useBeat){
      mod = onAnyBeat?5:1;
    }else{
      mod = 10*(log(level)-2);
    }
    mod=mod<0?0:mod*ringSizeModifier;
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


  if(showDebugInfoOnScreen) {
    drawKinect();
  }
}

void drawKinect() {
  context.update();

  // draw depthImageMap
  image(context.depthImage(),0, 0, 80, 60);
  //image(context.userImage(),0,0);

  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    {
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      drawSkeleton(userList[i]);
    }

  }
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{


  PVector posLeftShoulder = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,posLeftShoulder);
  //context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_ELBOW,jointPos);
  PVector posLeftHand = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,posLeftHand);
  PVector posRightShoulder = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,posRightShoulder);
  //context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,jointPos);
  PVector posRightHand = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,posRightHand);
  PVector posTorso = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_TORSO,posTorso);

  updateHandPosition(posLeftHand, posRightHand, posLeftShoulder, posRightShoulder, posTorso);


  if (showDebugInfoOnScreen) {
    pushStyle();
    fill(color(255, 255, 255));
    text("angle: " + thetaBetween, 0, 60);
    text("hands put up by: " + lengthLeftHandPutUp, 0, 80);
    text("hands put up by: " + lengthRightHandPutUp, 0, 100);
    text("hands swoosh by: " + lengthHandsSwoosh, 0, 120);
    text("jumped by: " + lengthTorsoJump, 0, 140);
    popStyle();
  }
  //float theta = acos((ax*bx + ay*by) / sqrt((ax*ax + ay*ay)*(bx*bx+by*by)));
  //println(theta);

  //context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
/*
  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
*/
 // context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
 // context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
 // context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

 // context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
 // context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
 // context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
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


int lengthLeftHandPutUp = 0;
int lengthRightHandPutUp = 0;
float lastLeftHandAngle = 0;
float lastRightHandAngle = 0;
int lengthHandsSwoosh = 0;
float lastTorsoY = 0;
float lastTorsoX = 0;
int lengthTorsoMove = 0;
int lengthTorsoJump = 0;
void updateHandPosition(PVector leftHand, PVector rightHand, PVector leftShoulder, PVector rightShoulder, PVector torso) {
  if (leftHand.y > leftShoulder.y -30 ) {
    lengthLeftHandPutUp += 1;
  } else {
    lengthLeftHandPutUp = 0;
  }
  if (rightHand.y > rightShoulder.y - 30) {
    lengthRightHandPutUp += 1;
  }else {
    lengthRightHandPutUp = 0;
  }


  if (abs(lastTorsoY - torso.y) > 5) {
    lengthTorsoJump += 1;

    ringSizeModifier  = 0.05 * (1+lengthTorsoJump / 20);
    particleSpeed = min(width, height) / 1000 * (1+lengthTorsoJump / 20);
    particleRadius = 160 + 10 * (lengthTorsoJump / 10);;
    for(int i = 0; i<particleNum; i++){
      particles[i].setSpeed(particleSpeed);
    }

  } else {
    lengthTorsoJump -= 1;
    if (lengthTorsoJump < 0) {
      lengthTorsoJump = 0;
    }
  }

  if (abs(lastTorsoX - torso.x) > 10) {
    lengthTorsoMove += 1;
  } else {
    lengthTorsoMove = 0;
  }

  lastTorsoX = torso.x;

  lastTorsoY = torso.y;

  float ax = (torso.x - leftHand.x);
  float ay = (torso.y - leftHand.y);
  float bx = (torso.x - rightHand.x);
  float by = (torso.y - rightHand.y);
  float thetaLeft = atan2(ay, ax);
  thetaLeft += PI/2;
  if (thetaLeft < 0) {
    thetaLeft += 2*PI;
  }
  float thetaRight = atan2(by, bx);
  thetaRight += PI/2;
  if (thetaRight < 0) {
    thetaRight += 2*PI;
  }

  if (abs(thetaLeft-lastLeftHandAngle) > 0.1 || abs(thetaRight - lastRightHandAngle) > 0.1) {
    lengthHandsSwoosh += 1;
  } else {
    lengthHandsSwoosh = 0;
  }

  lastLeftHandAngle = thetaLeft;
  lastRightHandAngle = thetaRight;

  thetaBetween = thetaRight - thetaLeft;
  if (thetaBetween < 0) {
    thetaBetween += 2*PI;
  }
  thetaBetween *= 360/2/PI;

  if (lengthHandsSwoosh >= 10) {
    //if (currentMode == 2) {
        changeMode(12);
    //}
  } else if (lengthLeftHandPutUp >= 10) {
    //if (currentMode == 1) {
      changeMode(3);
      lengthLeftHandPutUp = 0;
    //}
  }
  else if (lengthRightHandPutUp >= 10) {
      changeMode(10);
      lengthRightHandPutUp = 0;
  }else if (lengthTorsoJump > 20 /*&& currentMode == 3*/) {
    changeMode(11);
  }else if (lengthTorsoMove > 10) {
    changeMode(4);
  } else {
    return;
  }

  lengthHandsSwoosh = 0;
  lengthLeftHandPutUp = 0;
  lengthRightHandPutUp =0;
  lengthTorsoJump = 0;
  lengthTorsoMove = 0;
}

void keyPressed(){

  if(key==49){
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

void drawZap() {
  zap.draw();
}

Rossette rossette;
void initRossette() {
  rossette = new Rossette();
  rossette.init(this);
}

void drawRossette() {
  rossette.draw();
}

Crack crack;
void initCrack() {
  crack = new Crack();
  crack.init(this);
}

void drawCrack() {
  crack.draw();
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