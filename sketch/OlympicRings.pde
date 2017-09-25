class OlympicRings implements Drawable{

  OlympicRing[] rings;
  int nRings = 6;

  public OlympicRings() {

  }

  public void setup() {
    rings = new OlympicRing[nRings];
    rings[0] = new OlympicRing(new Point(width/2, height/2), 100, color(1, 0.5, 1), 240, 16, 0.1);
    rings[1] = new OlympicRing(new Point(width/2, height/2), 120, color(0.7, 0.5, 1), 220, 16, 0.08);
    rings[2] = new OlympicRing(new Point(width/2, height/2), 80, color(0.4, 0.5, 1), 240, 16, 0.05);
    rings[3] = new OlympicRing(new Point(width/2, height/2), 100, color(0.1, 0.5, 1), 200, 16, 0.03);
    rings[4] = new OlympicRing(new Point(width/2, height/2), 150, color(0.3, 0.5, 1), 200, 16, 0.12);
    rings[5] = new OlympicRing(new Point(width/2, height/2), 160, color(0.8, 0.4, 1), 220, 16, 0.13);
  }

  public void draw(PApplet pa) {
    for(int i = 0; i<nRings; i++) {
      rings[i].draw(pa);
    }
  }

  public void process() {
    for(int i = 0; i<nRings; i++) {
      rings[i].process();
    }
  }

}

class OlympicRing implements Drawable{
  Point coc;
  float rCenter;
  color ringColor;
  float radius;
  float theta;
  float thickness;
  float angularSpeed;

  public OlympicRing(Point coc, float rCenter, color ringColor, float radius, float thickness, float angularSpeed) {
    this.coc = coc;
    this.rCenter = rCenter;
    this.ringColor = ringColor;
    this.radius = radius;
    this.thickness = thickness;
    this.angularSpeed = angularSpeed;
  }

  public void setup() {
    theta = 0;
  }

  public void draw(PApplet pa) {
    pa.pushStyle();
    pa.noFill();
    pa.stroke(ringColor);
    pa.strokeWeight(thickness);

    pa.ellipse(coc.x + rCenter * cos(theta), coc.y + rCenter * sin(theta), radius, radius);
    pa.popStyle();
  }

  public void process() {
    theta = theta + angularSpeed;
  }
}