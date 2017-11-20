class ColorRings extends AnimationBase {
  float radiusMin = 100;
  float strokeMin = 30;
  int nb = 50;
  PGraphics pg;
  int[] hues;
  PVector[] positions;
  int freq = 5;//change positions every [freq] frames
  int count = -1;
  
  public ColorRings() {
    name = "Color Rings";
    firstDisplay = true;
    console.log("Color Rings");
  }

  private void init(){
    console.log("ColorRings init");
    pg = createGraphics(width, height);
    pg.translate(width/2, height/2);
    pg.colorMode(HSB);
    pg.noFill();
    positions = new int[nb];
    initPositions();
    hues = new int[nb];
    for(int i = 0; i < nb; i ++){
      hues[i] = random(255);
    }
    firstDisplay = false;
  }

  private void initPositions(){
    for(int i = 0; i < nb; i ++){
      positions[i] = new PVector(random(-20, 20), random(-20, 20));
    }
  }

  public void display() {
    // console.log("RENAME ME display");
    // console.log("Sun display");
    if(firstDisplay){
      init();
    }
    if(count % freq == 0){
      initPositions();
      count = 0;
    }
    pg.background(0);
    pg.strokeWeight(strokeMin * (1 + 15 * volumeFx));
    float diam = 2 * radiusMin * (1 + 10 * volumeFx);
    for (int i = 0; i < nb; i++) {
      pg.stroke(hues[i], 235, 235, 65);
      pg.ellipse(positions[i].x, positions[i].y, diam, diam);
    }
    count ++;
    image(pg, 0, 0);
  }
}









