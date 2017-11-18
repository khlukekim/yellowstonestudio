class RenameMe extends AnimationBase {
  float radius = 150;
  int nb = 500;
  PGraphics pg;
  Cell[] cells;

  public RenameMe() {
    name = "RenameMe";
    firstDisplay = true;
    console.log("RENAME ME");
  }

  private void init(){
    pg = createGraphics(width, height);
    pg.translate(width/2, height/2);
    pg.noStroke();
    firstDisplay = false;

    cells = new Cell[nb];
    for(int i = 0; i < nb; i ++){
      cells[i] = new Cell(radius, 0);
    }
    console.log("RENAME ME init");
  }

  public void display() {
    // console.log("RENAME ME display");
    // console.log("Sun display");
    if(firstDisplay){
      init();
    }
    
    // if(volume > .02 
    //   && particles.size() < 300
    //   && volume > birthCoeff * prevVolume){
    //   float nbNewPart = map(volume / (.001 + birthCoeff * prevVolume), 1, 100, 3, 20);
    //   float partAngle = int(random(5)) * TWO_PI / 5;
    //   for(int i = 0; i < nbNewPart; i ++){
    //     particles.add(new Particle(radius, partAngle, partsPg));
    //   }
    // }

    // show particles
    pg.background(0, 0);
    for (int i = 0; i < nb; i++) {
      cells[i].displayOutside(pg);
    }
    for (int i = 0; i < nb; i++) {
      cells[i].displayInside(pg);
    }
    
    image(pg, 0, 0);
  }
}

class Cell {
  PVector speed, pos;
  color insideColor = color(20, 12, 250);
  color outsideColor = color(140);
  float diameter;

  public Cell(float _radius, float _theta) {
    name = "Particle";
    radius = _radius;
    pos = new PVector(0, 0);
    speed = new PVector(random(.6, 1.3));
    speed.rotate(random(TWO_PI));
    // speed.normalize();
    // speed.mult(volume * 50 * random(.9, 1.1));
  }

  public void displayOutside(PGraphics _pg) {
    // console.log("Cell display");
    diameter = map(pos.mag(), 0, radius, 3, 10) + map(speed.mag(), 0, 10, 3, 6);
    _pg.fill(outsideColor);
    _pg.ellipse(pos.x, pos.y, diameter*2, diameter*2);
  }

  public Boolean displayInside(PGraphics _pg) {
    // console.log("Particle display");
    _pg.fill(insideColor);
    _pg.ellipse(pos.x, pos.y, diameter, diameter);

    // PVector tmpVec = pos.get();
    // tmpVec.mult(-.0002);
    // speed.add(tmpVec);
    // speed.mult(.97);
    updatePos();
  }

  void updatePos(){
    pos.add(speed);
    if(pos.mag() > radius){
      pos.normalize();
      pos.mult(radius);
      speed.mult(-1);
    }
    speed.mult(.98);

    float birthCoeff = .4;
    if(volume > .02 
      && volume > birthCoeff * prevVolume){
      speed.mult(1+volume);
    }

    speed.limit(4.5);
  }

}







