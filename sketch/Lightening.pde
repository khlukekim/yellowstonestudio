class Lightening {
  int separateNum = 2;
  int lineNum   = 2;
  int thunderNum   = 2;

  float h = 100;
  float s = 100;
  float b = 100;

  ArrayList<ArrayList<Separater>> separater;
  float startLeftX  = -200;
  float startRightX = 200;
  float roll = 0;

  public void init() {

    pushMatrix();
    translate(width/2, height/2);
    separater = new ArrayList<ArrayList<Separater>>();
    for (int j=0; j<thunderNum; j++) {
      separater.add( new ArrayList<Separater>() );
      for (int i=0; i<lineNum; i++) {
        separater.get(j).add( new Separater(startLeftX, startRightX, 0) );
      }
    }
    popMatrix();
  }

  public void draw(PApplet pa) {
    pa.pushStyle();
    roll += 0.01;
    pa.colorMode(HSB, 359, 100, 100);
    h += 0.2;
    pa.fill(h%359, s, b);
    pa.stroke(h%359, s, b);
    for (int j=0; j<thunderNum; j++) {
      for (int i=0; i<lineNum; i++) {
        pa.pushMatrix();
        pa.translate(width/2, height/2);
        pa.rotate(roll + j*PI/thunderNum);

        float leftY  = 0;
        float rightY = 0;

        pa.strokeWeight(5);
        separater.get(j).get(i).display(leftY, rightY);
        pa.popMatrix();
      }
    }

    pa.strokeWeight(2);
    pa.noFill();
    pa.ellipse(width/2, height/2, 400, 400);

    pa.popStyle();
  }

  class Separater {
    int id;
    int count = 0;
    Separater[] childSeparater;

    float leftX, leftY, rightX, rightY;
    float yRange;
    float halfPointX, halfPointY;
    float y, vy;

    Separater(float _leftX, float _rightX, int _id) {
      this.id = _id;
      if (this.id>separateNum) return;
      this.leftX = _leftX;
      this.rightX = _rightX;
      this.halfPointX = (_leftX+_rightX)/2;

      childSeparater = new Separater[2];

      this.childSeparater[0]
        = new Separater(this.leftX, this.halfPointX, id+1);
      this.childSeparater[1]
        = new Separater(this.halfPointX, this.rightX, id+1);
      y  = random(20, 30);
      vy = random(0.1, 0.15);
    }

    void display(float _leftY, float _rightY) {
      if (this.id>separateNum) return;

      this.leftY = _leftY;
      this.rightY = _rightY;
      y += vy;

      yRange = (leftY + rightY)/2 + 10;
      this.halfPointY = yRange * sin(y) + 50*sin(y);

      if (this.id==separateNum) {
        strokeWeight(2);
        line(this.leftX, this.leftY, this.halfPointX, this.halfPointY);
        line(this.halfPointX, this.halfPointY, this.rightX, this.rightY);
        strokeWeight(5);
      }
      childSeparater[0].display(leftY, this.halfPointY);
      childSeparater[1].display(this.halfPointY, rightY);
    }
  }
}