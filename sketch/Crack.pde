

class Crack{
  float[] t = new float[1000];
  float k = 9;
  PApplet pa;

  public void init(PApplet pa) {
    this.pa = pa;
  }

  public void draw(){
    pa.pushStyle();
    pa.pushMatrix();
    pa.noFill();
    begin(50*abs(cos(k)) +100, 50*abs(sin(k)) +100, 12);
    k = k + PI/128;
    pa.popStyle();
    pa.popMatrix();
  }

  void begin(float R, float r, float n){
    pa.strokeWeight(5);
    pa.stroke(1);
    pa.translate(width/2, height/2);
    for (int i = 0; i <= n; i= i+1) {
      t[i] = 2*i*PI/n-PI/4;
      if (i % 2 == 0) {
        pa.arc(0, 0, 2*R, 2*R, t[i], t[i+1]);
      } else {
        pa.arc(0, 0, 2*r, 2*r, t[i], t[i+1]);
      }
    }
  }
}