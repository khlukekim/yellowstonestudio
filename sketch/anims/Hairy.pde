class Hairy extends AnimationBase {
  float radius = 150;
  int nb = 800;
  PGraphics pg;
  Hair[] hairs;
  PVector noiseRoot = new PVector(random(123), random(123));
  PVector noiseSpeed = new PVector(random(-.02, .02), random(-.02, .02));

  public Hairy() {
    name = "Hairy";
    firstDisplay = true;
    console.log("Hairy");
  }

  private void init(){
    console.log("Hairy init");
    pg = createGraphics(width, height);
    pg.translate(width/2, height/2);
    firstDisplay = false;

    hairs = new Hair[nb];
    for(int i = 0; i < nb; i ++){
      hairs[i] = new Hair(radius);
    }
  }

  public void display() {
    // console.log("RENAME ME display");
    // console.log("Sun display");
    if(firstDisplay){
      init();
    }
    
    // show particles
    pg.background(0, 0);
    for (int i = 0; i < nb; i++) {
      hairs[i].display(pg, noiseRoot);
    }

    PVector tmpNoiseSpeed = noiseSpeed.get();
    tmpNoiseSpeed.mult(1 + 50 * volume);
    noiseRoot.add(tmpNoiseSpeed);

    pg.stroke(80, min(volumeFx * 1500, 255), 190);

    image(pg, 0, 0);
  }
}

class Hair{
  int nbSegments = (int)random(4, 8);
  float sgmentsLength = random(3, 7);
  PVector pos;
  float[] angles = new float[nbSegments];

  public Hair(float _radius){
    float r = sqrt(random(_radius * _radius));
    pos = new PVector(r, 0);
    pos.rotate(random(TWO_PI));
  }

  void display(PGraphics _pg, _noiseRoot){
    PVector curr, prev = pos.get();
    float n, tetha, det;

    for (int i = 0; i < nbSegments; i++){
      det = -abs((pmouseX - mouseX) * (mouseY - prev.y - height/2) - (pmouseY - mouseY) * (mouseX - prev.x - width/2));
      det /= dist(prev.x, prev.y, mouseX - width/2, mouseY - height/2);
      det /= dist(prev.x, prev.y, mouseX - width/2, mouseY - height/2);

      n = noise(_noiseRoot.x + prev.x/100, _noiseRoot.y + prev.y/100);
      n *= 2 * TWO_PI;
      n += det * 2 * TWO_PI;//mouse interaction
      tetha = angles[i] + .2 * (n - angles[i]) / (i+1);
      curr = new PVector(prev.x + sgmentsLength*cos(tetha), prev.y + sgmentsLength*sin(tetha));
      //      vertex(curr.x, curr.y);
      _pg.strokeWeight(map(i, 0, nbSegments - 1, 3, .5));
      _pg.line(prev.x, prev.y, curr.x, curr.y);
      prev = curr.get();
      angles[i] = tetha;
    }
  }
}







