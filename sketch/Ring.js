function Ring(p5, innerR, outerR, x, y, textureImage, screenBallRatio) {
  this.innerR = innerR;
  this.outerR = outerR;
  this.x = x;
  this.y = y;
  this.noiseZ = innerR;
  this.p5 = p5;
  this.noPies = 100;
  this.fillColor = this.p5.color('#ff9940');
  this.fillColors = [];
  this.innerPoints = [];
  this.outerPoints = [];
  this.textureInnerPoints = [];
  this.textureOuterPoints = [];
  this.angleOffset = 0;
  this.angularSpeed = 0;
  this.innerRMod = 1;
  this.outerRMod = 1;
  this.useOuterNoise = true;
  this.anglePerPie = 2 * this.p5.PI / this.noPies;
  this.drawSeparate = true;
  this.useFillColor = true;
  this.useTint = false;
  this.alpha = 1;
  this.textureImage = textureImage;
  this.textureImageCenter = this.p5.createVector(this.textureImage.width/2, this.textureImage.height/2);
  this.screenBallRatio = screenBallRatio;
  this.init();
}

Ring.prototype.init = function() {
  this.innerPoints = [];
  this.outerPoints = [];
  this.textureInnerPoints = [];
  this.textureOuterPoints = [];
  for (var i = 0; i<this.noPies; i++) {
    this.innerPoints[i] = this.p5.createVector();
    this.outerPoints[i] = this.p5.createVector();
    this.textureInnerPoints[i] = this.p5.createVector();
    this.textureOuterPoints[i] = this.p5.createVector();
    this.fillColors[i] = this.fillColor;
  }

  this.calculateControlPoints();
  this.remapTexture();
};

Ring.prototype.calculateControlPoints = function(mod){
  var angle = this.angleOffset;
  for (var i = 0; i<this.noPies; i++) {
    var r = this.innerR * this.innerRMod * mod;
    this.innerPoints[i].set(r*this.p5.cos(angle), r*this.p5.sin(angle));
    if(this.useOuterNoise) {
      r = mod * (0.9 + this.p5.pow(1000, this.outerRMod - 1) * 0.1) * this.outerR * this.outerRMod;
    } else {
      r = mod * this.outerR * this.outerRMod;
    }
    this.outerPoints[i].set(r*this.p5.cos(angle), r*this.p5.sin(angle));
    angle += this.anglePerPie;
  }
};

Ring.prototype.remapTexture = function(){
  var angle = this.angleOffset;
  for(var i = 0; i < this.noPies; i++) {
    this.textureInnerPoints[i].set((this.innerR-1) * this.p5.cos(angle), (this.innerR - 1) * this.p5.sin(angle));
    this.textureOuterPoints[i].set((this.outerR - 1) * this.p5.cos(angle), (this.outerR - 1) * this.p5.sin(angle));
    angle += this.anglePerPie;
  }
};

Ring.prototype.update = function(mic) {
  //fade();
  this.angleOffset += this.angularSpeed;
  //remapTexture();
  this.calculateControlPoints(1 + this.p5.sqrt(mic)/2);
};

Ring.prototype.draw = function(mic) {
  this.p5.push();
  if (this.drawSeparate) {
    this.p5.noStroke();
    for (var i = 0; i < this.noPies; i++) {
      if (this.useTint) {
        this.p5.tint(this.fillColors[i], this.alpha);
        this.p5.texture(this.textureImage);
      } else if (this.useFillColor) {
        this.p5.fill(this.fillColors[i], this.alpha);
        this.p5.stroke(this.fillColors[i], this.alpha);
      } else {
        this.p5.texture(this.textureImage);
      }

      var j = i + 1;
      if (j >= this.noPies) {
        j = 0;
      }

      this.p5.beginShape();
      this.p5.vertex(
        this.x + this.outerPoints[i].x,
        this.y + this.outerPoints[i].y
        //this.textureImageCenter.x + this.textureOuterPoints[i].x / this.screenBallRatio,
        //this.textureImageCenter.y + this.textureOuterPoints[i].y / this.screenBallRatio
      );
      this.p5.vertex(
        this.x + this.outerPoints[j].x,
        this.y + this.outerPoints[j].y
        //this.textureImageCenter.x + this.textureOuterPoints[j].x / this.screenBallRatio,
        //this.textureImageCenter.y + this.textureOuterPoints[j].y / this.screenBallRatio
      );
      this.p5.vertex(
        this.x + this.innerPoints[j].x,
        this.y + this.innerPoints[j].y
        //this.textureImageCenter.x + this.textureInnerPoints[j].x / this.screenBallRatio,
        //this.textureImageCenter.y + this.textureInnerPoints[j].y / this.screenBallRatio
      );
      this.p5.vertex(
        this.x + this.innerPoints[i].x,
        this.y + this.innerPoints[i].y
        //this.textureImageCenter.x + this.textureInnerPoints[i].x / this.screenBallRatio,
        //this.textureImageCenter.y + this.textureInnerPoints[i].y / this.screenBallRatio
      );
      this.p5.endShape();
    }
  }
  this.p5.pop();
};

Ring.prototype.randomizeColor = function() {
  for(var i = 0; i<this.noPies;) {
    var mod = 0.2;

    var c = this.p5.color(this.p5.hue(this.fillColor) + mod * (this.p5.noise(this.p5.random()) - 0.5), this.p5.saturation(this.fillColor) + mod * (this.p5.noise(this.p5.random()) - 0.5),this.p5.brightness(this.fillColor) + mod * (this.p5.noise(this.p5.random()) - 0.5));
    for (var j = 0; j<5; j++) {
      this.fillColors[i] = c;
      i ++;
    }
  }
};