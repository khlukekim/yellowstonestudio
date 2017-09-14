function DartBoard(p5, nRings, r) {
  this.p5 = p5;
  this.rings = [];
  this.nRings = nRings;
  this.r = r;
  this.ringColorOffset = 0;
  this.c1 = this.p5.color('#203070');
  this.c2 = this.p5.color('#dde050');

  this.init();
}

DartBoard.prototype.init = function() {
  this.rings = [];
  if (this.nRings > 0) {
    var ringThickness = this.r / this.nRings;
    var ballImage = {width:1};

    for(var i = 0; i< this.nRings; i++) {
      this.rings.push(new Ring(
        this.p5, ringThickness * i  + 1, ringThickness * (i+1) - 4,
        this.p5.width/2, this.p5.height/2, ballImage,
        this.p5.min(this.p5.width, this.p5.height) / 2 / ballImage.width/2
      ));
      this.rings[i].angularSpeed = this.p5.random(0.020)-0.01;

    }
    this.setColor();
  }


};

DartBoard.prototype.draw = function () {
  for (var i = 0; i<this.rings.length; i++) {
    this.rings[i].draw();
    this.rings[i].update();
  }
};

DartBoard.prototype.setColor = function() {
  for(var i = 0; i < this.nRings; i++) {
    this.rings[this.nRings - i - 1].fillColor = this.p5.lerpColor(this.c1, this.c2, 1.0*((i+this.ringColorOffset)%this.nRings)/(this.rings.length-1))
    this.rings[this.nRings-i-1].randomizeColor();
  }
};

DartBoard.prototype.mousePressed = function() {
  this.ringColorOffset += 0.3;
  this.setColor();
};