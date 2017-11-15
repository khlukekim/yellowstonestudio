class Sun extends AnimationBase {
  float radius = 150;
  int nb = 1000;
  color orange = color(255, 105, 0);//orange: color(255, 165, 0);
  color white = color(255, 255, 255);
  PGraphics pg;

  public Sun() {
    name = "Sun";
    firstDisplay = true;
  }

  private void init(){
    pg = createGraphics(width, height);
    pg.translate(width/2, height/2);
    pg.strokeWeight(2);
    // pg.fill(orange);
    // pg.noStroke();
    // pg.ellipse(0, 0, 2*(radius+1), 2*(radius+1));
    firstDisplay = false;
  }

  public void display() {
    // console.log("Sun display");
    if(firstDisplay){
      init();
    }
    float theta, rad, x, y, d, lerpCoeff;
    for (int i = 0; i < nb; i ++) {
      theta = random(TWO_PI);
      rad = sqrt(random(radius*radius));

      x = rad * cos(theta);
      y = rad * sin(theta);

      d = dist(x, y, radius, radius);
      lerpCoeff = constrain(d / (2*radius*sqrt(2)) + random(-.1, .15), 0, 1);
      // console.log("lerpCoeff: " + lerpCoeff)
      pg.stroke(lerpColor(white, orange, lerpCoeff));
      
      pg.point(x, y);

    }
    image(pg, 0, 0);
  }
}

