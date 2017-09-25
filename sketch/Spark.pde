public class Spark {
  float x, y, x1, y1, x2, y2, sparkx, sparky;
  PApplet pa;

  void init(PApplet pa) {
    this.pa = pa;
    x = width/2;
    y = height/2;
  }

  void draw() {
    pa.pushStyle();
    for (int i = 0; i < 10; i++) {
      pa.stroke(1, 0.5);
      float theta = random(1.95*PI);
      float rad = random (35, 170);
      x1 = x + sin(theta)*rad;
      y1 = y + cos(theta)*rad;
      pa.line(x, y, x1, y1);

      for (int j = 0; j < 5; j++) {
        pa.stroke(1, 0.7, 1);
        x2 = random(-2, 2);
        y2 = random(-2, 2);
        pa.line(x1, y1, x1 + x2, y1 + y2);
      }
    }
    pa.popStyle();
  }
}