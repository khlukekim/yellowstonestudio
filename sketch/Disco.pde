class Disco{
  color[] colors;
  float d = 0.2;
  int l = int((PI/d+1)*(PI/d+1));
  float radius = 200;
  int randomCounter = 0;
  float rOffset = 0;

  void init() {
    randomizeColor();
  }

  void randomizeColor() {
    colors = new color[l];
    for(int i = 0; i<l; i++){
      colors[i] = color(random(1), random(0.3, 0.7), random(0, 1));
    }
  }

  void changeColor() {

  }

  void draw(PApplet pa) {
    //background(0);
    noStroke();
    int k = 0;
    for(float rd = 0; rd<PI+d; rd+=d) {
      float r = (rd + rOffset) % PI;
      for (float t = -PI/2; t<PI/2; t+=d) {
        fill(colors[k]);
        k++;
        quad(width/2 + radius*cos(t)*cos(r), height/2 + radius*sin(t),
             width/2 + radius*cos(t+d)*cos(r), height/2 + radius*sin(t+d),
             width/2 + radius*cos(t+d)*cos(r+d), height/2 + radius*sin(t+d),
             width/2 + radius*cos(t)*cos(r+d), height/2 + radius*sin(t));
      }
    }
    rOffset = (rOffset + 0.02) % PI;
  }
}