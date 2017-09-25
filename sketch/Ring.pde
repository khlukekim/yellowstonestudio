
class Ring{
  public float innerR;
  public float outerR;
  public float x;
  public float y;
  int noPies = 100;//at least 10 pies;
  float anglePie = 2*PI/noPies; //angle of each pie
  public Point[] innerPoints;
  public Point[] outerPoints;
  float innerRMod = 1;
  float outerRMod = 1;
  float noiseX = 0;
  float noiseY = 0;
  float noiseZ = 0;
  float outerNoise = 0;
  float targetAlpha = 1;
  public boolean useOuterNoise = true;
  public float noiseIncrement = 0.025;
  float circleAngleOffset = 0;
  float circleAngularSpeed = 0;
  float textureAngleOffset = 0;
  float textureAngularSpeed = 0;
  float alpha = 1;
  boolean useFillColor = true;
  color fillColor = #ff9940;
  color[] fillColors;
  boolean drawSeparate = true;
  boolean connectWholeCircle = true;
  boolean wiggleInside = false;

public Ring(float innerR, float outerR, float x, float y){
  this.innerR = innerR;
  this.outerR = outerR;
  this.x = x;
  this.y = y;
  this.noiseZ = innerR;
  innerPoints = new Point[noPies];
  outerPoints = new Point[noPies];
  fillColors = new color[noPies];
  for(int i = 0; i<noPies; i++){
    innerPoints[i] = new Point();
    outerPoints[i] = new Point();
    fillColors[i] = fillColor;
  }
  calculateControlPoints();

  remapTexture();
}

public void print(){
  for(int i = 0; i<noPies; i++){
    println(i + " " + innerPoints[i].x + ", " + innerPoints[i].y);
  }
}
public void update(){
  fade();
  textureAngleOffset += textureAngularSpeed;
  remapTexture();
  updateControlPoints();
}

public void updateControlPoints(){
  //wiggle();
  calculateControlPoints();
}

void remapTexture(){
  float angle = textureAngleOffset;
  for(int i = 0; i<noPies; i++){
    innerPoints[i].setOriginRTheta(innerR-1, angle);
    outerPoints[i].setOriginRTheta(outerR-1, angle);
    angle+=anglePie;
  }
}

void calculateControlPoints(){
  float angle = textureAngleOffset;
  for(int i = 0; i<noPies; i++){
    innerPoints[i].setRTheta(innerR*innerRMod*(1/*-noise(angle, noiseY,noiseZ)/20*/), angle);
    if(useOuterNoise){
      outerPoints[i].setRTheta((0.9+pow(1000,outerRMod-1)*0.1/**noise(outerNoise, i*1)*/)*outerR*outerRMod, angle);
    }else{
      outerPoints[i].setRTheta(outerR*outerRMod, angle);
    }
    angle+=anglePie;
  }
  outerNoise+=0.03;
}



public void modifyInnerR(float mod){

  innerRMod = interpolate(innerRMod,1+(outerR-innerR)*mod/100,0.25);
}

public void modifyOuterR(float mod){
  outerRMod = interpolate(outerRMod,1+(outerR-innerR)*mod/100,0.25);
}

public float interpolate(float original, float target, float originalToTargetRatio){
  return original*(1-originalToTargetRatio)+target*originalToTargetRatio;
}

public void wiggle(){
  noiseY+=noiseIncrement;
}

public void modifyTextureAngleOffset(float mod){
  textureAngleOffset+=mod;
}

public void fade(){
   alpha = 0.95 * alpha + 0.05 *targetAlpha;
}

public void randomizeColor(){
  for(int i = 0; i<noPies; ){
    float modifier = 0.1;
    color c = color(hue(this.fillColor)+modifier*(noise(i)-0.5), saturation(this.fillColor)+modifier*(noise(i+1)-0.5), brightness(this.fillColor)+modifier*(noise(i+2)-0.5));
    for(int j = 0; j<10; j++){
      fillColors[i] = c;
      i++;
    }
  }
}
}