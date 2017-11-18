class Particle {
  PGraphics pg;
  PVector speed, pos;
  float theta, radius;
  int age = 0;
  int death = int(random(100, 100));
  color c = color(random(190, 255), random(50, 120), random(0, 100));

  public Particle(float _radius, float _theta, PGraphics _pg) {
    name = "Particle";
    radius = _radius;
    theta = _theta;
    pos = new PVector(radius * cos(theta), radius * sin(theta));
    speed = pos.get();
    speed.normalize();
    speed.mult(volume * 50 * random(.9, 1.1));
    speed.rotate(random(-.7, .7));
  }

  public Boolean display(PGraphics _pg) {
    // console.log("Particle display");
    pos.add(speed);
    _pg.noStroke();
    _pg.fill(c, map(age, 0, death, 255, 0));
    float diameter = map(speed.mag(), 0, 10, 2, 10);
    _pg.ellipse(pos.x, pos.y, diameter, diameter);

    PVector tmpVec = pos.get();
    tmpVec.mult(-.0002);
    speed.add(tmpVec);
    speed.mult(.97);

    age++;
    return age > death || pos.mag() < radius;
  }
}

