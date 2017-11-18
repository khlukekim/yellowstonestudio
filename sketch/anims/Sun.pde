class Sun extends AnimationBase {
  float radius = 150;
  int nb = 1000;
  color orange = color(255, 105, 0);//orange: color(255, 165, 0);
  color white = color(255, 255, 255);
  PGraphics partsPg, sunPg;
  ArrayList<Particles> particles;

  public Sun() {
    name = "Sun";
    firstDisplay = true;
  }

  private void init(){
    partsPg = createGraphics(width, height);
    partsPg.translate(width/2, height/2);

    sunPg = createGraphics(2 * radius, 2 * radius);
    sunPg.translate(radius, radius);
    sunPg.strokeWeight(2);
    // sunPg.fill(orange);
    // sunPg.noStroke();
    // sunPg.ellipse(0, 0, 2*(radius+1), 2*(radius+1));
    firstDisplay = false;

    particles = new ArrayList<Particle>();
    console.log("particles: " + particles);
  }

  public void display() {
    // console.log("Sun display");
    if(firstDisplay){
      init();
    }
    
    // partsPg.noStroke();
    // partsPg.fill(0, 80);
    // partsPg.rect(-width/2, 0, width, height);

    displayParts();
    displaySun();
  }

  void displaySun(){
    float theta, rad, x, y, d, lerpCoeff;
    for (int i = 0; i < nb; i ++) {
      theta = random(TWO_PI);
      rad = sqrt(random(radius*radius));

      x = rad * cos(theta);
      y = rad * sin(theta);

      d = dist(x, y, radius, radius);
      lerpCoeff = constrain(d / (2*radius*sqrt(2)) + random(-.1, .15), 0, 1);
      // console.log("lerpCoeff: " + lerpCoeff)
      sunPg.stroke(lerpColor(white, orange, lerpCoeff));
      sunPg.point(x, y);
    }
    image(sunPg, width/2 - radius, height/2 - radius);
  }

  void displayParts(){
    // produce particles
    float birthCoeff = .9;
    if(volume > .02 
      && particles.size() < 300
      && volume > birthCoeff * prevVolume){
      float nbNewPart = map(volume / (.001 + birthCoeff * prevVolume), 1, 100, 3, 20);
      float partAngle = int(random(10)) * TWO_PI / 10;
      for(int i = 0; i < nbNewPart; i ++){
        particles.add(new Particle(radius, partAngle, partsPg));
      }
    }

    // show particles
    partsPg.background(0, 0);
    for (int i = particles.size() - 1; i >= 0; i--) {
      if (particles.get(i).display(partsPg)) {
        particles.remove(i);
      }
    }
    
    image(partsPg, 0, 0);
  }
}







