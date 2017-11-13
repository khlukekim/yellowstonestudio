class Sun {

  float radius = 150;
  int nb = 1000;
  color orange = color(255, 105, 0);//orange: color(255, 165, 0);
  color white = color(255, 255, 255);
  boolean firstDisplay = true;

  public Sun() {
    console.log("new Sun");
  }

  public void draw() {
    if(firstDisplay){
      fill(orange);
      noStroke();
      ellipse(width/2, height/2, 2*(radius+1), 2*(radius+1));
      ellipse(10, 10, 20, 20);
      firstDisplay = false;
    }
    strokeWeight(2);
    translate(width/2, height/2);
    float theta, rad, x, y, d, lerpCoeff;
    for (int i = 0; i < nb; i ++) {
      theta = random(TWO_PI);
      rad = sqrt(random(radius*radius));

      x = rad * cos(theta);
      y = rad * sin(theta);

      d = dist(x, y, radius, radius);
      lerpCoeff = constrain(.9 * d / (2*radius) + random(-.2, .2), -10, 10);
      stroke(lerpColor(white, orange, lerpCoeff));
      
      point(x, y);
    }
  }
}

