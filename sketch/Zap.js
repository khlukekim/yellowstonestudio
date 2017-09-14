function Zap(p5) {
  this.crystals = [];
  this.maxPower = 100;
  this.maxCrystals = 8;
  this.maxRingRad = 0;
  this.p5 = p5;

  this.init();
}

Zap.prototype.init = function(){
  this.crystals = [];
  this.maxRingRad = this.p5.min(this.p5.height, this.p5.width) * 0.2;
  this.crystals.push(new Crystal(this.p5, this.p5.width/2, this.p5.height/2));
  for(var i = 0; i < this.maxCrystals; i++){
    this.crystals.push(new Crystal(this.p5, this.p5.width/2 + this.p5.width/6 * this.p5.random(-1, 1), this.p5.height/2 - this.p5.height/6 * this.p5.random(-1, 1)));
  }
};

Zap.prototype.draw = function() {
  this.zaps();

  var trash = [];

  for(var i = 0; i<this.crystals.length; i++) {
    this.crystals[i].move();
    this.crystals[i].draw();
    if (this.crystals[i].removable) {
      trash.push(i);
    }
  }

  for(var i = 0; i<trash.length; i++) {
    this.crystals.splice(trash[i],1);
  }

  while(this.crystals.length < this.maxCrystals) {
    this.crystals.push(new Crystal(
      this.p5,
      this.p5.width/2 + this.p5.width/7 * this.p5.random(-1, 1),
      this.p5.height/2 - this.p5.height/4 * this.p5.random(-1, 1)
    ));
  }
}

Zap.prototype.zaps = function() {
  for(var i = 0; i < this.crystals.length; i++) {
    for(var j = 0; j<this.crystals.length; j++) {
      if(i == j) {
        continue;
      }
      var c1 = this.crystals[i];
      var c2 = this.crystals[j];
      var th = c1.rad * 6 * (1 + this.p5.pow(c1.power / this.maxPower - 1, 2) * this.p5.min(this.p5.width, this.p5.height) / 200);
      if (
        (this.p5.abs(c1.loc.x - c2.loc.x) < th && this.p5.abs(c1.loc.y - c2.loc.y) < th)
        || (c1.bursting && this.p5.abs(c1.loc.x - c2.loc.x) < c1.ringRad && this.p5.abs(c1.loc.y - c2.loc.y) < c1.ringRad)
        ) {
        this.doZap(c1, c2);
      }

    }
  }
};

Zap.prototype.doZap = function(c1,c2) {
  var start = c1.loc;
  var end = c2.loc;
  var diff = p5.Vector.sub(start, end);
  var dist = diff.mag();
  diff.normalize();
  diff.mult(((c1.power - this.maxPower/2) + (c2.power - this.maxPower/2))/this.maxPower);

  if (!c1.bursting) {
    c1.acc.sub(diff.mult(0.02));
    c1.power = this.p5.min(this.maxPower + 20, c1.power + 2);
  }
  if (c1.bursting) {
    c2.power += c1.power / 20;
    c1.power *= 0.95;
  }

  this.p5.strokeWeight(2);
  var numSteps = 5;
  var lx = start.x;
  var ly = start.y;
  var i = 0;
  while(i < numSteps && this.p5.abs(lx - end.x) > 10 || this.p5.abs(ly - end.y) > 10) {
    var x = lx + (end.x - lx) / numSteps + this.p5.random(-9, 9);
    var y = ly + (end.y - ly) / numSteps + this.p5.random(-9, 9);
    this.p5.stroke(this.p5.max(0, this.p5.min(1, this.p5.hue(c1.col) + this.p5.sin(this.p5.frameCount*0.05)*0.15)), 1, 1);
    this.p5.line(lx, ly, x, y);
    lx = x;
    ly = y;
    i ++;
  }
  this.p5.line(lx, ly, end.x, end.y);
};

function Crystal(p5, x, y) {
  this.p5 = p5;
  this.maxPower = 100;
  this.loc = this.p5.createVector(x, y);
  this.speed = this.p5.createVector(0, 0);
  this.acc = this.p5.createVector(0, 0);
  this.rad = 20;
  this.power = this.maxPower / 2;
  this.maxRingRad = this.p5.min(this.p5.height, this.p5.width) * 0.2;
  this.ringRad = this.rad;
  var b = this.p5.max(0, (1 - this.p5.pow((this.power/this.maxPower-1), 2)));
  this.col = this.p5.color(this.p5.max(0, 1 - this.power/this.maxPower), 0.7, b);
}

Crystal.prototype.move = function() {
  var cx = this.p5.width/2;
  var cy = this.p5.height / 2;
  var dc = this.p5.createVector(this.loc.y - cy, -this.loc.x + cx);
  var l = dc.mag();
  dc.normalize();
  dc.mult(l/500);
  this.acc.mult(0.4);
  this.speed.mult(0.95);
  this.speed.add(dc);
  this.speed.sub(this.p5.createVector(this.loc.x - cx, this.loc.y - cy).normalize().mult(l/700));
  this.speed.add(this.acc);
  this.loc.add(this.speed);

  if (this.loc.x <= 0 + this.rad) {
    this.loc.x = this.rad;
    this.acc.x = this.p5.abs(this.acc.x);
    this.speed.x = this.p5.abs(this.speed.x);
  }
  else if (this.loc.x >= this.p5.width - this.rad) {
    this.loc.x = this.p5.width - this.rad;
    this.acc.x = -this.p5.abs(this.acc.x);
    this.speed.x = -this.p5.abs(this.speed.x);
  }
  if (this.loc.y <= 0 + this.rad) {
    this.loc.y = this.rad;
    this.acc.y = this.p5.abs(this.acc.y);
    this.speed.y = this.p5.abs(this.speed.y);
  }
  else if (this.loc.y >= this.p5.height - this.rad) {
    this.loc.y = this.p5.height - this.rad;
    this.acc.y = -this.p5.abs(this.acc.y);
    this.speed.y = -this.p5.abs(this.speed.y);
  }

  if (this.power > this.maxPower && ! this.bursting)
    this.bursting = true;
  if (this.bursting) {
    this.ringRad += 5 + this.p5.abs((this.maxRingRad-this.ringRad)/this.maxRingRad*10);
    this.rad = this.p5.max(16, this.rad*0.95);
    if (this.ringRad > this.maxRingRad) {
      this.bursting = false;
      //this.removable = true;
    }
  }
  else{
    this.ringRad = this.rad;
  }

  this.power = this.p5.max(0, this.power-0.5);

  if (this.power <= 0){
    this.power = this.maxPower * 0.8;
        //this.removable = true;
  }
};

Crystal.prototype.draw = function() {
  var b = this.p5.max(0, (1 - this.p5.pow((this.power/this.maxPower-1), 2)));
  this.col = this.p5.color(this.p5.max(0, 1 - this.power/this.maxPower), 0.7, b);
  this.p5.noStroke();
  this.p5.fill(this.col);
  this.p5.ellipse(this.loc.x, this.loc.y, 2*this.rad, 2*this.rad);
  this.p5.fill(this.p5.hue(this.col), this.p5.saturation(this.col), b/2);
  this.p5.ellipse(this.loc.x, this.loc.y, this.rad, this.rad);
  if (this.bursting) {
    this.p5.noFill();
    this.p5.strokeWeight(2);
    this.p5.stroke(this.p5.hue(this.col), this.p5.saturation(this.col), this.p5.max(0, (1-this.ringRad/this.maxRingRad)));
    this.p5.ellipse(this.loc.x, this.loc.y, 2*this.ringRad, 2*this.ringRad);
  }
}