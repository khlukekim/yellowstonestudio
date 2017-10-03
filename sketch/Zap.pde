public class Zap {

  ArrayList<Crystal> crystals;
  float maxPower = 100;
  int maxCrystals = 10;
  float maxRingRad;
  PApplet pa;
  float accumulatedPower = 0;

  public void init(PApplet pa) {
    this.pa = pa;
    crystals = new ArrayList<Crystal>();
    maxRingRad = min(height,width) * 0.2;
    crystals.add(new Crystal(width/2 , height/2));
    for(int i = 0; i < 10; i++)
      crystals.add(new Crystal(width/2 + width/5 * random(-1,1), height/2 - height/5 * random(-1,1)));
  }

  public void draw(float level) {
    accumulatedPower += level;

    zaps();

    ArrayList<Crystal> trash = new ArrayList<Crystal>();

    for (Crystal c : crystals) {
      c.move();
      c.draw();
      if (c.removable)
        trash.add(c);
    }

    for (Crystal c : trash)
      crystals.remove(c);

    if (accumulatedPower > 40) {
      accumulatedPower -= 40;
      if (crystals.size() > 0) {
        crystals.remove(crystals.get(0));
      }
    }

    while (crystals.size() < maxCrystals) {
      crystals.add(new Crystal(width/2 + width/5 * random(-1,1), height/2 - height/5 * random(-1,1)));
    }

  }


  void zaps() {
  for (Crystal c : crystals)
    for (Crystal c2 : crystals) {
      if (c == c2) continue;
      if (abs(c.loc.x - c2.loc.x) < c.rad*6*(1 + pow(c.power/maxPower - 1, 2))
        && abs(c.loc.y - c2.loc.y) < c.rad*6*(1 + pow(c.power/maxPower - 1, 2))
        ||
        c.bursting
        && abs(c.loc.x - c2.loc.x) < c.ringRad
        && abs(c.loc.y - c2.loc.y) < c.ringRad) {
        doZap(c, c2);
      }
    }
  }


  void doZap(Crystal crystal, Crystal crystal2) {

   PVector start = crystal.loc;
  PVector end = crystal2.loc;
  PVector diff = PVector.sub(end, start);
  float dist = diff.mag();
  diff.normalize();

  diff.mult(((crystal.power - maxPower/2)+(crystal2.power - maxPower/2))/maxPower);

  if (! crystal.bursting)
    crystal.acc.sub(diff);
  crystal.power = min(maxPower + 20, crystal.power+2);
  if (crystal.bursting) {
    crystal2.power += crystal.power/20;
    crystal.power *= 0.95;
  }

  strokeWeight(2);
  float numSteps = 5;
  float lx = start.x;
  float ly = start.y;
  int i = 0;
  while (i < numSteps && abs (lx - end.x) > 10 || abs(ly - end.y) > 10) {
    float x = lx + (end.x - lx) / numSteps  + random(-9, 9);
    float y = ly + (end.y - ly) / numSteps + random(-9, 9);
    stroke(max(0,min(255,hue(crystal.col) + sin(frameCount*0.05)*50)), 360, 360);
    line(lx, ly, x, y);
    lx = x;
    ly = y;
    i++;
  }
  line(lx, ly, end.x, end.y);
  }





  class Crystal {

    PVector loc, speed, acc;
    float rad;
    float power;
    int col;
    float ringRad;
    boolean bursting;
    boolean removable;


    public Crystal(float x, float y) {
      this.loc = new PVector(x, y);
      this.speed = new PVector();
      this.acc = new PVector();
      this.rad = 20;
      this.power = maxPower/2;
      this.ringRad = this.rad;
    }


    void move() {
      this.acc.mult(0.4);
    this.speed.mult(0.95);
    this.speed.add(this.acc);
    this.loc.add(this.speed);

    if (this.loc.x <= 0 + this.rad) {
      this.loc.x = this.rad;
      this.acc.x = abs(this.acc.x);
      this.speed.x = abs(this.speed.x);
    }
    else if (this.loc.x >= width - this.rad) {
      this.loc.x = width - this.rad;
      this.acc.x = -abs(this.acc.x);
      this.speed.x = -abs(this.speed.x);
    }
    if (this.loc.y <= 0 + this.rad) {
      this.loc.y = this.rad;
      this.acc.y = abs(this.acc.y);
      this.speed.y = abs(this.speed.y);
    }
    else if (this.loc.y >= height - this.rad) {
      this.loc.y = height - this.rad;
      this.acc.y = -abs(this.acc.y);
      this.speed.y = -abs(this.speed.y);
    }

    if (this.power > maxPower && ! this.bursting)
      this.bursting = true;
    if (this.bursting) {
      this.ringRad += 5 + abs((maxRingRad-this.ringRad)/maxRingRad*10);
      this.rad = max(5, this.rad*0.95);
      if (this.ringRad > maxRingRad) {
        this.bursting = false;
        this.removable = true;
      }
    }
    else
      this.ringRad = this.rad;

    this.power = max(0, this.power-0.5);

    if (this.power <= 0)
      this.removable = true;
    }


    void draw() {

      float b = max(0, (1 - pow((this.power/maxPower-1), 2)));
      this.col = color(max(0, 1 - this.power/maxPower), 0.7, b);
      pa.noStroke();
      pa.fill(this.col);
      pa.ellipse(this.loc.x, this.loc.y, 2*this.rad, 2*this.rad);
      pa.fill(hue(this.col), saturation(this.col), b/2);
      pa.ellipse(this.loc.x, this.loc.y, this.rad, this.rad);
      if (this.bursting) {
        pa.noFill();
        pa.strokeWeight(2);
        pa.stroke(hue(this.col), saturation(this.col), max(0, (1-this.ringRad/maxRingRad)));
        pa.ellipse(this.loc.x, this.loc.y, 2*this.ringRad, 2*this.ringRad);
      }
    }
  }
}